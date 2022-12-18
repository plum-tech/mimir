import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mimir/r.dart';

import '../dao/theme.dart';

class ThemeKeys {
  static const namespace = '/theme';
  static const themeColor = '$namespace/color';
  static const isDarkMode = '$namespace/isDarkMode';
  static const lastWindowSize = '$namespace/lastWindowSize';
}

class ThemeSettingStorage implements ThemeSettingDao {
  final Box<dynamic> box;

  ThemeSettingStorage(this.box);

  @override
  Color? get color {
    // TODO: Use the Color Adapter next version
    // NOTE: The settings
    final String? value = box.get(ThemeKeys.themeColor);
    if (value != null) {
      var hex = value.replaceFirst('#', '');
      final colorValue = int.tryParse(hex, radix: 16);
      if (colorValue != null) {
        return Color(colorValue);
      }
    }
    return R.defaultThemeColor;
  }

  @override
  set color(Color? v) {
    if (v != null) {
      box.put(ThemeKeys.themeColor, v);
    }
  }

  @override
  bool? get isDarkMode => box.get(ThemeKeys.isDarkMode, defaultValue: false);

  @override
  set isDarkMode(value) => box.put(ThemeKeys.isDarkMode, value ?? false);

  @override
  Size? get lastWindowSize => box.get(ThemeKeys.lastWindowSize, defaultValue: R.defaultWindowSize);

  @override
  set lastWindowSize(value) => box.put(ThemeKeys.lastWindowSize, value ?? R.defaultWindowSize);
}
