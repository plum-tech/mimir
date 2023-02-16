import 'using.dart';

const i18n = _I18n();

class _I18n /* with CommonI18nMixin*/ {
  const _I18n();

  static const ns = "examArr";

  String get startTime => "$ns.startTime".tr();

  String get endTime => "$ns.endTime".tr();

  String get isRetake => "$ns.isRetake".tr();

  String get location => "$ns.location".tr();

  String get noExamThisSemester => "$ns.noExamThisSemester".tr();

  String get resultBePatientLabel => "$ns.resultBePatientLabel".tr();

  String get resultNoResult => "$ns.resultNoResult".tr();

  String get seatNumber => "$ns.seatNumber".tr();
}
