import 'package:flutter/material.dart';

import '../../../../core/services/backup_service.dart';
import '../../../../core/theme/app_spacing.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  final BackupService _backupService = BackupService();
  bool _isLoading = false;
  String? _lastBackupResult;
  List<BackupInfo> _backups = [];

  @override
  void initState() {
    super.initState();
    _loadBackups();
  }

  @override
  void dispose() {
    _backupService.dispose();
    super.dispose();
  }

  Future<void> _loadBackups() async {
    try {
      final backups = await _backupService.listBackups();
      if (mounted) {
        setState(() {
          _backups = backups;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao carregar backups: $e')));
      }
    }
  }

  Future<void> _createBackup() async {
    setState(() {
      _isLoading = true;
      _lastBackupResult = null;
    });

    try {
      final result = await _backupService.createBackup();

      if (mounted) {
        setState(() {
          _isLoading = false;
          _lastBackupResult =
              'Backup criado com sucesso!\n'
              'ID: ${result.backupId}\n'
              'Paciente: ${result.patientName}\n'
              'Data: ${result.createdAt}\n'
              'Tamanho: ${result.sizeBytes} bytes';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup criado com sucesso!')),
        );

        // Reload backups list
        await _loadBackups();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _lastBackupResult = 'Erro ao criar backup: $e';
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao criar backup: $e')));
      }
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Backup')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Proteja os dados do MedControl com cópias de segurança.',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Crie backups dos seus dados e visualize backups anteriores.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _createBackup,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Iniciar backup'),
                  ),
                  if (_lastBackupResult != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: _lastBackupResult!.startsWith('Erro')
                            ? Colors.red.shade50
                            : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _lastBackupResult!.startsWith('Erro')
                              ? Colors.red.shade200
                              : Colors.green.shade200,
                        ),
                      ),
                      child: Text(
                        _lastBackupResult!,
                        style: TextStyle(
                          color: _lastBackupResult!.startsWith('Erro')
                              ? Colors.red.shade800
                              : Colors.green.shade800,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Backups Anteriores',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: _backups.isEmpty
                        ? Center(
                            child: Text(
                              'Nenhum backup encontrado',
                              style: theme.textTheme.bodyMedium,
                            ),
                          )
                        : ListView.builder(
                            itemCount: _backups.length,
                            itemBuilder: (context, index) {
                              final backup = _backups[index];
                              return Card(
                                margin: const EdgeInsets.only(
                                  bottom: AppSpacing.sm,
                                ),
                                child: ListTile(
                                  title: Text(backup.patientName),
                                  subtitle: Text(
                                    'Criado em: ${_formatDate(backup.createdAt)}\n'
                                    'Tamanho: ${_formatFileSize(backup.sizeBytes)}',
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.more_vert),
                                    onPressed: () {
                                      // TODO: Implement backup options (download, delete)
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Opções de backup em desenvolvimento',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
