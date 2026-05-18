import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../database/app_database.dart';
import '../../app/app_routes.dart';
import '../../app/app_widget.dart';
import '../../features/history/data/dose_repository.dart';
import 'app_settings_repository.dart';

@pragma('vm:entry-point')
void backgroundNotificationHandler(NotificationResponse response) async {
  if (response.payload == null) return;

  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase.instance;
  await database.initialize();

  final payloadMap = jsonDecode(response.payload!) as Map<String, dynamic>;
  final int medicationId = payloadMap['medicationId'];
  final int scheduleId = payloadMap['scheduleId'];

  if (response.actionId == 'confirm') {
    final doseRepo = DoseRepository(database: database);
    await doseRepo.saveRecord(
      medicationId: medicationId,
      scheduleId: scheduleId,
      scheduledFor: DateTime.now(),
      takenAt: DateTime.now(),
      status: 'tomado',
    );
  } else if (response.actionId == 'snooze') {
    final settingsRepo = AppSettingsRepository(database: database);
    final settings = await settingsRepo.getSettings();
    final snoozeMinutes = settings.snoozeMinutes;

    final newTime = DateTime.now().add(Duration(minutes: snoozeMinutes));
    final notificationService = NotificationService();
    await notificationService.init();

    await notificationService.scheduleNotification(
      id: response.id!,
      title: payloadMap['title'] ?? 'Lembrete de Medicamento',
      body: payloadMap['body'] ?? 'Hora de tomar sua medicacao',
      scheduledDate: newTime,
      payload: response.payload,
    );
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: backgroundNotificationHandler,
    );

    _initialized = true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      final payloadMap = jsonDecode(response.payload!) as Map<String, dynamic>;
      final int medicationId = payloadMap['medicationId'];
      final int scheduleId = payloadMap['scheduleId'];

      // Cancel the notification
      flutterLocalNotificationsPlugin.cancel(response.id!);

      // Navigate to reminder page
      MedControlApp.navigatorKey.currentState?.pushNamed(
        AppRoutes.medicationReminder,
        arguments: {'medicationId': medicationId, 'scheduleId': scheduleId},
      );
    }
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      final androidImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      await androidImplementation?.requestNotificationsPermission();
      await androidImplementation?.requestExactAlarmsPermission();
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    bool repeats = true,
  }) async {
    final matchDateTimeComponents = repeats ? DateTimeComponents.time : null;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'medcontrol_alarm_channel',
          'Alarme de Medicamentos',
          channelDescription: 'Alarmes para avisar quando tomar remedios',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
          playSound: true,
          ongoing: true,
          autoCancel: false,
          category: AndroidNotificationCategory.alarm,
          visibility: NotificationVisibility.public,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: matchDateTimeComponents,
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medcontrol_stock_channel',
          'Falta de Estoque',
          channelDescription: 'Alertas de falta de estoque',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
