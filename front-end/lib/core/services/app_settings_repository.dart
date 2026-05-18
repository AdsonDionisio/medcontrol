import '../../../core/database/app_database.dart';
import '../../../core/database/models/app_settings.dart';

class AppSettingsRepository {
  AppSettingsRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<AppSettings> getSettings() async {
    final settings = await _database.isar.appSettings.get(1);

    if (settings != null) return settings;

    final newSettings = AppSettings();
    await _database.isar.writeTxn(() async {
      await _database.isar.appSettings.put(newSettings);
    });

    return newSettings;
  }

  Future<void> updateSnoozeMinutes(int minutes) async {
    final settings = await getSettings();
    settings.snoozeMinutes = minutes;

    await _database.isar.writeTxn(() async {
      await _database.isar.appSettings.put(settings);
    });
  }
}
