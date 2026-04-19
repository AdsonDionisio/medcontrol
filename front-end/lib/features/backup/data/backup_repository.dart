import 'dart:convert';
import 'dart:io';

import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/models/app_settings.dart';
import '../../../core/database/models/backup_settings.dart';
import '../../../core/database/models/dose_record.dart';
import '../../../core/database/models/health_measurement.dart';
import '../../../core/database/models/medication.dart';
import '../../../core/database/models/medication_schedule.dart';
import '../../../core/database/models/patient.dart';

class BackupRepository {
  BackupRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<BackupSettings> getSettings() async {
    final settings = await _database.isar.backupSettings.get(1);
    if (settings != null) {
      return settings;
    }

    final newSettings = BackupSettings();
    await _database.isar.writeTxn(() async {
      await _database.isar.backupSettings.put(newSettings);
    });
    return newSettings;
  }

  Future<BackupResult> createBackup({String? directory}) async {
    final exportDirectory = await _resolveBackupDirectory(directory);
    final createdAt = DateTime.now();

    final patients = await _database.isar.patients.where().findAll();
    final medications = await _database.isar.medications.where().findAll();
    final schedules = await _database.isar.medicationSchedules
        .where()
        .findAll();
    final doseRecords = await _database.isar.doseRecords.where().findAll();
    final measurements = await _database.isar.healthMeasurements
        .where()
        .findAll();
    final settings = await getSettings();
    final appSettings = await _getAppSettings();

    final payload = {
      'metadata': {
        'app': 'MedControl',
        'version': 1,
        'createdAt': createdAt.toIso8601String(),
      },
      'data': {
        'patients': patients.map(_patientToJson).toList(),
        'medications': medications.map(_medicationToJson).toList(),
        'schedules': schedules.map(_scheduleToJson).toList(),
        'doseRecords': doseRecords.map(_doseRecordToJson).toList(),
        'measurements': measurements.map(_measurementToJson).toList(),
        'backupSettings': _backupSettingsToJson(settings),
        'appSettings': _appSettingsToJson(appSettings),
      },
    };

    final fileName = 'medcontrol_backup_${_timestamp(createdAt)}.json';
    final file = File(
      '${exportDirectory.path}${Platform.pathSeparator}$fileName',
    );
    final encoder = const JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(payload));

    settings.lastBackupAt = createdAt;
    settings.lastBackupPath = file.path;
    settings.backupLocation = 'local';

    await _database.isar.writeTxn(() async {
      await _database.isar.backupSettings.put(settings);
    });

    return BackupResult(
      filePath: file.path,
      createdAt: createdAt,
      patientCount: patients.length,
      medicationCount: medications.length,
      scheduleCount: schedules.length,
      doseRecordCount: doseRecords.length,
      measurementCount: measurements.length,
    );
  }

  Future<Directory> _resolveBackupDirectory(String? directory) async {
    if (directory != null) {
      final customDirectory = Directory(directory);
      if (!await customDirectory.exists()) {
        await customDirectory.create(recursive: true);
      }
      return customDirectory;
    }

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final backupDirectory = Directory(
      '${documentsDirectory.path}${Platform.pathSeparator}medcontrol_backups',
    );

    if (!await backupDirectory.exists()) {
      await backupDirectory.create(recursive: true);
    }

    return backupDirectory;
  }

  Future<AppSettings> _getAppSettings() async {
    final currentSettings = await _database.isar.appSettings.get(1);
    if (currentSettings != null) {
      return currentSettings;
    }

    final newSettings = AppSettings();
    await _database.isar.writeTxn(() async {
      await _database.isar.appSettings.put(newSettings);
    });
    return newSettings;
  }

  Map<String, dynamic> _patientToJson(Patient patient) {
    return {
      'id': patient.id,
      'internalId': patient.internalId,
      'name': patient.name,
      'age': patient.age,
      'createdAt': patient.createdAt.toIso8601String(),
      'updatedAt': patient.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _medicationToJson(Medication medication) {
    return {
      'id': medication.id,
      'patientInternalId': medication.patientInternalId,
      'name': medication.name,
      'dosage': medication.dosage,
      'instructions': medication.instructions,
      'currentQuantity': medication.currentQuantity,
      'minimumQuantity': medication.minimumQuantity,
      'isActive': medication.isActive,
      'createdAt': medication.createdAt.toIso8601String(),
      'updatedAt': medication.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _scheduleToJson(MedicationSchedule schedule) {
    return {
      'id': schedule.id,
      'medicationId': schedule.medicationId,
      'timeLabel': schedule.timeLabel,
      'recurrence': schedule.recurrence,
      'intervalDays': schedule.intervalDays,
      'notificationsEnabled': schedule.notificationsEnabled,
      'createdAt': schedule.createdAt.toIso8601String(),
      'updatedAt': schedule.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _doseRecordToJson(DoseRecord record) {
    return {
      'id': record.id,
      'medicationId': record.medicationId,
      'scheduleId': record.scheduleId,
      'scheduledFor': record.scheduledFor.toIso8601String(),
      'takenAt': record.takenAt?.toIso8601String(),
      'status': record.status,
      'notes': record.notes,
    };
  }

  Map<String, dynamic> _measurementToJson(HealthMeasurement measurement) {
    return {
      'id': measurement.id,
      'type': measurement.type,
      'primaryValue': measurement.primaryValue,
      'secondaryValue': measurement.secondaryValue,
      'unit': measurement.unit,
      'measuredAt': measurement.measuredAt.toIso8601String(),
      'notes': measurement.notes,
    };
  }

  Map<String, dynamic> _backupSettingsToJson(BackupSettings settings) {
    return {
      'id': settings.id,
      'automaticBackupEnabled': settings.automaticBackupEnabled,
      'frequency': settings.frequency,
      'lastBackupAt': settings.lastBackupAt?.toIso8601String(),
      'backupLocation': settings.backupLocation,
      'lastBackupPath': settings.lastBackupPath,
    };
  }

  Map<String, dynamic> _appSettingsToJson(AppSettings settings) {
    return {'id': settings.id, 'snoozeMinutes': settings.snoozeMinutes};
  }

  String _timestamp(DateTime value) {
    final year = value.year.toString().padLeft(4, '0');
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');
    final buffer = StringBuffer()
      ..write(year)
      ..write(month)
      ..write(day)
      ..write('_')
      ..write(hour)
      ..write(minute)
      ..write(second);
    return buffer.toString();
  }
}

class BackupResult {
  const BackupResult({
    required this.filePath,
    required this.createdAt,
    required this.patientCount,
    required this.medicationCount,
    required this.scheduleCount,
    required this.doseRecordCount,
    required this.measurementCount,
  });

  final String filePath;
  final DateTime createdAt;
  final int patientCount;
  final int medicationCount;
  final int scheduleCount;
  final int doseRecordCount;
  final int measurementCount;
}
