from __future__ import annotations

from datetime import UTC, datetime
import json

from fastapi import FastAPI, File, HTTPException, UploadFile, status

from .config import get_settings
from .schemas import BackupListItem, BackupPayload, BackupStoredResponse
from .services import BackupStorageService


settings = get_settings()
backup_service = BackupStorageService(settings)

app = FastAPI(
    title=settings.project_name,
    version="0.1.0",
    description="API FastAPI para receber e armazenar backups do aplicativo MedControl.",
)


@app.get("/health")
def healthcheck() -> dict[str, str]:
    return {
        "status": "ok",
        "service": settings.project_name,
        "timestamp": datetime.now(tz=UTC).isoformat(),
    }


@app.get("/api/v1/backups", response_model=list[BackupListItem])
def list_backups() -> list[BackupListItem]:
    return backup_service.list_backups()


@app.post(
    "/api/v1/backups",
    response_model=BackupStoredResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_backup(payload: BackupPayload) -> BackupStoredResponse:
    return backup_service.save_payload(payload)


@app.post(
    "/api/v1/backups/upload",
    response_model=BackupStoredResponse,
    status_code=status.HTTP_201_CREATED,
)
async def upload_backup(
    file: UploadFile = File(...),
) -> BackupStoredResponse:
    if not file.filename:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="O arquivo enviado precisa ter um nome.",
        )

    if not file.filename.lower().endswith(".json"):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Somente arquivos JSON sao aceitos.",
        )

    try:
        content = await file.read()
        json.loads(content.decode("utf-8"))
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="O arquivo enviado nao contem um JSON valido.",
        ) from exc

    try:
        return backup_service.save_uploaded_json(
            file_name=file.filename,
            content=content,
            content_type=file.content_type,
        )
    except ValueError as exc:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail=f"Payload de backup invalido: {exc}",
        ) from exc

