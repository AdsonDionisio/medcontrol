import 'package:isar_community/isar.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/models/dose_record.dart';

class DoseRepository {
  DoseRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<DoseRecord> saveRecord({
    int? id,
    required int medicationId,
    int? scheduleId,
    required DateTime scheduledFor,
    DateTime? takenAt,
    required String status,
    String? notes,
  }) async {
    // Check if already exists for the same day, medication, schedule
    final startOfDay = DateTime(
      scheduledFor.year,
      scheduledFor.month,
      scheduledFor.day,
    );
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final existing = await _database.isar.doseRecords
        .filter()
        .medicationIdEqualTo(medicationId)
        .scheduleIdEqualTo(scheduleId)
        .scheduledForBetween(startOfDay, endOfDay)
        .findFirst();

    DoseRecord? record;
    if (existing != null) {
      record = existing;
    } else {
      record = DoseRecord()
        ..medicationId = medicationId
        ..scheduleId = scheduleId
        ..scheduledFor = scheduledFor;
    }

    record
      ..takenAt = takenAt
      ..status = status
      ..notes = notes;

    await _database.isar.writeTxn(() async {
      await _database.isar.doseRecords.put(record!);
    });

    return record;
  }

  Future<List<DoseRecord>> getRecordsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    return _database.isar.doseRecords
        .filter()
        .scheduledForBetween(start, end)
        .sortByScheduledForDesc()
        .findAll();
  }

  Future<void> deleteRecord(int id) async {
    await _database.isar.writeTxn(() async {
      await _database.isar.doseRecords.delete(id);
    });
  }
}
