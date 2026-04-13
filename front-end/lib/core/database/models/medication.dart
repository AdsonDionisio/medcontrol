import 'package:isar_community/isar.dart';

part 'medication.g.dart';

@collection
class Medication {
  Id id = Isar.autoIncrement;

  @Index()
  late String patientInternalId;

  @Index(caseSensitive: false)
  late String name;

  String? dosage;
  String? instructions;
  bool isActive = true;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
}
