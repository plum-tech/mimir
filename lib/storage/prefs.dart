import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sit/r.dart';

class _K {
  static const lastVersion = "${R.appId}.lastVersion";
  static const lastWindowSize = "${R.appId}.lastWindowSize";
}

extension PrefsX on SharedPreferences {
  String? getLastVersion() => getString(_K.lastVersion);

  Future<void> setLastVersion(String value) => setString(_K.lastVersion, value);

  Size? getLastWindowSize() => _string2Size(getString(_K.lastWindowSize));

  Future<void> setLastWindowSize(Size value) => setString(_K.lastWindowSize, _size2String(value));
}

Size? _string2Size(String? value) {
  if (value == null) return null;
  final parts = value.split(",");
  if (parts.length != 2) return null;
  final width = int.tryParse(parts[0]);
  final height = int.tryParse(parts[1]);
  if (width == null || height == null) return null;
  return Size(width.toDouble(), height.toDouble());
}

String _size2String(Size size) {
  return "${size.width.toInt()},${size.height.toInt()}";
}
