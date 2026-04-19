from __future__ import annotations

from dataclasses import dataclass
from datetime import UTC, datetime
import json
from pathlib import Path
import re
from typing import Iterable
from uuid import uuid4

from .config import Settings
from .schemas import BackupListItem, BackupPayload, BackupStoredResponse


@dataclass(frozen=True)
class StoredBackup:
    backup_id: str
    file_name: str
    file_path: Path
    content_type: str
    stored_at: datetime
    size_bytes: int


class BackupStorageService:
    def __init__(self, settings: Settings) -> None:
        self._settings = settings
        self._settings.backups_dir.mkdir(parents=True, exist_ok=True)

    def save_payload(self, payload: BackupPayload) -> BackupStoredResponse:
        json_bytes = json.dumps(
            payload.model_dump(mode="json", by_alias=True),
            ensure_ascii=False,
            indent=2,
        ).encode("utf-8")
        stored = self._write_bytes(
            json_bytes,
            content_type="application/json",
            client_created_at=payload.metadata.created_at,
            app_name=payload.metadata.app,
        )
        return self._to_response(stored)

    def save_uploaded_json(
        self,
        file_name: str,
        content: bytes,
        content_type: str | None,
    ) -> BackupStoredResponse:
        parsed = BackupPayload.model_validate(json.loads(content.decode("utf-8")))
        normalized_content = json.dumps(
            parsed.model_dump(mode="json", by_alias=True),
            ensure_ascii=False,
            indent=2,
        ).encode("utf-8")
        stored = self._write_bytes(
            normalized_content,
            content_type=content_type or "application/json",
            client_created_at=parsed.metadata.created_at,
            app_name=parsed.metadata.app,
            original_file_name=file_name,
        )
        return self._to_response(stored)

    def list_backups(self) -> list[BackupListItem]:
        items: list[BackupListItem] = []
        for file_path in sorted(
            self._settings.backups_dir.glob("*.json"),
            key=lambda item: item.stat().st_mtime,
            reverse=True,
        ):
            stat = file_path.stat()
            items.append(
                BackupListItem(
                    backup_id=file_path.stem.split("__", maxsplit=1)[0],
                    file_name=file_path.name,
                    stored_at=datetime.fromtimestamp(stat.st_mtime, tz=UTC),
                    size_bytes=stat.st_size,
                )
            )
        return items

    def _write_bytes(
        self,
        content: bytes,
        *,
        content_type: str,
        client_created_at: datetime,
        app_name: str,
        original_file_name: str | None = None,
    ) -> StoredBackup:
        stored_at = datetime.now(tz=UTC)
        backup_id = uuid4().hex
        safe_app_name = self._slugify(app_name) or "medcontrol"
        timestamp = client_created_at.astimezone(UTC).strftime("%Y%m%dT%H%M%SZ")

        file_name_parts: list[str] = [backup_id, safe_app_name, timestamp]
        if original_file_name:
            file_name_parts.append(self._slugify(Path(original_file_name).stem) or "backup")

        file_name = "__".join(file_name_parts) + ".json"
        file_path = self._settings.backups_dir / file_name
        file_path.write_bytes(content)

        return StoredBackup(
            backup_id=backup_id,
            file_name=file_name,
            file_path=file_path,
            content_type=content_type,
            stored_at=stored_at,
            size_bytes=len(content),
        )

    def _to_response(self, stored: StoredBackup) -> BackupStoredResponse:
        return BackupStoredResponse(
            backup_id=stored.backup_id,
            file_name=stored.file_name,
            file_path=str(stored.file_path),
            content_type=stored.content_type,
            stored_at=stored.stored_at,
            size_bytes=stored.size_bytes,
        )

    def _slugify(self, value: str) -> str:
        normalized = re.sub(r"[^a-zA-Z0-9_-]+", "-", value.strip())
        normalized = re.sub(r"-{2,}", "-", normalized)
        return normalized.strip("-_").lower()
