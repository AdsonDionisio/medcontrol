import 'package:flutter/material.dart';

import '../../../../core/database/models/backup_settings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/backup_repository.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  final _repository = BackupRepository();

  BackupSettings? _settings;
  BackupResult? _lastResult;
  bool _isLoading = true;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _repository.getSettings();
    if (!mounted) {
      return;
    }

    setState(() {
      _settings = settings;
      _isLoading = false;
    });
  }

  Future<void> _createBackup() async {
    setState(() {
      _isRunning = true;
    });

    try {
      final result = await _repository.createBackup();
      final settings = await _repository.getSettings();

      if (!mounted) {
        return;
      }

      setState(() {
        _lastResult = result;
        _settings = settings;
        _isRunning = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup concluido em ${result.filePath}')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isRunning = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Falha ao gerar backup: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Backup')),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Proteja os dados do MedControl com copias de seguranca.',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'O backup local gera um arquivo JSON com paciente, medicamentos, agendamentos, historico, afericoes e configuracoes.',
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Status do backup',
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  Text(
                                    'Ultimo backup: ${_formatDateTime(_settings?.lastBackupAt)}',
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    'Arquivo: ${_settings?.lastBackupPath ?? 'Nenhum arquivo gerado ainda.'}',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          ElevatedButton(
                            onPressed: _isRunning ? null : _createBackup,
                            child: Text(
                              _isRunning
                                  ? 'Gerando backup...'
                                  : 'Iniciar backup',
                            ),
                          ),
                          if (_lastResult != null) ...[
                            const SizedBox(height: AppSpacing.lg),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Resumo do ultimo arquivo',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: AppSpacing.md),
                                    Text(
                                      'Pacientes: ${_lastResult!.patientCount}',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    Text(
                                      'Medicamentos: ${_lastResult!.medicationCount}',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    Text(
                                      'Agendamentos: ${_lastResult!.scheduleCount}',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    Text(
                                      'Registros de dose: ${_lastResult!.doseRecordCount}',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    Text(
                                      'Afericoes: ${_lastResult!.measurementCount}',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  String _formatDateTime(DateTime? value) {
    if (value == null) {
      return 'Nenhum backup realizado';
    }

    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString().padLeft(4, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
}
