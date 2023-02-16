import 'package:easy_localization/easy_localization.dart';

const _ns = "reportTemp";
const i18n = _I18n();

class _I18n /*with CommonI18nMixin */ {
  const _I18n();

  String get normal => "normal".tr();

  String get abnormal => "abnormal".tr();

  String get noReportRecords => "tempNoReportRecords".tr();

  String get reportedToday => "reportedToday".tr();

  String get unreportedToday => "unreportedToday".tr();
}
