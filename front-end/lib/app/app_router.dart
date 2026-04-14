import 'package:flutter/material.dart';

import '../features/backup/presentation/pages/backup_page.dart';
import '../features/history/presentation/pages/history_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/measurements/presentation/pages/measurements_page.dart';
import '../features/medications/presentation/pages/medications_page.dart';
import '../features/navigation/presentation/pages/main_shell_page.dart';
import '../features/patient/presentation/pages/patient_form_page.dart';
import '../features/schedules/presentation/pages/schedules_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import 'app_routes.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (settings.name == AppRoutes.backup) {
      return MaterialPageRoute<void>(
        settings: const RouteSettings(name: AppRoutes.backup),
        builder: (_) => const BackupPage(),
      );
    }

    if (settings.name == AppRoutes.patient) {
      return MaterialPageRoute<void>(
        settings: const RouteSettings(name: AppRoutes.patient),
        builder: (_) => const PatientFormPage(),
      );
    }

    final routeName = AppRoutes.mainRoutes.contains(settings.name)
        ? settings.name!
        : AppRoutes.home;

    return MaterialPageRoute<void>(
      settings: RouteSettings(name: routeName),
      builder: (_) => MainShellPage(
        initialRoute: routeName,
        pages: const [
          HomePage(),
          MedicationsPage(),
          SchedulesPage(),
          HistoryPage(),
          MeasurementsPage(),
          SettingsPage(),
        ],
      ),
    );
  }
}
