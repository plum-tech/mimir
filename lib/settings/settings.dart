import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mimir/game/settings.dart';
import 'package:mimir/utils/hive.dart';
import 'package:mimir/entity/campus.dart';
import 'package:mimir/school/settings.dart';
import 'package:mimir/timetable/settings.dart';
import 'package:mimir/utils/json.dart';
import 'package:mimir/utils/riverpod.dart';
import 'package:statistics/statistics.dart';

import '../life/settings.dart';
import 'entity/agreements.dart';
import 'entity/proxy.dart';

class _K {
  static const ns = "/settings";
  static const campus = '$ns/campus';

  // static const focusTimetable = '$ns/focusTimetable';
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
  late final game = GameSettings(box);
  late final theme = _Theme(box);
  late final proxy = _Proxy(box);
  late final agreements = _Agreements(box);

  Campus get campus => box.safeGet<Campus>(_K.campus) ?? Campus.fengxian;

  set campus(Campus newV) => box.safePut<Campus>(_K.campus, newV);

  late final $campus = box.providerWithDefault<Campus>(_K.campus, () => Campus.fengxian);

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
    box.safePut<int>(_ThemeK.themeColor, v?.value);
  }

  late final $themeColor = box.provider<Color>(
    _ThemeK.themeColor,
    get: () => themeColor,
    set: (v) => themeColor = v,
  );

  bool get themeColorFromSystem => box.safeGet<bool>(_ThemeK.themeColorFromSystem) ?? true;

  set themeColorFromSystem(bool value) => box.safePut<bool>(_ThemeK.themeColorFromSystem, value);

  late final $themeColorFromSystem = box.provider<bool>(_ThemeK.themeColorFromSystem);

  /// [ThemeMode.system] by default.
  ThemeMode get themeMode => box.safeGet<ThemeMode>(_ThemeK.themeMode) ?? ThemeMode.system;

  set themeMode(ThemeMode value) => box.safePut<ThemeMode>(_ThemeK.themeMode, value);

  late final $themeMode = box.provider<ThemeMode>(_ThemeK.themeMode);
}

class _ProxyK {
  static const ns = '/proxy';

  static String keyOf(ProxyCat type) => "$ns/${type.name}";
}

class _Proxy {
  final Box box;

  _Proxy(this.box);

  ProxyProfile? getProfileOf(ProxyCat cat) =>
      decodeJsonObject(box.safeGet<String>(_ProxyK.keyOf(cat)), (obj) => ProxyProfile.fromJson(obj));

  Future<void> setProfileOf(ProxyCat cat, ProxyProfile? newV) async =>
      await box.safePut<String>(_ProxyK.keyOf(cat), encodeJsonObject(newV));

  ProxyProfile? get http => getProfileOf(ProxyCat.http);

  ProxyProfile? get https => getProfileOf(ProxyCat.https);

  ProxyProfile? get all => getProfileOf(ProxyCat.all);

  set http(ProxyProfile? profile) => setProfileOf(ProxyCat.http, profile);

  set https(ProxyProfile? profile) => setProfileOf(ProxyCat.https, profile);

  set all(ProxyProfile? profile) => setProfileOf(ProxyCat.all, profile);

  List<ProxyProfile> get profiles {
    final http = this.http;
    final https = this.https;
    final all = this.all;
    return [
      if (http != null) http,
      if (https != null) https,
      if (all != null) all,
    ];
  }

  FutureOr<void> applyForeach(
    FutureOr<void> Function(
      ProxyCat cat,
      ProxyProfile? profile,
      Future<void> Function(ProxyProfile?) set,
    ) func,
  ) async {
    for (final cat in ProxyCat.values) {
      await func(cat, getProfileOf(cat), (newV) => setProfileOf(cat, newV));
    }
  }

  bool get anyEnabled => profiles.any((profile) => profile.enabled);

  set anyEnabled(bool value) {
    applyForeach((cat, profile, set) {
      if (profile != null) {
        set(profile.copyWith(enabled: value));
      }
    });
  }

  /// return null if their proxy mode are not identical.
  ProxyMode? get integratedProxyMode {
    final profiles = this.profiles;
    return profiles.all((profile) => profile.mode == ProxyMode.schoolOnly)
        ? ProxyMode.schoolOnly
        : profiles.all((profile) => profile.mode == ProxyMode.global)
            ? ProxyMode.global
            : null;
  }

  set integratedProxyMode(ProxyMode? mode) {
    applyForeach((cat, profile, set) {
      if (profile != null) {
        set(profile.copyWith(mode: mode));
      }
    });
  }

  /// return null if their proxy mode are not identical.
  bool hasAnyProxyMode(ProxyMode mode) {
    return http?.mode == mode || https?.mode == mode || all?.mode == mode;
  }

  late final $profileOf = box.providerFamily<ProxyProfile, ProxyCat>(
    _ProxyK.keyOf,
    get: getProfileOf,
    set: setProfileOf,
  );

  late final profilesListenable = box.listenable(
    keys: ProxyCat.values.map((cat) => _ProxyK.keyOf(cat)).toList(),
  );

  late final $anyEnabled = profilesListenable.provider<bool>(
    get: () => anyEnabled,
    set: (newV) => anyEnabled = newV,
  );
  late final $integratedProxyMode = profilesListenable.provider<ProxyMode?>(
    get: () => integratedProxyMode,
    set: (newV) => integratedProxyMode = newV,
  );
}

class _AgreementsK {
  static const ns = "/agreements";

  static String acceptanceKeyOf(AgreementsType type) => "$ns/acceptance/${type.name}";
}

class _Agreements {
  final Box box;

  _Agreements(this.box);

  bool? getAgreementsAcceptanceOf(AgreementsType type) => box.safeGet<bool>(_AgreementsK.acceptanceKeyOf(type));

  Future<void> setAgreementsAcceptanceOf(AgreementsType type, bool? newV) async =>
      await box.safePut<bool>(_AgreementsK.acceptanceKeyOf(type), newV);

  late final $AgreementsAcceptanceOf = box.providerFamily<bool, AgreementsType>(
    _AgreementsK.acceptanceKeyOf,
    get: getAgreementsAcceptanceOf,
    set: setAgreementsAcceptanceOf,
  );
}
