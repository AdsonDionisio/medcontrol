import 'package:flutter/material.dart';

import '../../../../core/database/models/health_measurement.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/measurement_repository.dart';

class MeasurementFormPage extends StatefulWidget {
  const MeasurementFormPage({super.key});

  @override
  State<MeasurementFormPage> createState() => _MeasurementFormPageState();
}

class _MeasurementFormPageState extends State<MeasurementFormPage> {
  final _repository = MeasurementRepository();
  bool _isSaving = false;

  // Controladores de Pressao
  bool _includeBp = false;
  final _sysController = TextEditingController();
  final _diaController = TextEditingController();

  // Controladores Saturação
  bool _includeO2 = false;
  final _o2Controller = TextEditingController();

  // Controladores Glicemia
  bool _includeGlucose = false;
  final _glucoseController = TextEditingController();

  @override
  void dispose() {
    _sysController.dispose();
    _diaController.dispose();
    _o2Controller.dispose();
    _glucoseController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_includeBp && !_includeO2 && !_includeGlucose) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione ao menos um indicador para aferir!')),
      );
      return;
    }

    setState(() => _isSaving = true);
    
    final batch = <HealthMeasurement>[];
    
    if (_includeBp) {
      final sys = double.tryParse(_sysController.text) ?? 0;
      final dia = double.tryParse(_diaController.text) ?? 0;
      if (sys > 0 && dia > 0) {
        batch.add(HealthMeasurement()
          ..type = 'blood_pressure'
          ..primaryValue = sys
          ..secondaryValue = dia
          ..unit = 'mmHg'
          ..measuredAt = DateTime.now()
        );
      }
    }
    
    if (_includeO2) {
      final o2 = double.tryParse(_o2Controller.text) ?? 0;
      if (o2 > 0) {
        batch.add(HealthMeasurement()
          ..type = 'blood_oxygen'
          ..primaryValue = o2
          ..unit = '%'
          ..measuredAt = DateTime.now()
        );
      }
    }
    
    if (_includeGlucose) {
      final glucose = double.tryParse(_glucoseController.text) ?? 0;
      if (glucose > 0) {
        batch.add(HealthMeasurement()
          ..type = 'blood_sugar'
          ..primaryValue = glucose
          ..unit = 'mg/dL'
          ..measuredAt = DateTime.now()
        );
      }
    }

    if (batch.isNotEmpty) {
      await _repository.saveBatchMeasurements(batch);
      if (mounted) Navigator.pop(context, true);
    } else {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, preencha valores válidos.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Aferição')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               _buildCheckCard(
                title: 'Pressão Arterial',
                subtitle: 'Ex: 120 por 80 mmHg',
                icon: Icons.favorite,
                isChecked: _includeBp,
                onChanged: (val) => setState(() => _includeBp = val ?? false),
                child: Row(
                  children: [
                     Expanded(child: TextField(
                       controller: _sysController,
                       keyboardType: TextInputType.number,
                       decoration: const InputDecoration(labelText: 'Sistólica (Maior)', border: OutlineInputBorder()),
                     )),
                     const SizedBox(width: AppSpacing.sm),
                     Expanded(child: TextField(
                       controller: _diaController,
                       keyboardType: TextInputType.number,
                       decoration: const InputDecoration(labelText: 'Diastólica (Menor)', border: OutlineInputBorder()),
                     )),
                  ],
                )
               ),
               const SizedBox(height: AppSpacing.md),
               
               _buildCheckCard(
                title: 'Saturação (Oxigênio)',
                subtitle: 'Ex: 98 %',
                icon: Icons.air,
                isChecked: _includeO2,
                onChanged: (val) => setState(() => _includeO2 = val ?? false),
                child: TextField(
                   controller: _o2Controller,
                   keyboardType: TextInputType.number,
                   decoration: const InputDecoration(labelText: 'Nível de Saturação (%)', border: OutlineInputBorder()),
                ),
               ),
               const SizedBox(height: AppSpacing.md),

               _buildCheckCard(
                title: 'Glicemia',
                subtitle: 'Ex: 95 mg/dL',
                icon: Icons.bloodtype,
                isChecked: _includeGlucose,
                onChanged: (val) => setState(() => _includeGlucose = val ?? false),
                child: TextField(
                   controller: _glucoseController,
                   keyboardType: TextInputType.number,
                   decoration: const InputDecoration(labelText: 'Açúcar no Sangue (mg/dL)', border: OutlineInputBorder()),
                ),
               ),
               
               const SizedBox(height: AppSpacing.xl),
               ElevatedButton(
                 onPressed: _isSaving ? null : _save,
                 child: Text(_isSaving ? 'Salvando...' : 'Salvar Registros'),
               )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isChecked,
    required ValueChanged<bool?> onChanged,
    required Widget child,
  }) {
    return Card(
      elevation: isChecked ? 4 : 1,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            CheckboxListTile(
              title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(subtitle),
              secondary: Icon(icon, color: isChecked ? Colors.deepPurple : Colors.grey),
              value: isChecked,
              onChanged: onChanged,
            ),
            if (isChecked) ...[
               const SizedBox(height: AppSpacing.sm),
               child,
            ]
          ],
        ),
      ),
    );
  }
}
