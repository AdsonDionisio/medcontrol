import 'package:flutter/material.dart';

import '../../../../core/database/models/medication.dart';
import '../../../../core/database/models/medication_schedule.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/services/app_settings_repository.dart';
import '../../../../core/services/page_refresh_notifier.dart';
import '../../../medications/data/medication_repository.dart';
import '../../data/schedule_repository.dart';
import '../../../history/data/dose_repository.dart';
import '../../../../core/services/notification_service.dart';

class SchedulesPage extends StatefulWidget {
  const SchedulesPage({super.key});

  @override
  State<SchedulesPage> createState() => _SchedulesPageState();
}

class _SchedulesPageState extends State<SchedulesPage> {
  final _scheduleRepo = ScheduleRepository();
  final _medRepo = MedicationRepository();
  final _doseRepo = DoseRepository();

  bool _isLoading = true;
  List<Map<String, dynamic>> _agendaItems = [];

  @override
  void initState() {
    super.initState();
    _loadAgenda();

    // Listener para recarregar quando a aba é selecionada
    PageRefreshNotifier().scheduleRefresh.addListener(_loadAgenda);
  }

  @override
  void dispose() {
    PageRefreshNotifier().scheduleRefresh.removeListener(_loadAgenda);
    super.dispose();
  }

  Future<void> _loadAgenda() async {
    setState(() => _isLoading = true);

    // Obter todas medicações e agendamentos
    final meds = await _medRepo.getMedications();
    final medMap = {for (var m in meds) m.id: m};

    final allSchedules = await _scheduleRepo.getAllSchedules();

    // Get today's doses
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final todaysDoses = await _doseRepo.getRecordsByDateRange(
      startOfDay,
      endOfDay,
    );
    final dosesBySchedule = {
      for (var dose in todaysDoses)
        '${dose.medicationId}_${dose.scheduleId}': dose,
    };

    // Simplificando o "Agenda do Dia" calculando os eventos que deveriam ser engatilhados hoje
    final items = <Map<String, dynamic>>[];

    for (var schedule in allSchedules) {
      final med = medMap[schedule.medicationId];
      if (med == null || !med.isActive) continue;

      bool isScheduledForToday = false;

      if (schedule.recurrence == 'daily') {
        isScheduledForToday = true;
      } else if (schedule.recurrence == 'weekly') {
        if (schedule.createdAt.weekday == today.weekday) {
          isScheduledForToday = true;
        }
      } else if (schedule.recurrence == 'interval') {
        final diff = today.difference(schedule.createdAt).inDays;
        if (diff % schedule.intervalDays == 0) isScheduledForToday = true;
      }

      if (isScheduledForToday) {
        final key = '${schedule.medicationId}_${schedule.id}';
        final dose = dosesBySchedule[key];
        final status = dose?.status == 'taken'
            ? 'Tomado'
            : dose?.status == 'postponed'
            ? 'Adiado'
            : 'Pendente';
        final scheduledFor =
            dose?.scheduledFor ?? _scheduledTimeForSchedule(schedule, today);

        items.add({
          'schedule': schedule,
          'medication': med,
          'scheduledFor': scheduledFor,
          'timeLabel': _formatTimeLabel(scheduledFor),
          'status': status,
          'isTaken': status == 'Tomado',
        });
      }
    }

    // Ordenar por horário real do item
    items.sort(
      (a, b) => (a['scheduledFor'] as DateTime).compareTo(
        b['scheduledFor'] as DateTime,
      ),
    );

    if (mounted) {
      setState(() {
        _agendaItems = items;
        _isLoading = false;
      });
    }
  }

  DateTime _scheduledTimeForSchedule(
    MedicationSchedule schedule,
    DateTime referenceDate,
  ) {
    final parts = schedule.timeLabel.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
      hour,
      minute,
    );
  }

  String _formatTimeLabel(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _takeDose(Medication med, MedicationSchedule schedule) async {
    await NotificationService().cancelNotification(schedule.id + 100000);

    // Registra a dose
    await _doseRepo.saveRecord(
      medicationId: med.id,
      scheduleId: schedule.id,
      scheduledFor: DateTime.now(),
      takenAt: DateTime.now(),
      status: 'taken',
    );

    // Abate o estoque se possivel
    if (med.currentQuantity > 0) {
      await _medRepo.saveMedication(
        id: med.id,
        name: med.name,
        currentQuantity: med.currentQuantity - 1,
        minimumQuantity: med.minimumQuantity,
        dosage: med.dosage,
        instructions: med.instructions,
      );

      // Checa estoque critico
      if ((med.currentQuantity - 1) <= med.minimumQuantity) {
        NotificationService().showImmediateNotification(
          id: med.id * 100,
          title: '🚨 Estoque Baixo!',
          body:
              'A medicação "${med.name}" está se esgotando. Reponha o estoque!',
        );
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${med.name} confirmado as ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
          ),
        ),
      );
      _loadAgenda();
    }
  }

  Future<void> _cancelDose(Medication med, MedicationSchedule schedule) async {
    await NotificationService().cancelNotification(schedule.id + 100000);

    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final doses = await _doseRepo.getRecordsByDateRange(startOfDay, endOfDay);
    final dose = doses.firstWhere(
      (d) =>
          d.medicationId == med.id &&
          d.scheduleId == schedule.id &&
          d.status == 'taken',
      orElse: () => throw Exception('Dose not found'),
    );

    await _doseRepo.deleteRecord(dose.id);

    // Restore stock
    if (med.currentQuantity >= 0) {
      await _medRepo.saveMedication(
        id: med.id,
        name: med.name,
        currentQuantity: med.currentQuantity + 1,
        minimumQuantity: med.minimumQuantity,
        dosage: med.dosage,
        instructions: med.instructions,
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Confirmação cancelada')));
      _loadAgenda();
    }
  }

  Future<void> _postponeDose(
    Medication med,
    MedicationSchedule schedule,
  ) async {
    final settings = await AppSettingsRepository(
      database: AppDatabase.instance,
    ).getSettings();
    final newTime = DateTime.now().add(
      Duration(minutes: settings.snoozeMinutes),
    );

    await _doseRepo.saveRecord(
      medicationId: med.id,
      scheduleId: schedule.id,
      scheduledFor: newTime,
      status: 'postponed',
    );

    await NotificationService().cancelNotification(schedule.id + 100000);
    await NotificationService().scheduleNotification(
      id: schedule.id + 100000,
      title: 'Lembrete de Medicamento',
      body: 'Hora de tomar ${med.name}',
      scheduledDate: newTime,
      payload: '{"medicationId": ${med.id}, "scheduleId": ${schedule.id}}',
      repeats: false,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dose adiada para ${_formatTimeLabel(newTime)}.'),
        ),
      );
      _loadAgenda();
    }
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
                      'Nenhuma medicação programada para hoje!',
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
                  final Medication med = item['medication'];
                  final MedicationSchedule schedule = item['schedule'];
                  final bool isTaken = item['isTaken'];

                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item['timeLabel'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      title: Text(
                        med.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(med.dosage ?? 'Dose não especificada'),
                          Text(
                            'Agendado para: ${item['timeLabel']}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Status: ${item['status']}',
                            style: TextStyle(
                              color: isTaken ? Colors.green : Colors.orange,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          if (!isTaken) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    onPressed: () => _takeDose(med, schedule),
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
                                        _postponeDose(med, schedule),
                                    child: const Text(
                                      'Adiar',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            Center(
                              child: OutlinedButton(
                                onPressed: () => _cancelDose(med, schedule),
                                child: const Text('Cancelar'),
                              ),
                            ),
                          ],
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
