import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../../core/database/models/medication.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/schedule_repository.dart';
import '../../../../core/services/notification_service.dart';

class ScheduleFormPage extends StatefulWidget {
  final Medication medication;

  const ScheduleFormPage({super.key, required this.medication});

  @override
  State<ScheduleFormPage> createState() => _ScheduleFormPageState();
}

class _ScheduleFormPageState extends State<ScheduleFormPage> {
  final _repository = ScheduleRepository();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _recurrence = 'daily';
  int _intervalDays = 2; // Default starting interval
  bool _isSaving = false;

  void _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _selectedTime);
    if (t != null) {
      setState(() => _selectedTime = t);
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    
    final formattedTime = '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';
    
    final schedule = await _repository.saveSchedule(
      medicationId: widget.medication.id,
      timeLabel: formattedTime,
      recurrence: _recurrence,
      intervalDays: _intervalDays,
    );
    
    // Configura a notificacao baseada no tempo
    final now = DateTime.now();
    final parts = formattedTime.split(':');
    final scheduledDate = DateTime(
      now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1])
    );
    
    final payloadJson = jsonEncode({
      'medicationId': widget.medication.id,
      'scheduleId': schedule.id,
      'title': 'Hora do Medicamento!',
      'body': 'Não se esqueça de tomar: ${widget.medication.name}',
    });

    await NotificationService().scheduleNotification(
      id: schedule.id,
      title: 'Hora do Medicamento!',
      body: 'Não se esqueça de tomar: ${widget.medication.name}',
      scheduledDate: scheduledDate,
      payload: payloadJson,
    );
    
    if (mounted) {
       Navigator.pop(context, true);
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
              Text('Medicamento: ${widget.medication.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.lg),
              
              Card(
                child: ListTile(
                  title: const Text('Horário da Dose'),
                  subtitle: Text('${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.access_time),
                  onTap: _pickTime,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              
              const Text('Recorrência:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                initialValue: _recurrence,
                items: const [
                  DropdownMenuItem(value: 'daily', child: Text('Diário (Todos os dias)')),
                  DropdownMenuItem(value: 'weekly', child: Text('Semanal')),
                  DropdownMenuItem(value: 'interval', child: Text('Em intervalos de dias')),
                ],
                onChanged: (val) {
                  setState(() => _recurrence = val ?? 'daily');
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
                         if (_intervalDays > 1) _intervalDays--;
                       }),
                     ),
                     Text('$_intervalDays', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
