import 'package:easy_localization/easy_localization.dart';

mixin CommonI18nMixin {
  String get open => "open".tr();

  String get confirm => "confirm".tr();

  String get notNow => "notNow".tr();

  String get error => "error".tr();

  String get ok => "ok".tr();

  String get close => "close".tr();

  String get submit => "submit".tr();

  String get cancel => "cancel".tr();

  String get back => "back".tr();

  String get continue$ => "continue".tr();

  String get unknown => "unknown".tr();

  String get failed => "failed".tr();

  String get download => "download".tr();

  String get fetching => "fetching".tr();
}

class NetworkI18n {
  const NetworkI18n();

  static const ns = "network";

  String get error => "$ns.error".tr();

  String get ipAddress => "$ns.ipAddress".tr();

  String get connectionTimeoutError => "$ns.connectionTimeoutError".tr();

  String get connectionTimeoutErrorDesc => "$ns.connectionTimeoutErrorDesc".tr();

  String get openToolBtn => "$ns.openToolBtn".tr();

  String get noAccessTip => "$ns.noAccessTip".tr();
}

class UnitI18n {
  const UnitI18n();

  static const ns = "unit";

  String rmb(String amount) => "$ns.rmb".tr(args: [amount]);

  String powerKwh(String amount) => "$ns.powerKwh".tr(args: [amount]);
}
