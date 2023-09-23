import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "examArrange";

  String get title => "$ns.title".tr();

  String get check => "$ns.check".tr();

  String get date => "$ns.date".tr();

  String get time => "$ns.time".tr();

  String get retake => "$ns.retake".tr();

  String get location => "$ns.location".tr();

  String get noExamsTip => "$ns.noExamsTip".tr();

  String get seatNumber => "$ns.seatNumber".tr();
}
