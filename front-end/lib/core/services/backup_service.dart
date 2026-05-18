import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../database/app_database.dart';
import '../../database/models/patient.dart';
import '../../database/models/medication.dart';
import '../../database/models/medication_schedule.dart';
import '../../database/models/dose_record.dart';
import '../../database/models/health_measurement.dart';
import '../../database/models/app_settings.dart';

class BackupService {
  // TODO: Configure this URL based on your backend deployment
  static const String _baseUrl = 'http://localhost:8000';

  final http.Client _client;

  BackupService({http.Client? client}) : _client = client ?? http.Client();

  /// Creates a backup of all patient data
  Future<BackupResult> createBackup() async {
    try {
      final db = AppDatabase.instance;

      // Get patient data
      final patient = await db.isar.patients.get(1);
      if (patient == null) {
        throw BackupException('No patient data found');
      }

      // Get all related data
      final medications = await db.isar.medications.where().findAll();
      final schedules = await db.isar.medicationSchedules.where().findAll();
      final history = await db.isar.doseRecords.where().findAll();
      final healthMeasurements = await db.isar.healthMeasurements
          .where()
          .findAll();
      final settings = await db.isar.appSettings.get(1);

      // Prepare backup data
      final backupData = {
        'patient_id': patient.id.toString(),
        'patient_name': patient.name,
        'patient_age': patient.age,
        'medications': medications
            .map(
              (m) => {
                'id': m.id,
                'name': m.name,
                'dosage': m.dosage,
                'instructions': m.instructions,
                'created_at': m.createdAt?.toIso8601String(),
              },
            )
            .toList(),
        'schedules': schedules
            .map(
              (s) => {
                'id': s.id,
                'medication_id': s.medicationId,
                'time_label': s.timeLabel,
                'recurrence': s.recurrence,
                'interval_days': s.intervalDays,
                'notifications_enabled': s.notificationsEnabled,
                'created_at': s.createdAt.toIso8601String(),
                'updated_at': s.updatedAt.toIso8601String(),
              },
            )
            .toList(),
        'history': history
            .map(
              (h) => {
                'id': h.id,
                'medication_id': h.medicationId,
                'schedule_id': h.scheduleId,
                'scheduled_for': h.scheduledFor.toIso8601String(),
                'taken_at': h.takenAt?.toIso8601String(),
                'status': h.status,
                'notes': h.notes,
              },
            )
            .toList(),
        'health_measurements': healthMeasurements
            .map(
              (hm) => {
                'id': hm.id,
                'type': hm.type,
                'value': hm.value,
                'unit': hm.unit,
                'recorded_at': hm.recordedAt.toIso8601String(),
                'notes': hm.notes,
              },
            )
            .toList(),
        'settings': settings != null
            ? {'snooze_minutes': settings.snoozeMinutes}
            : {},
      };

      // Send to backend
      final response = await _client.post(
        Uri.parse('$_baseUrl/backups'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(backupData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return BackupResult.success(
          backupId: responseData['id'],
          patientName: responseData['patient_name'],
          createdAt: DateTime.parse(responseData['created_at']),
          sizeBytes: responseData['size_bytes'],
        );
      } else {
        throw BackupException(
          'Failed to create backup: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is BackupException) {
        rethrow;
      }
      throw BackupException('Unexpected error: $e');
    }
  }

  /// Lists all available backups
  Future<List<BackupInfo>> listBackups() async {
    try {
      final response = await _client.get(Uri.parse('$_baseUrl/backups'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map(
              (item) => BackupInfo(
                id: item['id'],
                patientId: item['patient_id'],
                patientName: item['patient_name'],
                createdAt: DateTime.parse(item['created_at']),
                sizeBytes: item['size_bytes'],
              ),
            )
            .toList();
      } else {
        throw BackupException('Failed to list backups: ${response.statusCode}');
      }
    } catch (e) {
      if (e is BackupException) {
        rethrow;
      }
      throw BackupException('Unexpected error: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

class BackupResult {
  final bool success;
  final String? backupId;
  final String? patientName;
  final DateTime? createdAt;
  final int? sizeBytes;
  final String? errorMessage;

  BackupResult._({
    required this.success,
    this.backupId,
    this.patientName,
    this.createdAt,
    this.sizeBytes,
    this.errorMessage,
  });

  factory BackupResult.success({
    required String backupId,
    required String patientName,
    required DateTime createdAt,
    required int sizeBytes,
  }) {
    return BackupResult._(
      success: true,
      backupId: backupId,
      patientName: patientName,
      createdAt: createdAt,
      sizeBytes: sizeBytes,
    );
  }

  factory BackupResult.error(String message) {
    return BackupResult._(success: false, errorMessage: message);
  }
}

class BackupInfo {
  final String id;
  final String patientId;
  final String patientName;
  final DateTime createdAt;
  final int sizeBytes;

  BackupInfo({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.createdAt,
    required this.sizeBytes,
  });
}

class BackupException implements Exception {
  final String message;
  BackupException(this.message);

  @override
  String toString() => 'BackupException: $message';
}
