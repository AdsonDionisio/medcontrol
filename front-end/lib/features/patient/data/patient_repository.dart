import 'package:isar_community/isar.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/models/patient.dart';

class PatientRepository {
  PatientRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<Patient?> getCurrentPatient() async {
    return _database.isar.patients.where().sortByUpdatedAtDesc().findFirst();
  }

  Future<Patient> savePatient({required String name, required int age}) async {
    final now = DateTime.now();
    final existingPatient = await getCurrentPatient();
    final patient = existingPatient ?? Patient();

    patient.name = name.trim();
    patient.age = age;
    patient.updatedAt = now;
    patient.internalId =
        existingPatient?.internalId ?? _generateInternalId(now);

    await _database.isar.writeTxn(() async {
      await _database.isar.patients.put(patient);
    });

    return patient;
  }

  String _generateInternalId(DateTime now) {
    final year = now.year.toString().padLeft(4, '0');
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final suffix = (now.millisecondsSinceEpoch % 1000000).toString().padLeft(
      6,
      '0',
    );

    return 'PAC-$year$month$day-$suffix';
  }
}
