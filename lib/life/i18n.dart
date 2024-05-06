import 'package:easy_localization/easy_localization.dart';
import 'package:sit/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  final settings = const _Settings();

  static const ns = "life";

  String get navigation => "$ns.navigation".tr();
}

class _Settings {
  const _Settings();

  final electricity = const _Electricity();
  final expense = const _Expense();
  static const ns = "${_I18n.ns}.settings";
}

class _Electricity {
  static const ns = "${_Settings.ns}.electricity";

  const _Electricity();

  String get autoRefresh => "$ns.autoRefresh.title".tr();

  String get autoRefreshDesc => "$ns.autoRefresh.desc".tr();
}

class _Expense {
  static const ns = "${_Settings.ns}.expenseRecords";

  const _Expense();

  String get autoRefresh => "$ns.autoRefresh.title".tr();

  String get autoRefreshDesc => "$ns.autoRefresh.desc".tr();
}
