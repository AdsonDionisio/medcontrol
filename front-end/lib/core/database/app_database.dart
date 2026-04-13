import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'models/backup_settings.dart';
import 'models/dose_record.dart';
import 'models/health_measurement.dart';
import 'models/medication.dart';
import 'models/medication_schedule.dart';
import 'models/patient.dart';

class AppDatabase {
  AppDatabase({this.name = 'medcontrol'});

  static final AppDatabase instance = AppDatabase();

  final String name;
  Isar? _isar;

  Future<Isar> initialize({String? directory}) async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }

    final resolvedDirectory =
        directory ?? (await getApplicationDocumentsDirectory()).path;

    _isar = await Isar.open(
      [
        PatientSchema,
        MedicationSchema,
        MedicationScheduleSchema,
        DoseRecordSchema,
        HealthMeasurementSchema,
        BackupSettingsSchema,
      ],
      directory: resolvedDirectory,
      name: name,
      inspector: false,
    );

    return _isar!;
  }

  Isar get isar {
    final current = _isar;
    if (current == null || !current.isOpen) {
      throw StateError('O banco local ainda nao foi inicializado.');
    }

    return current;
  }

  Future<void> close() async {
    final current = _isar;
    if (current == null) {
      return;
    }

    await current.close();
    _isar = null;
  }
}
