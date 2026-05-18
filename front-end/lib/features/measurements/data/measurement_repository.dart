import 'package:isar_community/isar.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/models/health_measurement.dart';

class MeasurementRepository {
  MeasurementRepository({AppDatabase? database})
      : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<void> saveMeasurement({
    required String type,
    required double primaryValue,
    double? secondaryValue,
    required String unit,
    String? notes,
    DateTime? measuredAt,
  }) async {
    final measurement = HealthMeasurement()
      ..type = type
      ..primaryValue = primaryValue
      ..secondaryValue = secondaryValue
      ..unit = unit
      ..measuredAt = measuredAt ?? DateTime.now()
      ..notes = notes;

    await _database.isar.writeTxn(() async {
      await _database.isar.healthMeasurements.put(measurement);
    });
  }

  Future<void> saveBatchMeasurements(List<HealthMeasurement> measurements) async {
    await _database.isar.writeTxn(() async {
      await _database.isar.healthMeasurements.putAll(measurements);
    });
  }

  Future<List<HealthMeasurement>> getMeasurements({
    String? type,
    DateTime? start,
    DateTime? end,
  }) async {
    var query = _database.isar.healthMeasurements.filter().idGreaterThan(-1);

    if (type != null) {
      query = query.typeEqualTo(type, caseSensitive: false);
    }
    
    if (start != null && end != null) {
      query = query.measuredAtBetween(start, end);
    }

    final results = await query.findAll();
    results.sort((a, b) => b.measuredAt.compareTo(a.measuredAt));
    
    return results;
  }

  Future<void> deleteMeasurement(int id) async {
    await _database.isar.writeTxn(() async {
      await _database.isar.healthMeasurements.delete(id);
    });
  }
}
