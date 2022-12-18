import 'package:flutter/material.dart';

extension ThemeDataHelper on ThemeData {
  bool get isDark => brightness == Brightness.dark;
  bool get isLight => brightness == Brightness.light;
}
