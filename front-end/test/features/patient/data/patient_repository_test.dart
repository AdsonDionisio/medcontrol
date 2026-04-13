import 'dart:ffi';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import 'package:medcontrol_frontend/core/database/app_database.dart';
import 'package:medcontrol_frontend/features/patient/data/patient_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final localAppData = Platform.environment['LOCALAPPDATA'];
    final isarDllPath =
        '$localAppData\\Pub\\Cache\\hosted\\pub.dev\\isar_community_flutter_libs-3.3.2\\windows\\libisar.dll';

    await Isar.initializeIsarCore(libraries: {Abi.windowsX64: isarDllPath});
  });

  test('abre o banco local com os schemas do MVP', () async {
    final tempDirectory = await Directory.systemTemp.createTemp(
      'medcontrol_isar_open_',
    );
    final database = AppDatabase(name: 'medcontrol_isar_open');
    final repository = PatientRepository(database: database);

    addTearDown(() async {
      await database.close();
      if (await tempDirectory.exists()) {
        await tempDirectory.delete(recursive: true);
      }
    });

    final isar = await database.initialize(directory: tempDirectory.path);
    final patient = await repository.getCurrentPatient();

    expect(isar.isOpen, isTrue);
    expect(patient, isNull);
  });

  test(
    'salva e reabre o cadastro do paciente com persistencia local',
    () async {
      final tempDirectory = await Directory.systemTemp.createTemp(
        'medcontrol_patient_repo_',
      );
      final firstDatabase = AppDatabase(name: 'medcontrol_patient_repo');
      final secondDatabase = AppDatabase(name: 'medcontrol_patient_repo');

      addTearDown(() async {
        await firstDatabase.close();
        await secondDatabase.close();
        if (await tempDirectory.exists()) {
          await tempDirectory.delete(recursive: true);
        }
      });

      await firstDatabase.initialize(directory: tempDirectory.path);
      final firstRepository = PatientRepository(database: firstDatabase);

      final savedPatient = await firstRepository.savePatient(
        name: 'Maria de Souza',
        age: 72,
      );

      expect(savedPatient.internalId, startsWith('PAC-'));

      await firstDatabase.close();

      await secondDatabase.initialize(directory: tempDirectory.path);
      final secondRepository = PatientRepository(database: secondDatabase);
      final loadedPatient = await secondRepository.getCurrentPatient();

      expect(loadedPatient, isNotNull);
      expect(loadedPatient!.name, 'Maria de Souza');
      expect(loadedPatient.age, 72);
      expect(loadedPatient.internalId, savedPatient.internalId);
    },
  );
}
