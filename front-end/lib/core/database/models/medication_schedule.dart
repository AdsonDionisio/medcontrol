import 'package:isar_community/isar.dart';

part 'medication_schedule.g.dart';

@collection
class MedicationSchedule {
  Id id = Isar.autoIncrement;

  @Index()
  late int medicationId;

  late String timeLabel;
  String recurrence = 'daily';
  bool notificationsEnabled = true;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
}
