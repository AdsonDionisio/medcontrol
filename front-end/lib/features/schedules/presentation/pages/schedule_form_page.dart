import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../core/database/models/medication.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/schedule_repository.dart';

class ScheduleFormPage extends StatefulWidget {
  const ScheduleFormPage({super.key, required this.medication});

  final Medication medication;

  @override
  State<ScheduleFormPage> createState() => _ScheduleFormPageState();
}

class _ScheduleFormPageState extends State<ScheduleFormPage> {
  final _repository = ScheduleRepository();
  final _notificationService = NotificationService();

  TimeOfDay _selectedTime = TimeOfDay.now();
  String _recurrence = 'daily';
  int _intervalDays = 2;
  bool _isSaving = false;

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    final formattedTime =
        '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';

    try {
      final schedule = await _repository.saveSchedule(
        medicationId: widget.medication.id,
        timeLabel: formattedTime,
        recurrence: _recurrence,
        intervalDays: _intervalDays,
      );

      final now = DateTime.now();
      final parts = formattedTime.split(':');
      final scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
      final firstTrigger = scheduledDate.isAfter(now)
          ? scheduledDate
          : scheduledDate.add(const Duration(days: 1));

      final payloadJson = jsonEncode({
        'medicationId': widget.medication.id,
        'scheduleId': schedule.id,
        'title': 'Hora do Medicamento!',
        'body': 'Nao se esqueca de tomar: ${widget.medication.name}',
      });

      await _notificationService.scheduleNotification(
        id: schedule.id,
        title: 'Hora do Medicamento!',
        body: 'Nao se esqueca de tomar: ${widget.medication.name}',
        scheduledDate: firstTrigger,
        payload: payloadJson,
      );

      if (!mounted) {
        return;
      }

      Navigator.pop(context, true);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Agendamento')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Medicamento: ${widget.medication.name}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Card(
                child: ListTile(
                  title: const Text('Horario da Dose'),
                  subtitle: Text(
                    '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(Icons.access_time),
                  onTap: _pickTime,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Recorrencia:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                initialValue: _recurrence,
                items: const [
                  DropdownMenuItem(
                    value: 'daily',
                    child: Text('Diario (Todos os dias)'),
                  ),
                  DropdownMenuItem(value: 'weekly', child: Text('Semanal')),
                  DropdownMenuItem(
                    value: 'interval',
                    child: Text('Em intervalos de dias'),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _recurrence = value ?? 'daily');
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              if (_recurrence == 'interval') ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    const Text('A cada '),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => setState(() {
                        if (_intervalDays > 1) {
                          _intervalDays--;
                        }
                      }),
                    ),
                    Text(
                      '$_intervalDays',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() => _intervalDays++),
                    ),
                    const Text(' dias'),
                  ],
                ),
              ],
              const Spacer(),
              ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: Text(_isSaving ? 'Salvando...' : 'Salvar Agendamento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
