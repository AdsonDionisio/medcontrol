from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime
import json
import os
import uuid
from pathlib import Path

app = FastAPI(title="MedControl Backup API", version="1.0.0")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify your frontend URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Backup storage directory
BACKUP_DIR = Path("storage/backups")
BACKUP_DIR.mkdir(parents=True, exist_ok=True)

class BackupData(BaseModel):
    patient_id: str
    patient_name: str
    patient_age: int
    medications: List[dict] = []
    schedules: List[dict] = []
    history: List[dict] = []
    settings: dict = {}

class BackupInfo(BaseModel):
    id: str
    patient_id: str
    patient_name: str
    created_at: datetime
    size_bytes: int

@app.get("/")
async def root():
    return {"message": "MedControl Backup API", "version": "1.0.0"}

@app.post("/backups", response_model=BackupInfo)
async def create_backup(backup_data: BackupData):
    """Create a new backup for a patient"""
    try:
        # Generate unique backup ID
        backup_id = str(uuid.uuid4())

        # Create backup filename
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"backup_{backup_data.patient_id}_{timestamp}_{backup_id[:8]}.json"
        filepath = BACKUP_DIR / filename

        # Prepare backup data
        backup_content = {
            "id": backup_id,
            "patient_id": backup_data.patient_id,
            "patient_name": backup_data.patient_name,
            "patient_age": backup_data.patient_age,
            "created_at": datetime.now().isoformat(),
            "data": {
                "medications": backup_data.medications,
                "schedules": backup_data.schedules,
                "history": backup_data.history,
                "settings": backup_data.settings
            }
        }

        # Save backup to file
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(backup_content, f, ensure_ascii=False, indent=2)

        # Get file size
        size_bytes = filepath.stat().st_size

        return BackupInfo(
            id=backup_id,
            patient_id=backup_data.patient_id,
            patient_name=backup_data.patient_name,
            created_at=datetime.now(),
            size_bytes=size_bytes
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to create backup: {str(e)}")

@app.get("/backups", response_model=List[BackupInfo])
async def list_backups(patient_id: Optional[str] = None):
    """List all backups, optionally filtered by patient_id"""
    try:
        backups = []

        for filepath in BACKUP_DIR.glob("*.json"):
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    data = json.load(f)

                backup_info = BackupInfo(
                    id=data["id"],
                    patient_id=data["patient_id"],
                    patient_name=data["patient_name"],
                    created_at=datetime.fromisoformat(data["created_at"]),
                    size_bytes=filepath.stat().st_size
                )

                if patient_id is None or data["patient_id"] == patient_id:
                    backups.append(backup_info)

            except (json.JSONDecodeError, KeyError, ValueError):
                # Skip corrupted backup files
                continue

        # Sort by creation date (newest first)
        backups.sort(key=lambda x: x.created_at, reverse=True)

        return backups

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to list backups: {str(e)}")

@app.get("/backups/{backup_id}")
async def get_backup(backup_id: str):
    """Get a specific backup by ID"""
    try:
        for filepath in BACKUP_DIR.glob("*.json"):
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    data = json.load(f)

                if data["id"] == backup_id:
                    return data

            except (json.JSONDecodeError, KeyError):
                continue

        raise HTTPException(status_code=404, detail="Backup not found")

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to get backup: {str(e)}")

@app.delete("/backups/{backup_id}")
async def delete_backup(backup_id: str):
    """Delete a specific backup by ID"""
    try:
        for filepath in BACKUP_DIR.glob("*.json"):
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    data = json.load(f)

                if data["id"] == backup_id:
                    filepath.unlink()  # Delete the file
                    return {"message": f"Backup {backup_id} deleted successfully"}

            except (json.JSONDecodeError, KeyError):
                continue

        raise HTTPException(status_code=404, detail="Backup not found")

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to delete backup: {str(e)}")

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "timestamp": datetime.now().isoformat()}