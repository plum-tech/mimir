import 'dart:ui';

abstract class PrefDao {
  Locale? get locale;

  set locale(Locale? value);
}
