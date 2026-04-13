import 'package:isar_community/isar.dart';

part 'dose_record.g.dart';

@collection
class DoseRecord {
  Id id = Isar.autoIncrement;

  @Index()
  late int medicationId;

  int? scheduleId;
  late DateTime scheduledFor;
  DateTime? takenAt;
  String status = 'pending';
  String? notes;
}
