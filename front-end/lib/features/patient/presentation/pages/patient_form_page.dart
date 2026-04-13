import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../data/patient_repository.dart';

class PatientFormPage extends StatefulWidget {
  const PatientFormPage({super.key});

  @override
  State<PatientFormPage> createState() => _PatientFormPageState();
}

class _PatientFormPageState extends State<PatientFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _repository = PatientRepository();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _internalId;

  @override
  void initState() {
    super.initState();
    _loadPatient();
  }

  Future<void> _loadPatient() async {
    final patient = await _repository.getCurrentPatient();

    if (!mounted) {
      return;
    }

    setState(() {
      _internalId = patient?.internalId;
      _nameController.text = patient?.name ?? '';
      _ageController.text = patient?.age.toString() ?? '';
      _isLoading = false;
    });
  }

  Future<void> _savePatient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final savedPatient = await _repository.savePatient(
      name: _nameController.text,
      age: int.parse(_ageController.text),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _internalId = savedPatient.internalId;
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cadastro do paciente salvo localmente.')),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Paciente')),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cadastro basico do paciente',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Preencha nome e idade. O identificador interno e gerado automaticamente no primeiro salvamento.',
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          if (_internalId != null) ...[
                            Text(
                              'Id interno: $_internalId',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                          ],
                          TextFormField(
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Nome do paciente',
                              hintText: 'Digite o nome completo',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Informe o nome do paciente.';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Idade',
                              hintText: 'Digite a idade em anos',
                            ),
                            validator: (value) {
                              final age = int.tryParse(value ?? '');
                              if (age == null) {
                                return 'Informe uma idade valida.';
                              }
                              if (age <= 0 || age > 130) {
                                return 'Informe uma idade entre 1 e 130 anos.';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          ElevatedButton(
                            onPressed: _isSaving ? null : _savePatient,
                            child: Text(
                              _isSaving ? 'Salvando...' : 'Salvar paciente',
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
