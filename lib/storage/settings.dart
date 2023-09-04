import 'dart:ui';

import 'package:hive_flutter/hive_flutter.dart';

import '../r.dart';

class _K {
  static const ns = "/settings";
  static const campus = '$ns/campus';
}

class _ThemeK {
  static const ns = '/theme';
  static const themeColor = '$ns/themeColor';
  static const isDarkMode = '$ns/isDarkMode';
  static const lastWindowSize = '$ns/lastWindowSize';
}

class _NetworkK {
  static const ns = '/network';
  static const proxy = '$ns/proxy';
  static const useProxy = '$ns/useProxy';
  static const isGlobalProxy = '$ns/isGlobalProxy';
}

class _DeveloperK {
  static const ns = '/developer';
  static const showErrorInfoDialog = '$ns/showErrorInfoDialog';
}

late SettingsImpl Settings;

class SettingsImpl {
  final Box<dynamic> box;

  const SettingsImpl(this.box);

  int get campus => box.get(_K.campus, defaultValue: 1);

  set campus(int v) => box.put(_K.campus, v);

  Color? get themeColor {
    final value = box.get(_ThemeK.themeColor);
    if (value == null) {
      return null;
    } else {
      return Color(value);
    }
  }

  set themeColor(Color? v) {
    box.put(_ThemeK.themeColor, v?.value);
  }

  bool? get isDarkMode => box.get(_ThemeK.isDarkMode, defaultValue: false);

  set isDarkMode(value) => box.put(_ThemeK.isDarkMode, value ?? false);

  Size? get lastWindowSize => box.get(_ThemeK.lastWindowSize, defaultValue: R.defaultWindowSize);

  set lastWindowSize(value) => box.put(_ThemeK.lastWindowSize, value ?? R.defaultWindowSize);

  String get proxy => box.get(_NetworkK.proxy, defaultValue: '');

  set proxy(String foo) => box.put(_NetworkK.proxy, foo);

  bool get useProxy => box.get(_NetworkK.useProxy) ?? false;

  set useProxy(bool foo) => box.put(_NetworkK.useProxy, foo);

  bool get isGlobalProxy => box.get(_NetworkK.isGlobalProxy) ?? false;

  set isGlobalProxy(bool foo) => box.put(_NetworkK.isGlobalProxy, foo);

  bool? get showErrorInfoDialog => box.get(_DeveloperK.showErrorInfoDialog);

  set showErrorInfoDialog(bool? foo) => box.put(_DeveloperK.showErrorInfoDialog, foo);
}
