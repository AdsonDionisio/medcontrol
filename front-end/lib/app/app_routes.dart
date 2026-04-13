class AppRoutes {
  const AppRoutes._();

  static const home = '/';
  static const medications = '/medications';
  static const schedules = '/schedules';
  static const history = '/history';
  static const measurements = '/measurements';
  static const settings = '/settings';
  static const backup = '/backup';
  static const patient = '/patient';

  static const mainRoutes = <String>[
    home,
    medications,
    schedules,
    history,
    measurements,
    settings,
  ];
}
