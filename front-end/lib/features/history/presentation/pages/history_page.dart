import 'package:flutter/material.dart';

import '../../../../core/database/models/dose_record.dart';
import '../../../../core/database/models/medication.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/services/page_refresh_notifier.dart';
import '../../../medications/data/medication_repository.dart';
import '../../data/dose_repository.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _doseRepo = DoseRepository();
  final _medRepo = MedicationRepository();

  bool _isLoading = true;
  List<DoseRecord> _records = [];
  Map<int, Medication> _medicationMap = {};

  String _statusFilter = 'Todos';

  @override
  void initState() {
    super.initState();
    _loadHistory();

    // Listener para recarregar quando a aba é selecionada
    PageRefreshNotifier().historyRefresh.addListener(_loadHistory);
  }

  @override
  void dispose() {
    PageRefreshNotifier().historyRefresh.removeListener(_loadHistory);
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);

    final end = DateTime.now().add(const Duration(days: 1));
    final start = end.subtract(const Duration(days: 30));

    final records = await _doseRepo.getRecordsByDateRange(start, end);
    final meds = await _medRepo.getMedications();

    _medicationMap = {for (var m in meds) m.id: m};

    if (mounted) {
      setState(() {
        _records = records;
        _isLoading = false;
      });
    }
  }

  List<DoseRecord> get _filteredRecords {
    if (_statusFilter == 'Todos') return _records;
    if (_statusFilter == 'Tomados') {
      return _records.where((r) => r.status == 'taken').toList();
    }
    if (_statusFilter == 'Adiados') {
      return _records.where((r) => r.status == 'postponed').toList();
    }
    return _records;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filteredRecords;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico (Últimos 30 dias)'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadHistory),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('Todos'),
                    selected: _statusFilter == 'Todos',
                    onSelected: (val) =>
                        setState(() => _statusFilter = 'Todos'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ChoiceChip(
                    label: const Text('Tomados'),
                    selected: _statusFilter == 'Tomados',
                    onSelected: (val) =>
                        setState(() => _statusFilter = 'Tomados'),
                    selectedColor: Colors.green.shade200,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ChoiceChip(
                    label: const Text('Adiados'),
                    selected: _statusFilter == 'Adiados',
                    onSelected: (val) =>
                        setState(() => _statusFilter = 'Adiados'),
                    selectedColor: Colors.orange.shade200,
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhum registro encontrado.',
                        style: theme.textTheme.bodyLarge,
                      ),
                    )
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final record = filtered[index];
                        final med = _medicationMap[record.medicationId];

                        final isTaken = record.status == 'taken';
                        final color = isTaken ? Colors.green : Colors.orange;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: Icon(
                              isTaken ? Icons.check_circle : Icons.schedule,
                              color: color,
                            ),
                            title: Text(
                              med?.name ?? 'Medicamento Desconhecido',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Agendado para: ${record.scheduledFor.day.toString().padLeft(2, '0')}/${record.scheduledFor.month.toString().padLeft(2, '0')} as ${record.scheduledFor.hour.toString().padLeft(2, '0')}:${record.scheduledFor.minute.toString().padLeft(2, '0')}',
                            ),
                            trailing: Text(
                              isTaken ? 'TOMADO' : 'ADIADO',
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
