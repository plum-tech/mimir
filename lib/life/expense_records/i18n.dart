import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "expenseRecords";
  final unit = const UnitI18n();
  final stats = const _Stats();
  final view = const _View();

  String get title => "$ns.title".tr();

  String get updateSuccessTip => "$ns.updateSuccessTip".tr();

  String get updateFailedTip => "$ns.updateFailedTip".tr();

  String get check => "$ns.check".tr();

  String get statistics => "$ns.statistics".tr();

  String balanceInCard(String amount) => "$ns.balanceInCard".tr(args: [amount]);

  String lastTransaction(String amount, String place) => "$ns.lastTransaction".tr(namedArgs: {
        "amount": amount,
        "place": place,
      });

  String income(String amount) => "$ns.income".tr(args: [amount]);

  String outcome(String amount) => "$ns.outcome".tr(args: [amount]);
}

class _Stats {
  const _Stats();

  static const ns = "${_I18n.ns}.stats";

  String get title => "$ns.title".tr();

  String get categories => "$ns.categories".tr();

  String get total => "$ns.total".tr();
}

class _View {
  const _View();

  static const ns = "${_I18n.ns}.view";

  String get balance => "$ns.balance".tr();

  String get rmb => "$ns.rmb".tr();
}
