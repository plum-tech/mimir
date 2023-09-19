import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mimir/credential/i18n.dart';
import 'package:mimir/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  final credential = const CredentialI18n();
  final campus = const _Campus();
  final studentId = const _StudentId();
  final changeOaPwd = const _ChangeOaPwd();
  final clearCache = const _ClearCache();
  final themeMode = const _ThemeMode();
  final httpProxy = const _HttpProxy();
  final language = const _Language();
  final dev = const _DevOptions();
  final timetable = const _Timetable();
  final testConnect2School = const _TestConnect2School();
  final wipeData = const _WipeData();
  static const ns = "settings";

  String get title => "$ns.title".tr();

  String get version => "$ns.version".tr();
}

class _Campus extends CampusI10n {
  const _Campus();

  static const ns = "${_I18n.ns}.campus";

  String get title => "$ns.title".tr();

  String get desc => "$ns.desc".tr();
}

class _StudentId {
  const _StudentId();

  static const ns = "${_I18n.ns}.studentId";

  String get studentIdCopy2ClipboardTip => "$ns.studentIdCopy2ClipboardTip".tr();
}

class _ChangeOaPwd {
  const _ChangeOaPwd();

  static const ns = "${_I18n.ns}.changeOaPwd";

  String get title => "$ns.title".tr();

  String get desc => "$ns.desc".tr();
}

class _ClearCache {
  const _ClearCache();

  static const ns = "${_I18n.ns}.clearCache";

  String get title => "$ns.title".tr();

  String get desc => "$ns.desc".tr();

  String get request => "$ns.request".tr();
}

class _ThemeMode {
  const _ThemeMode();

  static const ns = "${_I18n.ns}.themeMode";

  String get title => "$ns.title".tr();

  String get dark => "$ns.dark".tr();

  String get light => "$ns.light".tr();

  String get system => "$ns.system".tr();

  String of(ThemeMode mode) {
    return "$ns.${mode.name}".tr();
  }
}

class _HttpProxy {
  const _HttpProxy();

  static const ns = "${_I18n.ns}.httpProxy";

  String get title => "$ns.title".tr();

  String get desc => "$ns.desc".tr();

  String get global => "$ns.global".tr();

  String get globalDesc => "$ns.globalDesc".tr();

  String get proxyAddress => "$ns.proxyAddress".tr();
}

class _Language {
  const _Language();

  static const ns = "${_I18n.ns}.language";

  String get title => "$ns.title".tr();

  String languageOf(Locale locale) => "language.$locale".tr();
}

class _Timetable {
  const _Timetable();

  static const ns = "${_I18n.ns}.timetable";

  String get title => "$ns.title".tr();

  String get autoUseImportedTitle => "$ns.autoUseImported.title".tr();

  String get autoUseImportedDesc => "$ns.autoUseImported.desc".tr();
}

class _DevOptions {
  const _DevOptions();

  final storage = const _Storage();

  static const ns = "${_I18n.ns}.dev";

  String get title => "$ns.title".tr();

  String get devMode => "$ns.devMode.title".tr();

  String get reloadTitle => "$ns.reload.title".tr();

  String get reloadDesc => "$ns.reload.desc".tr();

  String get localStorageTitle => "$ns.localStorage.title".tr();

  String get localStorageDesc => "$ns.localStorage.desc".tr();

  String get detailedXcpDialogTitle => "$ns.detailedXcpDialog.title".tr();

  String get detailedXcpDialogDesc => "$ns.detailedXcpDialog.desc".tr();
}

class _TestConnect2School {
  const _TestConnect2School();

  static const ns = "${_I18n.ns}.testConnect2School";

  String get title => "$ns.title".tr();

  String get desc => "$ns.desc".tr();
}

class _WipeData {
  const _WipeData();

  static const ns = "${_I18n.ns}.wipeData";

  String get title => "$ns.title".tr();

  String get desc => "$ns.desc".tr();

  String get request => "$ns.request".tr();

  String get requestDesc => "$ns.requestDesc".tr();
}

class _Storage with CommonI18nMixin {
  const _Storage();

  static const ns = "${_DevOptions.ns}.localStorage";

  String get title => "$ns.title".tr();

  String get selectBoxTip => "$ns.selectBoxTip".tr();

  String get clearBoxDesc => "$ns.clearBoxDesc".tr();

  String get deleteItemDesc => "$ns.deleteItemDesc".tr();

  String get emptyValueDesc => "$ns.emptyValueDesc".tr();
}
