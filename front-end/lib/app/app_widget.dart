import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'app_router.dart';
import 'app_routes.dart';

class MedControlApp extends StatelessWidget {
  const MedControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedControl',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
