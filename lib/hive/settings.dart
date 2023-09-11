import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mimir/entity/campus.dart';

import '../r.dart';

class _K {
  static const ns = "/settings";
  static const campus = '$ns/campus';
}

class _ThemeK {
  static const ns = '/theme';
  static const themeColor = '$ns/themeColor';
  static const themeMode = '$ns/themeMode';
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
  static const devMode = '$ns/devMode';
}

late SettingsImpl Settings;

class SettingsImpl {
  final Box<dynamic> box;

  const SettingsImpl(this.box);

  // settings
  Campus get campus => box.get(_K.campus) ?? Campus.fengxian;

  set campus(Campus newV) => box.put(_K.campus, newV);

  ValueListenable<Box> get $campus => box.listenable(keys: [_K.campus]);

  // theme
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

  /// [ThemeMode.system] by default.
  ThemeMode get themeMode => box.get(_ThemeK.themeMode) ?? ThemeMode.system;

  set themeMode(ThemeMode value) => box.put(_ThemeK.themeMode, value);

  ValueListenable<Box> get $themeMode => box.listenable(keys: [_ThemeK.themeMode]);

  ValueListenable<Box> get onThemeChanged => box.listenable(keys: [_ThemeK.themeMode, _ThemeK.themeColor]);

  Size? get lastWindowSize => box.get(_ThemeK.lastWindowSize, defaultValue: R.defaultWindowSize);

  set lastWindowSize(Size? value) => box.put(_ThemeK.lastWindowSize, value ?? R.defaultWindowSize);

  // network
  String get proxy => box.get(_NetworkK.proxy, defaultValue: '');

  set proxy(String foo) => box.put(_NetworkK.proxy, foo);

  /// [false] by default.
  bool get useProxy => box.get(_NetworkK.useProxy) ?? false;

  set useProxy(bool foo) => box.put(_NetworkK.useProxy, foo);

  /// [false] by default.
  bool get isGlobalProxy => box.get(_NetworkK.isGlobalProxy) ?? false;

  set isGlobalProxy(bool foo) => box.put(_NetworkK.isGlobalProxy, foo);

  // Developer
  bool? get showErrorInfoDialog => box.get(_DeveloperK.showErrorInfoDialog);

  set showErrorInfoDialog(bool? foo) => box.put(_DeveloperK.showErrorInfoDialog, foo);

  /// [false] by default.
  bool get isDeveloperMode => box.get(_DeveloperK.devMode) ?? false;

  set isDeveloperMode(bool foo) => box.put(_DeveloperK.devMode, foo);

  ValueListenable<Box> get $isDeveloperMode => box.listenable(keys: [_DeveloperK.devMode]);
}
