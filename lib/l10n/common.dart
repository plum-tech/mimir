import 'package:easy_localization/easy_localization.dart';

mixin CommonI18nMixin {
  String get open => "open".tr();

  String get delete => "delete".tr();

  String get confirm => "confirm".tr();

  String get notNow => "notNow".tr();

  String get error => "error".tr();

  String get ok => "ok".tr();

  String get yes => "yes".tr();

  String get refresh => "refresh".tr();

  String get close => "close".tr();

  String get submit => "submit".tr();

  String get cancel => "cancel".tr();

  String get back => "back".tr();

  String get clear => "clear".tr();

  String get save => "save".tr();

  String get continue$ => "continue".tr();

  String get unknown => "unknown".tr();

  String get failed => "failed".tr();

  String get download => "download".tr();

  String get fetching => "fetching".tr();

  String get downloading => "downloading".tr();

  String get author => "author".tr();

  String get warning => "warning".tr();

  String get exceptionInfo => "exceptionInfo".tr();

  String get untitled => "untitled".tr();

  String get congratulations => "congratulations".tr();

  String get search => "search".tr();
}

class CommonI18n with CommonI18nMixin {
  const CommonI18n();
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

  String get untitled => "$ns.untitled".tr();
}

class UnitI18n {
  const UnitI18n();

  static const ns = "unit";

  String rmb(String amount) => "$ns.rmb".tr(args: [amount]);

  String powerKwh(String amount) => "$ns.powerKwh".tr(args: [amount]);
}

class TimeI18n {
  const TimeI18n();

  static const ns = "time";

  String get minute => "$ns.minute".tr();

  String get hour => "$ns.hour".tr();

  String hourMinuteFormat(String hour, String minute) => "$ns.hourMinuteFormat".tr(namedArgs: {
        "hour": hour,
        "minute": minute,
      });

  String hourFormat(String hour) => "$ns.hourFormat".tr(args: [hour]);

  String minuteFormat(String minute) => "$ns.minuteFormat".tr(args: [minute]);
}

class CampusI10n {
  const CampusI10n();

  static const ns = "campus";

  String get xuhui => "$ns.xuhui".tr();

  String get xuhuiDistrict => "$ns.xuhuiDistrict".tr();

  String get fengxian => "$ns.fengxian".tr();

  String get fengxianDistrict => "$ns.fengxianDistrict".tr();
}
