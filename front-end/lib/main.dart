import 'package:flutter/material.dart';

import 'app/app_widget.dart';
import 'core/database/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.instance.initialize();
  runApp(const MedControlApp());
}
