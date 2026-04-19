import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../core/database/models/medication.dart';
import '../../../../core/database/models/medication_schedule.dart';
import '../../../../core/services/app_settings_repository.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../history/data/dose_repository.dart';
import '../../../medications/data/medication_repository.dart';
import '../../data/schedule_repository.dart';

class SchedulesPage extends StatefulWidget {
  const SchedulesPage({super.key});

  @override
  State<SchedulesPage> createState() => _SchedulesPageState();
}

class _SchedulesPageState extends State<SchedulesPage> {
  final _scheduleRepo = ScheduleRepository();
  final _medRepo = MedicationRepository();
  final _doseRepo = DoseRepository();
  final _notificationService = NotificationService();

  bool _isLoading = true;
  List<Map<String, dynamic>> _agendaItems = [];

  @override
  void initState() {
    super.initState();
    _loadAgenda();
  }

  Future<void> _loadAgenda() async {
    setState(() => _isLoading = true);

    final medications = await _medRepo.getMedications();
    final medicationById = {
      for (final medication in medications) medication.id: medication,
    };
    final allSchedules = await _scheduleRepo.getAllSchedules();

    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = DateTime(
      today.year,
      today.month,
      today.day,
      23,
      59,
      59,
      999,
    );

    final records = await _doseRepo.getRecordsByDateRange(todayStart, todayEnd);
    final latestBySchedule = <int, dynamic>{};
    for (final record in records) {
      if (record.scheduleId == null) {
        continue;
      }

      final scheduleId = record.scheduleId!;
      final existing = latestBySchedule[scheduleId];
      if (existing == null ||
          record.scheduledFor.isAfter(existing.scheduledFor)) {
        latestBySchedule[scheduleId] = record;
      }
    }

    final items = <Map<String, dynamic>>[];

    for (final schedule in allSchedules) {
      final medication = medicationById[schedule.medicationId];
      if (medication == null || !medication.isActive) {
        continue;
      }

      if (!_isScheduledForToday(schedule, today)) {
        continue;
      }

      final record = latestBySchedule[schedule.id];
      var status = 'Pendente';
      var statusColor = Colors.blue;
      var statusNote = '';
      var displayTimeLabel = schedule.timeLabel;

      if (record != null) {
        if (record.status == 'taken') {
          status = 'Confirmado';
          statusColor = Colors.green;
          final takenAt = record.takenAt;
          if (takenAt != null) {
            statusNote =
                'Confirmado as ${takenAt.hour.toString().padLeft(2, '0')}:${takenAt.minute.toString().padLeft(2, '0')}';
          }
        } else if (record.status == 'postponed') {
          status = 'Adiado';
          statusColor = Colors.orange;
          displayTimeLabel =
              '${record.scheduledFor.hour.toString().padLeft(2, '0')}:${record.scheduledFor.minute.toString().padLeft(2, '0')}';
          statusNote = 'Adiado para $displayTimeLabel';
        }
      }

      items.add({
        'schedule': schedule,
        'medication': medication,
        'displayTimeLabel': displayTimeLabel,
        'status': status,
        'statusColor': statusColor,
        'statusNote': statusNote,
      });
    }

    items.sort(
      (a, b) => (a['displayTimeLabel'] as String).compareTo(
        b['displayTimeLabel'] as String,
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _agendaItems = items;
      _isLoading = false;
    });
  }

  bool _isScheduledForToday(MedicationSchedule schedule, DateTime today) {
    if (schedule.recurrence == 'daily') {
      return true;
    }

    if (schedule.recurrence == 'weekly') {
      return schedule.createdAt.weekday == today.weekday;
    }

    if (schedule.recurrence == 'interval') {
      final diff = today.difference(schedule.createdAt).inDays;
      return diff >= 0 && diff % schedule.intervalDays == 0;
    }

    return false;
  }

  Future<void> _takeDose(
    Medication medication,
    MedicationSchedule schedule,
  ) async {
    await _doseRepo.saveRecord(
      medicationId: medication.id,
      scheduleId: schedule.id,
      scheduledFor: DateTime.now(),
      takenAt: DateTime.now(),
      status: 'taken',
    );

    await _notificationService.cancelNotification(schedule.id);
    await _notificationService.removePendingAlarm(scheduleId: schedule.id);

    if (medication.currentQuantity > 0) {
      final updatedQuantity = medication.currentQuantity - 1;
      await _medRepo.saveMedication(
        id: medication.id,
        name: medication.name,
        currentQuantity: updatedQuantity,
        minimumQuantity: medication.minimumQuantity,
        dosage: medication.dosage,
        instructions: medication.instructions,
      );

      if (updatedQuantity <= medication.minimumQuantity) {
        await _notificationService.showImmediateNotification(
          id: medication.id * 100,
          title: 'Estoque baixo',
          body: 'A medicacao "${medication.name}" esta perto do fim.',
        );
      }
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${medication.name} confirmado as ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        ),
      ),
    );
    await _loadAgenda();
  }

  Future<void> _postponeDose(
    Medication medication,
    MedicationSchedule schedule,
  ) async {
    final settingsRepo = AppSettingsRepository(database: null);
    final settings = await settingsRepo.getSettings();
    final newTime = DateTime.now().add(
      Duration(minutes: settings.snoozeMinutes),
    );

    await _doseRepo.saveRecord(
      medicationId: medication.id,
      scheduleId: schedule.id,
      scheduledFor: newTime,
      status: 'postponed',
    );

    await _notificationService.cancelNotification(schedule.id);
    await _notificationService.removePendingAlarm(scheduleId: schedule.id);

    final payloadJson = jsonEncode({
      'medicationId': medication.id,
      'scheduleId': schedule.id,
      'title': 'Hora do Medicamento!',
      'body': 'Nao se esqueca de tomar: ${medication.name}',
    });

    await _notificationService.scheduleNotification(
      id: _notificationService.createSnoozeNotificationId(schedule.id),
      title: 'Hora do Medicamento!',
      body: 'Nao se esqueca de tomar: ${medication.name}',
      scheduledDate: newTime,
      payload: payloadJson,
      repeatDaily: false,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dose adiada em ${settings.snoozeMinutes} minutos.'),
      ),
    );
    await _loadAgenda();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda do Dia'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadAgenda),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _agendaItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.event_available,
                      size: 60,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Nenhuma medicacao programada para hoje.',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: _agendaItems.length,
                itemBuilder: (context, index) {
                  final item = _agendaItems[index];
                  final medication = item['medication'] as Medication;
                  final schedule = item['schedule'] as MedicationSchedule;

                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item['displayTimeLabel'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      title: Text(
                        medication.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(medication.dosage ?? 'Dose nao especificada'),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: (item['statusColor'] as Color)
                                      .withAlpha(38),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item['status'] as String,
                                  style: TextStyle(
                                    color: item['statusColor'] as Color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              if ((item['statusNote'] as String).isNotEmpty)
                                Text(
                                  item['statusNote'] as String,
                                  style: theme.textTheme.bodySmall,
                                ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          if (item['status'] != 'Confirmado')
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    onPressed: () =>
                                        _takeDose(medication, schedule),
                                    child: const Text(
                                      'Confirmar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        _postponeDose(medication, schedule),
                                    child: const Text(
                                      'Adiar',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
