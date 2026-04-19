from __future__ import annotations

import io
import json
from pathlib import Path
import tempfile
import unittest

from fastapi.testclient import TestClient

import app.main as main_module
from app.config import Settings
from app.services import BackupStorageService


class BackupApiTests(unittest.TestCase):
    def setUp(self) -> None:
        self._temp_dir = tempfile.TemporaryDirectory()
        temp_path = Path(self._temp_dir.name)
        settings = Settings(
            project_name="MedControl Backup API Test",
            storage_dir=temp_path / "storage",
            backups_dir=temp_path / "storage" / "backups",
        )
        main_module.backup_service = BackupStorageService(settings)
        self.client = TestClient(main_module.app)

    def tearDown(self) -> None:
        self._temp_dir.cleanup()

    def test_healthcheck(self) -> None:
        response = self.client.get("/health")

        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertEqual(payload["status"], "ok")

    def test_create_backup_from_json(self) -> None:
        payload = {
            "metadata": {
                "app": "MedControl",
                "version": 1,
                "createdAt": "2026-04-18T12:00:00Z",
            },
            "data": {
                "patients": [{"internalId": "PAC-001", "name": "Maria"}],
                "medications": [],
            },
        }

        response = self.client.post("/api/v1/backups", json=payload)

        self.assertEqual(response.status_code, 201)
        body = response.json()
        self.assertTrue(body["file_name"].endswith(".json"))
        self.assertTrue(Path(body["file_path"]).exists())

    def test_upload_backup_file(self) -> None:
        content = {
            "metadata": {
                "app": "MedControl",
                "version": 1,
                "createdAt": "2026-04-18T12:00:00Z",
            },
            "data": {
                "patients": [{"internalId": "PAC-001", "name": "Jose"}],
                "medications": [],
            },
        }

        response = self.client.post(
            "/api/v1/backups/upload",
            files={
                "file": (
                    "medcontrol_backup.json",
                    io.BytesIO(json.dumps(content).encode("utf-8")),
                    "application/json",
                )
            },
        )

        self.assertEqual(response.status_code, 201)
        body = response.json()
        self.assertTrue(Path(body["file_path"]).exists())


if __name__ == "__main__":
    unittest.main()
