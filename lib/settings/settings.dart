import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/utils/hive.dart';
import 'package:sit/entity/campus.dart';
import 'package:sit/school/settings.dart';
import 'package:sit/storage/hive/type_id.dart';
import 'package:sit/timetable/settings.dart';

import '../life/settings.dart';

part "settings.g.dart";

class _K {
  static const ns = "/settings";
  static const campus = '$ns/campus';
  static const focusTimetable = '$ns/focusTimetable';
  static const lastSignature = '$ns/lastSignature';
}

class _UpdateK {
  static const ns = '/update';
  static const skippedVersion = '$ns/skippedVersion';
  static const lastSkipUpdateTime = '$ns/lastSkipUpdateTime';
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

  Campus get campus => box.safeGet<Campus>(_K.campus) ?? Campus.fengxian;

  set campus(Campus newV) => box.safePut<Campus>(_K.campus, newV);

  late final $campus = box.provider<Campus>(_K.campus);

  bool get focusTimetable => box.safeGet<bool>(_K.focusTimetable) ?? false;

  set focusTimetable(bool newV) => box.safePut<bool>(_K.focusTimetable, newV);

  late final $focusTimetable = box.provider<bool>(_K.focusTimetable);

  String? get lastSignature => box.safeGet<String>(_K.lastSignature);

  set lastSignature(String? value) => box.safePut<String>(_K.lastSignature, value);

  String? get skippedVersion => box.safeGet<String>(_UpdateK.skippedVersion);

  set skippedVersion(String? newV) => box.safePut<String>(_UpdateK.skippedVersion, newV);

  DateTime? get lastSkipUpdateTime => box.safeGet<DateTime>(_UpdateK.lastSkipUpdateTime);

  set lastSkipUpdateTime(DateTime? newV) => box.safePut<DateTime>(_UpdateK.lastSkipUpdateTime, newV);
}

class _ThemeK {
  static const ns = '/theme';
  static const themeColorFromSystem = '$ns/themeColorFromSystem';
  static const themeColor = '$ns/themeColor';
  static const themeMode = '$ns/themeMode';
}

class _Theme {
  final Box box;

  _Theme(this.box);

  // theme
  Color? get themeColor {
    final value = box.safeGet<int>(_ThemeK.themeColor);
    if (value == null) {
      return null;
    } else {
      return Color(value);
    }
  }

  set themeColor(Color? v) {
    box.safePut(_ThemeK.themeColor, v?.value);
  }

  late final $themeColor = box.provider<Color>(
    _ThemeK.themeColor,
    get: () => themeColor,
    set: (v) => themeColor = v,
  );

  bool get themeColorFromSystem => box.safeGet(_ThemeK.themeColorFromSystem) ?? true;

  set themeColorFromSystem(bool value) => box.safePut(_ThemeK.themeColorFromSystem, value);

  late final $themeColorFromSystem = box.provider<bool>(_ThemeK.themeColorFromSystem);

  /// [ThemeMode.system] by default.
  ThemeMode get themeMode => box.safeGet(_ThemeK.themeMode) ?? ThemeMode.system;

  set themeMode(ThemeMode value) => box.safePut(_ThemeK.themeMode, value);

  late final $themeMode = box.provider<ThemeMode>(_ThemeK.themeMode);
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

  Uri buildDefaultUri() => Uri(scheme: defaultProtocol, host: defaultHost, port: defaultPort);

  bool isDefaultUri(Uri uri) {
    if (uri.scheme != defaultProtocol) return false;
    if (uri.host != defaultHost) return false;
    if (uri.port != defaultPort) return false;
    if (uri.hasQuery) return false;
    if (uri.hasFragment) return false;
    if (uri.userInfo.isNotEmpty) return false;
    return true;
  }
}

@HiveType(typeId: CoreHiveType.proxyMode)
enum ProxyMode {
  @HiveField(0)
  global,
  @HiveField(1)
  schoolOnly;

  String l10nName() => "settings.proxy.proxyMode.$name.name".tr();

  String l10nTip() => "settings.proxy.proxyMode.$name.tip".tr();
}

class _ProxyK {
  static const ns = '/proxy';

  static String address(ProxyType type) => "$ns/${type.name}/address";

  static String enabled(ProxyType type) => "$ns/${type.name}/enabled";

  static String proxyMode(ProxyType type) => "$ns/${type.name}/proxyMode";
}

typedef ProxyProfileRecords = ({String? address, bool enabled, ProxyMode proxyMode});

class ProxyProfile {
  final Box box;
  final ProxyType type;

  ProxyProfile(this.box, String ns, this.type);

  String? get address => box.safeGet(_ProxyK.address(type));

  set address(String? newV) => box.safePut(_ProxyK.address(type), newV);

  /// [false] by default.
  bool get enabled => box.safeGet(_ProxyK.enabled(type)) ?? false;

  set enabled(bool newV) => box.safePut(_ProxyK.enabled(type), newV);

  /// [ProxyMode.schoolOnly] by default.
  ProxyMode get proxyMode => box.safeGet(_ProxyK.proxyMode(type)) ?? ProxyMode.schoolOnly;

  set proxyMode(ProxyMode newV) => box.safePut(_ProxyK.proxyMode(type), newV);

  bool get isDefaultAddress {
    final address = this.address;
    if (address == null) return true;
    final uri = Uri.tryParse(address);
    if (uri == null) return true;
    return type.isDefaultUri(uri);
  }
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
    profile.proxyMode = value.proxyMode;
  }

  bool get anyEnabled => http.enabled || https.enabled || all.enabled;

  set anyEnabled(bool value) {
    http.enabled = value;
    https.enabled = value;
    all.enabled = value;
  }

  Listenable listenAnyEnabled() => box.listenable(keys: ProxyType.values.map((type) => _ProxyK.enabled(type)).toList());

  /// return null if their proxy mode are not identical.
  ProxyMode? getIntegratedProxyMode() {
    final httpMode = http.proxyMode;
    final httpsMode = https.proxyMode;
    final allMode = all.proxyMode;
    if (httpMode == httpsMode && httpMode == allMode) {
      return httpMode;
    } else {
      return null;
    }
  }

  setIntegratedProxyMode(ProxyMode mode) {
    http.proxyMode = mode;
    https.proxyMode = mode;
    all.proxyMode = mode;
  }

  /// return null if their proxy mode are not identical.
  bool hasAnyProxyMode(ProxyMode mode) {
    return http.proxyMode == mode || https.proxyMode == mode || all.proxyMode == mode;
  }

  Listenable listenProxyMode() =>
      box.listenable(keys: ProxyType.values.map((type) => _ProxyK.proxyMode(type)).toList());

  Listenable listenAnyChange({bool address = true, bool enabled = true, ProxyType? type}) {
    if (type == null) {
      return box.listenable(keys: [
        if (address) ProxyType.values.map((type) => _ProxyK.address(type)),
        if (enabled) ProxyType.values.map((type) => _ProxyK.enabled(type)),
      ]);
    } else {
      return box.listenable(keys: [
        if (address) _ProxyK.address(type),
        if (enabled) _ProxyK.enabled(type),
      ]);
    }
  }
}
