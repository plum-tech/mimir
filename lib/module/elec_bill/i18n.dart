import 'using.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "elecBill";
  final navigation = const _Navigation();
  final unit = const UnitI18n();

  String title(String room) => "$ns.title".tr(
        namedArgs: {
          "room": room,
        },
      );

  String get balance => "$ns.balance".tr();

  String content(String balance, String room) => "$ns.content".tr(
        namedArgs: {
          "balance": balance,
          "room": room,
        },
      );

  String get initialTip => "$ns.initialTip".tr();

  String get remainingPower => "$ns.remainingPower".tr();

  String get roomNumber => "$ns.roomNumber".tr();

  String get updateTime => "$ns.updateTime".tr();
}

class _Navigation {
  const _Navigation();

  static const ns = "${_I18n.ns}.navigation";

  String get bill => "$ns.bill".tr();

  String get search => "$ns.search".tr();
}
