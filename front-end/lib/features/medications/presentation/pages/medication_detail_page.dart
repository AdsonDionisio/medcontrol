import 'package:flutter/material.dart';

import '../../../../core/database/models/medication.dart';
import '../../../../core/database/models/medication_schedule.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../schedules/data/schedule_repository.dart';
import '../../../schedules/presentation/pages/schedule_form_page.dart';
import '../../data/medication_repository.dart';
import 'medication_form_page.dart';

class MedicationDetailPage extends StatefulWidget {
  final Medication medication;

  const MedicationDetailPage({super.key, required this.medication});

  @override
  State<MedicationDetailPage> createState() => _MedicationDetailPageState();
}

class _MedicationDetailPageState extends State<MedicationDetailPage> {
  final _scheduleRepo = ScheduleRepository();
  final _medRepo = MedicationRepository();

  late Medication _medication;
  List<MedicationSchedule> _schedules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _medication = widget.medication;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Refresh med in case it was edited
    final med = await _medRepo.getMedicationById(_medication.id);
    if (med != null) _medication = med;

    final schedules = await _scheduleRepo.getSchedulesByMedication(
      _medication.id,
    );
    if (!mounted) return;

    setState(() {
      _schedules = schedules;
      _isLoading = false;
    });
  }

  void _editMedication() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MedicationFormPage(medication: _medication),
      ),
    );
    if (result == true) _loadData();
  }

  void _deleteMedication() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Excluir Medicamento?'),
        content: const Text(
          'Essa acao tambem removera todos os agendamentos vinculados (se existirem na base vinculada).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Exclui
      await _medRepo.deleteMedication(_medication.id);
      if (mounted) {
        Navigator.pop(context); // volta pra lista
      }
    }
  }

  void _addSchedule() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ScheduleFormPage(medication: _medication),
      ),
    );
    if (result == true) _loadData();
  }

  void _deleteSchedule(int id) async {
    await _scheduleRepo.deleteSchedule(id);
    _loadData();
  }

  String _formatRecurrence(MedicationSchedule s) {
    if (s.recurrence == 'daily') return 'Diário';
    if (s.recurrence == 'weekly') return 'Semanal';
    if (s.recurrence == 'interval') return 'A cada ${s.intervalDays} dias';
    return s.recurrence;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_medication.name),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _editMedication),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteMedication,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addSchedule,
        icon: const Icon(Icons.alarm_add),
        label: const Text('Agendar'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Detalhes', style: theme.textTheme.titleMedium),
                      const Divider(),
                      Text('Dosagem: ${_medication.dosage ?? 'Não informada'}'),
                      Text('Estoque atual: ${_medication.currentQuantity}'),
                      Text('Estoque minimo: ${_medication.minimumQuantity}'),
                      if (_medication.instructions?.isNotEmpty == true) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text('Observações: ${_medication.instructions}'),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Agendamentos', style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_schedules.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Center(
                      child: Text('Nenhum agendamento para este medicamento.'),
                    ),
                  ),
                )
              else
                ..._schedules.map(
                  (s) => Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text(
                        s.timeLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(_formatRecurrence(s)),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => _deleteSchedule(s.id),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 80), // Fab space
            ],
          ),
        ),
      ),
    );
  }
}
