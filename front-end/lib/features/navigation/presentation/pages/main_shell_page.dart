import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/services/page_refresh_notifier.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({
    super.key,
    required this.initialRoute,
    required this.pages,
  });

  final String initialRoute;
  final List<Widget> pages;

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
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

  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = _destinations.indexWhere(
      (destination) => destination.route == widget.initialRoute,
    );
    if (_currentIndex < 0) _currentIndex = 0;
  }

  void _onDestinationSelected(int index) {
    if (_currentIndex == index) {
      // Recarrega mesmo se clicar novamente
      _refreshCurrentPage();
      return;
    }
    setState(() {
      _currentIndex = index;
    });
    // Recarrega ao mudar de aba
    _refreshCurrentPage();
  }

  void _refreshCurrentPage() {
    // Notifica a página atual para recarregar
    final route = _destinations[_currentIndex].route;
    if (route == AppRoutes.schedules) {
      PageRefreshNotifier().refreshSchedules();
    } else if (route == AppRoutes.history) {
      PageRefreshNotifier().refreshHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: widget.pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
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
