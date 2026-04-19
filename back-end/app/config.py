from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import os


@dataclass(frozen=True)
class Settings:
    project_name: str
    storage_dir: Path
    backups_dir: Path


def get_settings() -> Settings:
    base_dir = Path(__file__).resolve().parent.parent
    storage_dir = Path(
        os.getenv("MEDCONTROL_STORAGE_DIR", base_dir / "storage")
    ).resolve()
    backups_dir = storage_dir / "backups"

    return Settings(
        project_name="MedControl Backup API",
        storage_dir=storage_dir,
        backups_dir=backups_dir,
    )
