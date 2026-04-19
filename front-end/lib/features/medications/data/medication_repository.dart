import 'package:isar_community/isar.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/models/medication.dart';
import '../../patient/data/patient_repository.dart';

class MedicationRepository {
  MedicationRepository({
    AppDatabase? database,
    PatientRepository? patientRepository,
  }) : _database = database ?? AppDatabase.instance,
       _patientRepository = patientRepository ?? PatientRepository();

  final AppDatabase _database;
  final PatientRepository _patientRepository;

  Future<List<Medication>> getMedications() async {
    final patient = await _patientRepository.getCurrentPatient();
    if (patient == null) return [];

    return _database.isar.medications
        .filter()
        .patientInternalIdEqualTo(patient.internalId)
        .sortByUpdatedAtDesc()
        .findAll();
  }

  Future<Medication?> getMedicationById(int id) async {
    return _database.isar.medications.get(id);
  }

  Future<Medication> saveMedication({
    int? id,
    required String name,
    String? dosage,
    String? instructions,
    required int currentQuantity,
    required int minimumQuantity,
    bool isActive = true,
  }) async {
    final patient = await _patientRepository.getCurrentPatient();
    if (patient == null) {
      throw Exception('Nenhum paciente cadastrado para vincular a medicação.');
    }

    final now = DateTime.now();
    Medication? medication;

    if (id != null) {
      medication = await _database.isar.medications.get(id);
    }

    medication ??= Medication()
      ..createdAt = now
      ..patientInternalId = patient.internalId;

    medication
      ..name = name.trim()
      ..dosage = dosage?.trim()
      ..instructions = instructions?.trim()
      ..currentQuantity = currentQuantity
      ..minimumQuantity = minimumQuantity
      ..isActive = isActive
      ..updatedAt = now;

    await _database.isar.writeTxn(() async {
      await _database.isar.medications.put(medication!);
    });

    return medication;
  }

  Future<bool> deleteMedication(int id) async {
    return _database.isar.writeTxn(() async {
      return _database.isar.medications.delete(id);
    });
  }
}
