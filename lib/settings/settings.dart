import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/credentials/entity/credential.dart';
import 'package:sit/entity/campus.dart';
import 'package:sit/school/settings.dart';
import 'package:sit/timetable/settings.dart';
import 'package:sit/utils/collection.dart';

import '../life/settings.dart';

class _K {
  static const ns = "/settings";
  static const campus = '$ns/campus';
  static const focusTimetable = '$ns/focusTimetable';
  static const lastSignature = '$ns/lastSignature';
}

class _DeveloperK {
  static const ns = '/developer';
  static const devMode = '$ns/devMode';
  static const savedOaCredentialsList = '$ns/savedOaCredentialsList';
}

// ignore: non_constant_identifier_names
late SettingsImpl Settings;

class SettingsImpl {
  final Box box;

  SettingsImpl(this.box);

  late final life = LifeSettings(box);
  late final timetable = TimetableSettings(box);
  late final school = SchoolSettings(box);
  late final theme = _Theme(box);
  late final proxy = _Proxy(box);

  Campus get campus => box.get(_K.campus) ?? Campus.fengxian;

  set campus(Campus newV) => box.put(_K.campus, newV);

  ValueListenable<Box> listenCampus() => box.listenable(keys: [_K.campus]);

  bool get focusTimetable => box.get(_K.focusTimetable) ?? false;

  set focusTimetable(bool newV) => box.put(_K.focusTimetable, newV);

  ValueListenable<Box> listenFocusTimetable() => box.listenable(keys: [_K.focusTimetable]);

  String? get lastSignature => box.get(_K.lastSignature);

  set lastSignature(String? value) => box.put(_K.lastSignature, value);

  /// [false] by default.
  bool get isDeveloperMode => box.get(_DeveloperK.devMode) ?? false;

  set isDeveloperMode(bool newV) => box.put(_DeveloperK.devMode, newV);

  ValueListenable<Box> listenIsDeveloperMode() => box.listenable(keys: [_DeveloperK.devMode]);

  List<Credentials>? getSavedOaCredentialsList() =>
      (box.get(_DeveloperK.savedOaCredentialsList) as List?)?.cast<Credentials>();

  Future<void> setSavedOaCredentialsList(List<Credentials>? newV) async {
    newV?.distinctBy((c) => c.account);
    await box.put(_DeveloperK.savedOaCredentialsList, newV);
  }
}

class _ThemeK {
  static const ns = '/theme';
  static const themeColor = '$ns/themeColor';
  static const themeMode = '$ns/themeMode';
}

class _Theme {
  final Box box;

  const _Theme(this.box);

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

  ValueListenable<Box> listenThemeMode() => box.listenable(keys: [_ThemeK.themeMode]);

  ValueListenable<Box> listenThemeChange() => box.listenable(keys: [_ThemeK.themeMode, _ThemeK.themeColor]);
}

enum ProxyType {
  http(
    defaultHost: "localhost",
    defaultPort: 3128,
    supportedProtocols: [
      "http",
      "https",
    ],
    defaultProtocol: "http",
  ),
  https(
    defaultHost: "localhost",
    defaultPort: 443,
    supportedProtocols: [
      "http",
      "https",
    ],
    defaultProtocol: "https",
  ),
  all(
    defaultHost: "localhost",
    defaultPort: 1080,
    supportedProtocols: [
      "socks5",
    ],
    defaultProtocol: "socks5",
  );

  final String defaultHost;
  final int defaultPort;
  final List<String> supportedProtocols;
  final String defaultProtocol;

  String l10n() => "settings.proxy.proxyType.$name".tr();

  const ProxyType({
    required this.defaultHost,
    required this.defaultPort,
    required this.supportedProtocols,
    required this.defaultProtocol,
  });
}

class _ProxyK {
  static const ns = '/proxy';

  static String address(ProxyType type) => "$ns/${type.name}/address";

  static String enabled(ProxyType type) => "$ns/${type.name}/enabled";

  static String globalMode(ProxyType type) => "$ns/${type.name}/globalMode";
}

typedef ProxyProfileRecords = ({String? address, bool enabled, bool globalMode});

class ProxyProfile {
  final Box box;
  final ProxyType type;

  ProxyProfile(this.box, String ns, this.type);

  String? get address => box.get(_ProxyK.address(type));

  set address(String? newV) => box.put(_ProxyK.address(type), newV);

  /// [false] by default.
  bool get enabled => box.get(_ProxyK.enabled(type)) ?? false;

  set enabled(bool newV) => box.put(_ProxyK.enabled(type), newV);

  /// [false] by default.
  bool get globalMode => box.get(_ProxyK.globalMode(type)) ?? false;

  set globalMode(bool newV) => box.put(_ProxyK.globalMode(type), newV);
}

class _Proxy {
  final Box box;

  _Proxy(this.box)
      : http = ProxyProfile(box, _ProxyK.ns, ProxyType.http),
        https = ProxyProfile(box, _ProxyK.ns, ProxyType.https),
        all = ProxyProfile(box, _ProxyK.ns, ProxyType.all);

  final ProxyProfile http;
  final ProxyProfile https;
  final ProxyProfile all;

  ProxyProfile resolve(ProxyType type) {
    return switch (type) {
      ProxyType.http => http,
      ProxyType.https => https,
      ProxyType.all => all,
    };
  }

  void setProfile(ProxyType type, ProxyProfileRecords value) {
    final profile = resolve(type);
    profile.address = value.address;
    profile.enabled = value.enabled;
    profile.globalMode = value.globalMode;
  }

  bool get anyEnabled => http.enabled || https.enabled || all.enabled;

  set anyEnabled(bool value) {
    http.enabled = value;
    https.enabled = value;
    all.enabled;
  }

  Listenable listenAnyEnabled() => box.listenable(keys: ProxyType.values.map((type) => _ProxyK.enabled(type)).toList());
}
