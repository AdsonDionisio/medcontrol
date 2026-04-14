import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/database/models/app_settings.dart';
import '../../../../core/services/app_settings_repository.dart';
import '../../../../core/theme/app_spacing.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _repository = AppSettingsRepository();
  bool _isLoading = true;
  AppSettings? _settings;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _repository.getSettings();
    if (mounted) {
      setState(() {
        _settings = settings;
        _isLoading = false;
      });
    }
  }

  void _onSnoozeChanged(int? newValue) async {
    if (newValue != null && _settings != null) {
      setState(() {
        _settings!.snoozeMinutes = newValue;
      });
      await _repository.updateSnoozeMinutes(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Configuracoes', style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Area reservada para preferencias, notificacoes e ajustes de acessibilidade.',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Tempo de Adiamento (Snooze)'),
                    subtitle: const Text('Tempo antes do alarme tocar de novo'),
                    trailing: DropdownButton<int>(
                      value: _settings?.snoozeMinutes ?? 5,
                      onChanged: _onSnoozeChanged,
                      items: const [
                        DropdownMenuItem(value: 5, child: Text('5 minutos')),
                        DropdownMenuItem(value: 10, child: Text('10 minutos')),
                        DropdownMenuItem(value: 15, child: Text('15 minutos')),
                        DropdownMenuItem(value: 30, child: Text('30 minutos')),
                      ],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Dados do Paciente'),
                    subtitle: const Text('Alterar nome e idade'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.patient);
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
