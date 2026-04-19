import 'package:flutter/material.dart';

import 'app/app_widget.dart';
import 'core/database/app_database.dart';
import 'core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.instance.initialize();

  await NotificationService().init();
  await NotificationService().requestPermissions();

  runApp(const MedControlApp());
}
