import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/history/data/dose_repository.dart';
import '../database/app_database.dart';
import 'app_settings_repository.dart';

@pragma('vm:entry-point')
void backgroundNotificationHandler(NotificationResponse response) async {
  await NotificationService().handleNotificationResponse(response);
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) {
      return;
    }

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: backgroundNotificationHandler,
    );

    if (Platform.isAndroid) {
      final androidImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      await androidImplementation?.createNotificationChannel(
        const AndroidNotificationChannel(
          'medcontrol_alarm_channel',
          'Alarme de Medicamentos',
          description: 'Alarmes para avisar quando tomar remedios',
          importance: Importance.max,
          audioAttributesUsage: AudioAttributesUsage.alarm,
        ),
      );
    }

    _initialized = true;
  }

  Future<void> _onNotificationTapped(NotificationResponse response) async {
    await handleNotificationResponse(response);
  }

  Future<void> handleNotificationResponse(NotificationResponse response) async {
    if (response.payload == null) {
      return;
    }

    WidgetsFlutterBinding.ensureInitialized();
    final database = AppDatabase.instance;
    await database.initialize();

    final payloadMap = jsonDecode(response.payload!) as Map<String, dynamic>;
    final medicationId = payloadMap['medicationId'] as int;
    final scheduleId = payloadMap['scheduleId'] as int;

    if (response.actionId == 'confirm') {
      await DoseRepository(database: database).saveRecord(
        medicationId: medicationId,
        scheduleId: scheduleId,
        scheduledFor: DateTime.now(),
        takenAt: DateTime.now(),
        status: 'taken',
      );

      await removePendingAlarm(
        notificationId: response.id,
        scheduleId: scheduleId,
      );
      return;
    }

    if (response.actionId == 'snooze') {
      final settings = await AppSettingsRepository(
        database: database,
      ).getSettings();
      final newTime = DateTime.now().add(
        Duration(minutes: settings.snoozeMinutes),
      );
      final snoozeNotificationId = createSnoozeNotificationId(scheduleId);

      await DoseRepository(database: database).saveRecord(
        medicationId: medicationId,
        scheduleId: scheduleId,
        scheduledFor: newTime,
        status: 'postponed',
      );

      await removePendingAlarm(
        notificationId: response.id,
        scheduleId: scheduleId,
      );

      await scheduleNotification(
        id: snoozeNotificationId,
        title: payloadMap['title'] as String? ?? 'Lembrete de Medicamento',
        body: payloadMap['body'] as String? ?? 'Hora de tomar sua medicacao',
        scheduledDate: newTime,
        payload: response.payload,
        repeatDaily: false,
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
    bool repeatDaily = true,
  }) async {
    if (!_initialized) {
      await init();
    }

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
          category: AndroidNotificationCategory.alarm,
          visibility: NotificationVisibility.public,
          playSound: true,
          ongoing: true,
          autoCancel: false,
          fullScreenIntent: true,
          audioAttributesUsage: AudioAttributesUsage.alarm,
          additionalFlags: Int32List.fromList(<int>[4]),
          actions: const [
            AndroidNotificationAction(
              'snooze',
              'Adiar',
              showsUserInterface: true,
              cancelNotification: true,
            ),
            AndroidNotificationAction(
              'confirm',
              'Confirmar',
              showsUserInterface: true,
              cancelNotification: true,
            ),
          ],
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: repeatDaily ? DateTimeComponents.time : null,
      payload: payload,
    );

    await addPendingAlarm(id, payload ?? '');
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

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  int createSnoozeNotificationId(int scheduleId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.remainder(1000000);
    return (scheduleId * 1000000) + timestamp;
  }

  Future<void> addPendingAlarm(int notificationId, String payload) async {
    final prefs = await SharedPreferences.getInstance();
    final pending = prefs.getStringList('pending_alarms') ?? [];
    final scheduleId = _extractScheduleId(payload) ?? notificationId;

    pending.removeWhere((entry) {
      final map = jsonDecode(entry) as Map<String, dynamic>;
      return map['notificationId'] == notificationId ||
          ((map['scheduleId'] ?? map['id']) == scheduleId);
    });

    pending.add(
      jsonEncode({
        'id': scheduleId,
        'scheduleId': scheduleId,
        'notificationId': notificationId,
        'payload': payload,
      }),
    );
    await prefs.setStringList('pending_alarms', pending);
  }

  Future<void> removePendingAlarm({
    int? notificationId,
    int? scheduleId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final pending = prefs.getStringList('pending_alarms') ?? [];
    pending.removeWhere((entry) {
      final map = jsonDecode(entry) as Map<String, dynamic>;
      final entryNotificationId = map['notificationId'] as int?;
      final entryScheduleId = (map['scheduleId'] ?? map['id']) as int?;

      return (notificationId != null &&
              entryNotificationId == notificationId) ||
          (scheduleId != null && entryScheduleId == scheduleId);
    });
    await prefs.setStringList('pending_alarms', pending);
  }

  Future<void> clearPendingAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('pending_alarms');
  }

  Future<List<Map<String, dynamic>>> getPendingAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final pending = prefs.getStringList('pending_alarms') ?? [];
    return pending
        .map((entry) => jsonDecode(entry) as Map<String, dynamic>)
        .toList();
  }

  int? _extractScheduleId(String payload) {
    if (payload.isEmpty) {
      return null;
    }

    try {
      final payloadMap = jsonDecode(payload) as Map<String, dynamic>;
      return payloadMap['scheduleId'] as int?;
    } catch (_) {
      return null;
    }
  }
}
