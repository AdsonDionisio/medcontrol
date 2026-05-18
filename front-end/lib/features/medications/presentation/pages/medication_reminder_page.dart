import 'package:flutter/material.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/models/medication.dart';
import '../../../../core/database/models/medication_schedule.dart';
import '../../../../core/services/alarm_service.dart';
import '../../../../core/services/app_settings_repository.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../medications/data/medication_repository.dart';
import '../../../schedules/data/schedule_repository.dart';
import '../../../history/data/dose_repository.dart';

class MedicationReminderPage extends StatefulWidget {
  const MedicationReminderPage({
    super.key,
    required this.medicationId,
    required this.scheduleId,
  });

  final int medicationId;
  final int scheduleId;

  @override
  State<MedicationReminderPage> createState() => _MedicationReminderPageState();
}

class _MedicationReminderPageState extends State<MedicationReminderPage> {
  final _medRepo = MedicationRepository();
  final _scheduleRepo = ScheduleRepository();
  final _doseRepo = DoseRepository();

  Medication? _medication;
  MedicationSchedule? _schedule;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startAlarm();
    _loadData();
  }

  Future<void> _startAlarm() async {
    await AlarmService().startAlarm();
  }

  Future<void> _loadData() async {
    final med = await _medRepo.getMedicationById(widget.medicationId);
    final schedule = await _scheduleRepo.getScheduleById(widget.scheduleId);

    if (mounted) {
      setState(() {
        _medication = med;
        _schedule = schedule;
        _isLoading = false;
      });
    }
  }

  Future<void> _confirm() async {
    if (_medication == null || _schedule == null) return;

    await AlarmService().stopAlarm();
    await NotificationService().cancelNotification(widget.scheduleId + 100000);

    await _doseRepo.saveRecord(
      medicationId: _medication!.id,
      scheduleId: _schedule!.id,
      scheduledFor: DateTime.now(),
      takenAt: DateTime.now(),
      status: 'taken',
    );

    if (_medication!.currentQuantity > 0) {
      await _medRepo.saveMedication(
        id: _medication!.id,
        name: _medication!.name,
        currentQuantity: _medication!.currentQuantity - 1,
        minimumQuantity: _medication!.minimumQuantity,
        dosage: _medication!.dosage,
        instructions: _medication!.instructions,
      );
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    AlarmService().stopAlarm();
    super.dispose();
  }

  Future<void> _snooze() async {
    if (_medication == null || _schedule == null) return;

    await AlarmService().stopAlarm();
    final settings = await AppSettingsRepository(
      database: AppDatabase.instance,
    ).getSettings();
    final newTime = DateTime.now().add(
      Duration(minutes: settings.snoozeMinutes),
    );

    // Save postponed record
    await _doseRepo.saveRecord(
      medicationId: _medication!.id,
      scheduleId: _schedule!.id,
      scheduledFor: newTime,
      status: 'postponed',
    );

    await NotificationService().cancelNotification(widget.scheduleId + 100000);
    await NotificationService().scheduleNotification(
      id: widget.scheduleId + 100000,
      title: 'Lembrete de Medicamento',
      body: 'Hora de tomar ${_medication!.name}',
      scheduledDate: newTime,
      payload:
          '{"medicationId": ${_medication!.id}, "scheduleId": ${_schedule!.id}}',
      repeats: false,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_medication == null || _schedule == null) {
      return const Scaffold(
        body: Center(child: Text('Erro ao carregar dados')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Lembrete de Medicamento')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.medication, size: 80, color: Colors.blue),
              const SizedBox(height: AppSpacing.lg),
              Text(
                _medication!.name,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Horário: ${_schedule!.timeLabel}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                _medication!.dosage ?? 'Dose não especificada',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'O alarme só para quando você tocar em Confirmar ou Adiar.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.lg,
                        ),
                      ),
                      onPressed: _confirm,
                      child: const Text(
                        'Confirmar',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.lg,
                        ),
                      ),
                      onPressed: _snooze,
                      child: const Text(
                        'Adiar',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
