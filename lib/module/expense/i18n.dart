import 'using.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "expense";
  final navigation = const _Navigation();
  final unit = const UnitI18n();

  String balanceInCard(String amount) => "$ns.balanceInCard".tr(args: [amount]);

  String get categories => "$ns.categories".tr();

  String lastTransaction(String amount, String place) => "$ns.lastTransaction".tr(namedArgs: {
        "amount": amount,
        "place": place,
      });

  String get fetchingRecordTip => "$ns.fetchingRecordTip".tr();

  String get fetchingTip => "$ns.fetchingTip".tr();

  String incomeStatistics(String amount) => "$ns.incomeStatistics".tr(args: [amount]);

  String spentStatistics(String amount) => "$ns.spentStatistics".tr(args: [amount]);

  String get refreshMenuButton => "$ns.refreshMenuButton".tr();

  String get statistics => "$ns.statistics".tr();

  String get toastLoadFailed => "$ns.toastLoadFailed".tr();

  String get toastLoadSuccessful => "$ns.toastLoadSuccessful".tr();

  String get toastLoading => "$ns.toastLoading".tr();

  String get total => "$ns.total".tr();
}

class _Navigation {
  const _Navigation();

  static const ns = "${_I18n.ns}.navigation";

  String get bill => "$ns.bill".tr();

  String get statistics => "$ns.statistics".tr();
}
