import 'package:mimir/timetable/i18n.dart' as t;
import 'package:mimir/school/i18n.dart' as s;
import 'package:mimir/life/i18n.dart' as l;
import 'package:mimir/game/i18n.dart' as g;

class AppI18n {
  const AppI18n();
  final navigation = const _Navigation();
}

class _Navigation {
  const _Navigation();

  String get timetable => t.i18n.navigation;
  String get school => s.i18n.navigation;
  String get life => l.i18n.navigation;
  String get game => g.i18n.navigation;
}
