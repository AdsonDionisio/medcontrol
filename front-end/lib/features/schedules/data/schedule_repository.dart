import 'package:isar_community/isar.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/models/medication_schedule.dart';

class ScheduleRepository {
  ScheduleRepository({
    AppDatabase? database,
  }) : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<List<MedicationSchedule>> getSchedulesByMedication(int medicationId) async {
    return _database.isar.medicationSchedules
        .filter()
        .medicationIdEqualTo(medicationId)
        .sortByTimeLabel()
        .findAll();
  }
  
  Future<List<MedicationSchedule>> getAllSchedules() async {
    return _database.isar.medicationSchedules
        .where()
        .sortByTimeLabel()
        .findAll();
  }

  Future<MedicationSchedule?> getScheduleById(int id) async {
    return _database.isar.medicationSchedules.get(id);
  }

  Future<MedicationSchedule> saveSchedule({
    int? id,
    required int medicationId,
    required String timeLabel,
    required String recurrence,
    int intervalDays = 1,
    bool notificationsEnabled = true,
  }) async {
    final now = DateTime.now();
    MedicationSchedule? schedule;

    if (id != null) {
      schedule = await _database.isar.medicationSchedules.get(id);
    }
    
    schedule ??= MedicationSchedule()
      ..createdAt = now
      ..medicationId = medicationId;

    schedule
      ..timeLabel = timeLabel
      ..recurrence = recurrence
      ..intervalDays = intervalDays
      ..notificationsEnabled = notificationsEnabled
      ..updatedAt = now;

    await _database.isar.writeTxn(() async {
      await _database.isar.medicationSchedules.put(schedule!);
    });

    return schedule;
  }

  Future<bool> deleteSchedule(int id) async {
    return _database.isar.writeTxn(() async {
      return _database.isar.medicationSchedules.delete(id);
    });
  }
}
