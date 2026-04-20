import 'package:flutter/material.dart';

import '../../../../core/database/models/medication.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/medication_repository.dart';
import 'medication_detail_page.dart';
import 'medication_form_page.dart';

class MedicationsPage extends StatefulWidget {
  const MedicationsPage({super.key});

  @override
  State<MedicationsPage> createState() => _MedicationsPageState();
}

class _MedicationsPageState extends State<MedicationsPage> {
  final _repository = MedicationRepository();
  List<Medication> _medications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    setState(() => _isLoading = true);
    final list = await _repository.getMedications();
    if (!mounted) return;
    setState(() {
      _medications = list;
      _isLoading = false;
    });
  }

  void _navigateToAdd() async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const MedicationFormPage()));
    if (result == true) {
      _loadMedications();
    }
  }

  void _navigateToDetail(Medication medication) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MedicationDetailPage(medication: medication),
      ),
    );
    _loadMedications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicamentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMedications,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'medications_add_fab',
        onPressed: _navigateToAdd,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _medications.isEmpty
            ? const Center(child: Text('Nenhum medicamento cadastrado.'))
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: _medications.length,
                itemBuilder: (context, index) {
                  final med = _medications[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      title: Text(
                        med.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        med.dosage != null
                            ? 'Dosagem: ${med.dosage}'
                            : 'Sem dosagem',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _navigateToDetail(med),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
