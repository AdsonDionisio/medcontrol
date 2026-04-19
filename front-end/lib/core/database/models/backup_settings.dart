import 'package:isar_community/isar.dart';

part 'backup_settings.g.dart';

@collection
class BackupSettings {
  BackupSettings({this.id = 1});

  Id id;
  bool automaticBackupEnabled = false;
  String frequency = 'weekly';
  DateTime? lastBackupAt;
  String backupLocation = 'local';
  String? lastBackupPath;
}
