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
}

class NetworkI18n {
  const NetworkI18n();

  static const _ns = "network";

  String get error => "$_ns.error".tr();

  String get connectionTimeoutError => "$_ns.connectionTimeoutError".tr();

  String get connectionTimeoutErrorDesc => "$_ns.connectionTimeoutErrorDesc".tr();

  String get openToolBtn => "$_ns.openToolBtn".tr();

  String get noAccessTip => "$_ns.noAccessTip".tr();
}
