import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import 'package:medcontrol_frontend/core/database/app_database.dart';
import 'package:medcontrol_frontend/core/database/models/patient.dart';
import 'package:medcontrol_frontend/features/backup/data/backup_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final localAppData = Platform.environment['LOCALAPPDATA'];
    final isarDllPath =
        '$localAppData\\Pub\\Cache\\hosted\\pub.dev\\isar_community_flutter_libs-3.3.2\\windows\\libisar.dll';

    await Isar.initializeIsarCore(libraries: {Abi.windowsX64: isarDllPath});
  });

  test('gera arquivo de backup local e atualiza as configuracoes', () async {
    final tempDirectory = await Directory.systemTemp.createTemp(
      'medcontrol_backup_repo_',
    );
    final database = AppDatabase(name: 'medcontrol_backup_repo');
    final backupRepository = BackupRepository(database: database);

    addTearDown(() async {
      await database.close();
      if (await tempDirectory.exists()) {
        await tempDirectory.delete(recursive: true);
      }
    });

    await database.initialize(directory: tempDirectory.path);

    final patient = Patient()
      ..internalId = 'PAC-20260418-000001'
      ..name = 'Ana Pereira'
      ..age = 68;

    await database.isar.writeTxn(() async {
      await database.isar.patients.put(patient);
    });

    final result = await backupRepository.createBackup(
      directory: tempDirectory.path,
    );
    final settings = await backupRepository.getSettings();
    final backupFile = File(result.filePath);

    expect(await backupFile.exists(), isTrue);
    expect(result.patientCount, 1);
    expect(settings.lastBackupAt, isNotNull);
    expect(settings.lastBackupPath, result.filePath);

    final content =
        jsonDecode(await backupFile.readAsString()) as Map<String, dynamic>;
    final data = content['data'] as Map<String, dynamic>;
    final patients = data['patients'] as List<dynamic>;

    expect(content['metadata'], isA<Map<String, dynamic>>());
    expect(patients, hasLength(1));
    expect((patients.first as Map<String, dynamic>)['name'], 'Ana Pereira');
  });
}
