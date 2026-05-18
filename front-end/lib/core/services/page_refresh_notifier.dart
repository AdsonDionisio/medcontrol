import 'package:flutter/foundation.dart';

class PageRefreshNotifier {
  static final PageRefreshNotifier _instance = PageRefreshNotifier._internal();

  factory PageRefreshNotifier() => _instance;

  PageRefreshNotifier._internal();

  // Notificadores para cada página
  final scheduleRefresh = ValueNotifier<bool>(false);
  final historyRefresh = ValueNotifier<bool>(false);

  void refreshSchedules() {
    scheduleRefresh.value = !scheduleRefresh.value;
  }

  void refreshHistory() {
    historyRefresh.value = !historyRefresh.value;
  }
}
