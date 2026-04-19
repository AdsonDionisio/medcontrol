from __future__ import annotations

from datetime import datetime
from typing import Any

from pydantic import BaseModel, Field


class BackupMetadata(BaseModel):
    app: str = Field(..., min_length=1)
    version: int | str
    created_at: datetime = Field(..., alias="createdAt")


class BackupPayload(BaseModel):
    metadata: BackupMetadata
    data: dict[str, Any]


class BackupStoredResponse(BaseModel):
    backup_id: str
    file_name: str
    file_path: str
    content_type: str
    stored_at: datetime
    size_bytes: int


class BackupListItem(BaseModel):
    backup_id: str
    file_name: str
    stored_at: datetime
    size_bytes: int
