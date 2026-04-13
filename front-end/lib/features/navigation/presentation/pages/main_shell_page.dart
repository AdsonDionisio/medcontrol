import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';

class MainShellPage extends StatelessWidget {
  const MainShellPage({
    super.key,
    required this.currentRoute,
    required this.pages,
  });

  final String currentRoute;
  final List<Widget> pages;

  static const _destinations = <({String route, String label, IconData icon})>[
    (route: AppRoutes.home, label: 'Inicio', icon: Icons.home_outlined),
    (
      route: AppRoutes.medications,
      label: 'Medicamentos',
      icon: Icons.medication_outlined,
    ),
    (
      route: AppRoutes.schedules,
      label: 'Agendamentos',
      icon: Icons.calendar_month_outlined,
    ),
    (
      route: AppRoutes.history,
      label: 'Historico',
      icon: Icons.history_outlined,
    ),
    (
      route: AppRoutes.measurements,
      label: 'Afericoes',
      icon: Icons.monitor_heart_outlined,
    ),
    (
      route: AppRoutes.settings,
      label: 'Configuracoes',
      icon: Icons.settings_outlined,
    ),
  ];

  int get _currentIndex {
    final index = _destinations.indexWhere(
      (destination) => destination.route == currentRoute,
    );

    return index >= 0 ? index : 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    final destination = _destinations[index];

    if (destination.route == currentRoute) {
      return;
    }

    Navigator.of(context).pushReplacementNamed(destination.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) =>
            _onDestinationSelected(context, index),
        destinations: _destinations
            .map(
              (destination) => NavigationDestination(
                icon: Icon(destination.icon),
                label: destination.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
