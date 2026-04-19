import 'package:flutter/material.dart';

import '../../../../core/database/models/medication.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/medication_repository.dart';

class MedicationFormPage extends StatefulWidget {
  final Medication? medication;

  const MedicationFormPage({super.key, this.medication});

  @override
  State<MedicationFormPage> createState() => _MedicationFormPageState();
}

class _MedicationFormPageState extends State<MedicationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _currentQtyController = TextEditingController(text: '0');
  final _minimumQtyController = TextEditingController(text: '0');

  final _repository = MedicationRepository();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.medication != null) {
      final med = widget.medication!;
      _nameController.text = med.name;
      _dosageController.text = med.dosage ?? '';
      _instructionsController.text = med.instructions ?? '';
      _currentQtyController.text = med.currentQuantity.toString();
      _minimumQtyController.text = med.minimumQuantity.toString();
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await _repository.saveMedication(
        id: widget.medication?.id,
        name: _nameController.text,
        dosage: _dosageController.text.isNotEmpty
            ? _dosageController.text
            : null,
        instructions: _instructionsController.text.isNotEmpty
            ? _instructionsController.text
            : null,
        currentQuantity: int.tryParse(_currentQtyController.text) ?? 0,
        minimumQuantity: int.tryParse(_minimumQtyController.text) ?? 0,
      );

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medicamento salvo com sucesso.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _instructionsController.dispose();
    _currentQtyController.dispose();
    _minimumQtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.medication != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Medicamento' : 'Novo Medicamento'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Dados do Medicamento',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nome do Medicamento *',
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Informe o nome.'
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _dosageController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Dosagem (ex: 500mg)',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _instructionsController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Observações / Instruções',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Controle de Estoque',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _currentQtyController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Qtd. Atual',
                              helperText: 'Em posse',
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: _minimumQtyController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Qtd. Mínima',
                              helperText: 'Alerta reposição',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      child: Text(
                        _isSaving ? 'Salvando...' : 'Salvar Medicamento',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
