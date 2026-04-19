import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/app_settings_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../history/data/dose_repository.dart';
import '../../../patient/data/patient_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _patientRepository = PatientRepository();
  final _notificationService = NotificationService();
  bool _hasPatient = false;
  bool _isLoading = true;
  List<Map<String, dynamic>> _pendingAlarms = [];

  @override
  void initState() {
    super.initState();
    _checkPatient();
    _loadPendingAlarms();
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

  Future<void> _loadPendingAlarms() async {
    final pending = await _notificationService.getPendingAlarms();
    if (mounted) {
      setState(() {
        _pendingAlarms = pending;
      });
    }
  }

  Future<void> _confirmAlarm(Map<String, dynamic> alarm) async {
    final payload = alarm['payload'] as String;
    final payloadMap = jsonDecode(payload) as Map<String, dynamic>;
    final medicationId = payloadMap['medicationId'] as int;
    final scheduleId = payloadMap['scheduleId'] as int;
    final notificationId = alarm['notificationId'] as int?;

    // Save dose
    final database = AppDatabase.instance;
    await database.initialize();
    final doseRepo = DoseRepository(database: database);
    await doseRepo.saveRecord(
      medicationId: medicationId,
      scheduleId: scheduleId,
      scheduledFor: DateTime.now(),
      takenAt: DateTime.now(),
      status: 'taken',
    );

    if (notificationId != null) {
      await _notificationService.cancelNotification(notificationId);
    }

    await _notificationService.removePendingAlarm(
      notificationId: notificationId,
      scheduleId: scheduleId,
    );
    _loadPendingAlarms();
  }

  Future<void> _snoozeAlarm(Map<String, dynamic> alarm) async {
    final payload = alarm['payload'] as String;
    final payloadMap = jsonDecode(payload) as Map<String, dynamic>;
    final title = payloadMap['title'] as String;
    final body = payloadMap['body'] as String;
    final medicationId = payloadMap['medicationId'] as int;
    final scheduleId = payloadMap['scheduleId'] as int;
    final notificationId = alarm['notificationId'] as int?;

    final database = AppDatabase.instance;
    await database.initialize();
    final settingsRepo = AppSettingsRepository(database: database);
    final settings = await settingsRepo.getSettings();
    final snoozeMinutes = settings.snoozeMinutes;

    final now = DateTime.now();
    final newTime = now.add(Duration(minutes: snoozeMinutes));

    await DoseRepository(database: database).saveRecord(
      medicationId: medicationId,
      scheduleId: scheduleId,
      scheduledFor: newTime,
      status: 'postponed',
    );

    if (notificationId != null) {
      await _notificationService.cancelNotification(notificationId);
    }

    await _notificationService.removePendingAlarm(
      notificationId: notificationId,
      scheduleId: scheduleId,
    );

    await _notificationService.scheduleNotification(
      id: _notificationService.createSnoozeNotificationId(scheduleId),
      title: title,
      body: body,
      scheduledDate: newTime,
      payload: payload,
      repeatDaily: false,
    );

    _loadPendingAlarms();
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
                              await Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.patient);
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
                if (_pendingAlarms.isNotEmpty) ...[
                  Text(
                    'Lembretes Pendentes',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ..._pendingAlarms.map(
                    (alarm) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _PendingAlarmCard(
                        alarm: alarm,
                        onConfirm: () => _confirmAlarm(alarm),
                        onSnooze: () => _snoozeAlarm(alarm),
                      ),
                    ),
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

class _PendingAlarmCard extends StatelessWidget {
  const _PendingAlarmCard({
    required this.alarm,
    required this.onConfirm,
    required this.onSnooze,
  });

  final Map<String, dynamic> alarm;
  final VoidCallback onConfirm;
  final VoidCallback onSnooze;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final payload = alarm['payload'] as String;
    final payloadMap = jsonDecode(payload) as Map<String, dynamic>;
    final title = payloadMap['title'] as String? ?? 'Lembrete de Medicamento';
    final body = payloadMap['body'] as String? ?? 'Hora de tomar sua medicacao';

    return Card(
      color: AppColors.error.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(body, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSnooze,
                    child: const Text('Adiar'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                    ),
                    child: const Text('Confirmar'),
                  ),
                ),
              ],
            ),
          ],
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
