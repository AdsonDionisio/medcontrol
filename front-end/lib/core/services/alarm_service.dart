import 'dart:async';
import 'package:flutter/services.dart';

class AlarmService {
  static final AlarmService _instance = AlarmService._internal();
  static const platform = MethodChannel(
    'com.example.medcontrol_frontend/alarm',
  );

  factory AlarmService() => _instance;

  AlarmService._internal();

  bool _isPlaying = false;
  Timer? _beepTimer;

  bool get isRunning => _isPlaying;

  Future<void> startAlarm() async {
    if (_isPlaying) return;

    _isPlaying = true;

    try {
      // Toca beep do sistema usando o channel nativo
      await platform.invokeMethod('playAlarm');
    } catch (e) {
      print('Erro ao iniciar alarme: $e');
      _isPlaying = false;
    }
  }

  Future<void> stopAlarm() async {
    _isPlaying = false;
    _beepTimer?.cancel();

    try {
      // Para o alarme no lado nativo
      await platform.invokeMethod('stopAlarm');
    } catch (e) {
      print('Erro ao parar alarme: $e');
    }
  }
}
