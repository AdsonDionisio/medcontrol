import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../patient/data/patient_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _patientRepository = PatientRepository();
  bool _hasPatient = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkPatient();
  }

  Future<void> _checkPatient() async {
    final patient = await _patientRepository.getCurrentPatient();
    if (mounted) {
      setState(() {
        _hasPatient = patient != null;
        _isLoading = false;
      });
    }
  }

  static const _shortcuts =
      <({String title, String description, String route, IconData icon})>[
        (
          title: 'Medicamentos',
          description: 'Cadastre remedios e acompanhe o uso diario.',
          route: AppRoutes.medications,
          icon: Icons.medication_outlined,
        ),
        (
          title: 'Agendamentos',
          description: 'Organize horarios, doses e lembretes.',
          route: AppRoutes.schedules,
          icon: Icons.calendar_month_outlined,
        ),
        (
          title: 'Historico',
          description: 'Consulte registros e acompanhamentos anteriores.',
          route: AppRoutes.history,
          icon: Icons.history_outlined,
        ),
        (
          title: 'Afericoes',
          description: 'Anote pressao, glicemia e outros dados.',
          route: AppRoutes.measurements,
          icon: Icons.monitor_heart_outlined,
        ),
        (
          title: 'Backup',
          description: 'Proteja os dados do aplicativo com seguranca.',
          route: AppRoutes.backup,
          icon: Icons.cloud_upload_outlined,
        ),
      ];

  void _openShortcut(BuildContext context, String route) {
    if (route == AppRoutes.backup) {
      Navigator.of(context).pushNamed(route);
      return;
    }

    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_hasPatient) ...[
                  Card(
                    color: AppColors.surfaceSoft,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Inicio', style: theme.textTheme.titleLarge),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Escolha uma area principal para continuar no MedControl.',
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'O cadastro basico do paciente ja pode ser salvo localmente no dispositivo.',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          ElevatedButton(
                            onPressed: () async {
                              await Navigator.of(context).pushNamed(AppRoutes.patient);
                              _checkPatient();
                            },
                            child: const Text('Cadastrar paciente'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ] else ...[
                  Text('Inicio', style: theme.textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Escolha uma area principal para continuar no MedControl.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                Text('Acessos rapidos', style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSpacing.md),
                ..._shortcuts.map(
                  (shortcut) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _ShortcutCard(
                      title: shortcut.title,
                      description: shortcut.description,
                      icon: shortcut.icon,
                      onTap: () => _openShortcut(context, shortcut.route),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppColors.brandDark, size: 28),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(description, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.arrow_forward_ios_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
