import 'package:isar_community/isar.dart';

part 'health_measurement.g.dart';

@collection
class HealthMeasurement {
  Id id = Isar.autoIncrement;

  @Index(caseSensitive: false)
  late String type;

  late double primaryValue;
  double? secondaryValue;
  String? unit;
  DateTime measuredAt = DateTime.now();
  String? notes;
}
