import 'package:flutter/material.dart';

import '../../../../core/database/models/medication.dart';
import '../../../../core/database/models/medication_schedule.dart';
import '../../../../core/theme/app_spacing.dart';
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
  }

  Future<void> _loadAgenda() async {
    setState(() => _isLoading = true);
    
    // Obter todas medicações e agendamentos
    final meds = await _medRepo.getMedications();
    final medMap = {for (var m in meds) m.id: m};
    
    final allSchedules = await _scheduleRepo.getAllSchedules();
    
    // Simplificando o "Agenda do Dia" calculando os eventos que deveriam ser engatilhados hoje
    final today = DateTime.now();
    final items = <Map<String, dynamic>>[];
    
    for (var schedule in allSchedules) {
      final med = medMap[schedule.medicationId];
      if (med == null || !med.isActive) continue;
      
      bool isScheduledForToday = false;
      
      if (schedule.recurrence == 'daily') {
        isScheduledForToday = true;
      } else if (schedule.recurrence == 'weekly') {
        if (schedule.createdAt.weekday == today.weekday) isScheduledForToday = true;
      } else if (schedule.recurrence == 'interval') {
        final diff = today.difference(schedule.createdAt).inDays;
        if (diff % schedule.intervalDays == 0) isScheduledForToday = true;
      }
      
      if (isScheduledForToday) {
        items.add({
          'schedule': schedule,
          'medication': med,
          'timeLabel': schedule.timeLabel,
          'status': 'Pendente', // Futuramente ligado a DoseRecord
        });
      }
    }
    
    // Ordenar por horario
    items.sort((a, b) => (a['timeLabel'] as String).compareTo(b['timeLabel'] as String));

    if (mounted) {
      setState(() {
        _agendaItems = items;
        _isLoading = false;
      });
    }
  }

  Future<void> _takeDose(Medication med, MedicationSchedule schedule) async {
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
          body: 'A medicação "${med.name}" está se esgotando. Reponha o estoque!',
        );
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${med.name} confirmado as ${DateTime.now().hour}:${DateTime.now().minute}')),
      );
      _loadAgenda();
    }
  }

  Future<void> _postponeDose(Medication med, MedicationSchedule schedule) async {
    // Salva historico de adiamento
    await _doseRepo.saveRecord(
      medicationId: med.id,
      scheduleId: schedule.id,
      scheduledFor: DateTime.now(),
      status: 'postponed',
    );
    
    // Agenda alerta para +30 mins
    NotificationService().showImmediateNotification(
      id: schedule.id * 200,
      title: 'Adiado: ${med.name}',
      body: 'Você adiou a medicação. Lembramos daqui a pouco!',
    ); // O ideal seria usar zonedSchedule com 30min delay
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dose adiada em 30 minutos.')),
      );
      // Recarrega agenda se necessario
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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAgenda,
          )
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
                        const Icon(Icons.event_available, size: 60, color: Colors.grey),
                        const SizedBox(height: AppSpacing.md),
                        Text('Nenhuma medicação programada para hoje!', style: theme.textTheme.titleMedium),
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
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(schedule.timeLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                          title: Text(med.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(med.dosage ?? 'Dose não especificada'),
                              const SizedBox(height: AppSpacing.sm),
                              Row(
                                children: [
                                  Expanded(child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                    onPressed: () => _takeDose(med, schedule),
                                    child: const Text('Confirmar', style: TextStyle(color: Colors.white, fontSize: 10)),
                                  )),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(child: OutlinedButton(
                                    onPressed: () => _postponeDose(med, schedule),
                                    child: const Text('Adiar', style: TextStyle(fontSize: 10)),
                                  )),
                                ],
                              )
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
