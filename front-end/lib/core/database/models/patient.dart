import 'package:isar_community/isar.dart';

part 'patient.g.dart';

@collection
class Patient {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index(caseSensitive: false)
  late String name;

  late int age;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
}
