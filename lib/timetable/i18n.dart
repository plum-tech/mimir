import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "timetable";
  final mine = const _Mine();
  final detail = const _Detail();
  final import = const _Import();
  final edit = const _Edit();
  final freeTip = const _FreeTip();
  final campus = const CampusI10n();

  String get navigation => "$ns.navigation".tr();

  String weekday({required int index}) => "weekday.$index".tr();

  String weekdayShort({required int index}) => "weekdayShort.$index".tr();

  String weekOrderedName({required int number}) => "$ns.weekOrderedName".tr(args: [number.toString()]);

  String get startWith => "$ns.startWith".tr();

  String get jump => "$ns.jump".tr();

  String get findToday => "$ns.findToday".tr();
}

class _Mine {
  const _Mine();

  static const ns = "${_I18n.ns}.mine";

  String get title => "$ns.title".tr();

  String get edit => "$ns.edit".tr();

  String get exportFile => "$ns.exportFile".tr();

  String get exportCalender => "$ns.exportCalender".tr();

  String get delete => "$ns.delete".tr();

  String get preview => "$ns.preview".tr();

  String get deleteRequest => "$ns.deleteRequest".tr();

  String get deleteRequestDesc => "$ns.deleteRequestDesc".tr();

  String get emptyTip => "$ns.emptyTip".tr();

  String get setToDefault => "$ns.setToDefault".tr();
}

class _Detail {
  const _Detail();

  static const ns = "${_I18n.ns}.detail";

  String get nameFormTitle => "$ns.nameFormTitle".tr();

  String get descFormTitle => "$ns.descFormTitle".tr();

  String classId(String code) => "$ns.classId".tr(args: [code]);

  String courseId(String code) => "$ns.courseId".tr(args: [code]);
}

class _Import {
  const _Import();

  static const ns = "${_I18n.ns}.import";

  String get title => "$ns.title".tr();

  String get connectivityCheckerDesc => "$ns.connectivityCheckerDesc".tr();

  String get selectSemesterTip => "$ns.selectSemesterTip".tr();

  String get endTip => "$ns.endTip".tr();

  String get failed => "$ns.failed".tr();

  String get failedDesc => "$ns.failedDesc".tr();

  String get failedTip => "$ns.failedTip".tr();

  String get button => "$ns.button".tr();

  String get importing => "$ns.importing".tr();

  String get timetableInfo => "$ns.timetableInfo".tr();

  String defaultName(
    String semester,
    String yearStart,
    String yearEnd,
  ) =>
      "$ns.defaultName".tr(namedArgs: {
        "semester": semester,
        "yearStart": yearStart,
        "yearEnd": yearEnd,
      });
}

class _Edit {
  const _Edit();

  static const ns = "${_I18n.ns}.edit";
}

class _FreeTip {
  const _FreeTip();

  static const ns = "${_I18n.ns}.freeTip";

  String get dayTip => "$ns.dayTip".tr();

  String get isTodayTip => "$ns.isTodayTip".tr();

  String get weekTip => "$ns.weekTip".tr();

  String get isThisWeekTip => "$ns.isThisWeekTip".tr();

  String get termTip => "$ns.termTip".tr();

  String get findNearestWeekWithClass => "$ns.findNearestWeekWithClass".tr();

  String get findNearestDayWithClass => "$ns.findNearestDayWithClass".tr();
}
