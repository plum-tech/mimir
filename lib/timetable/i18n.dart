import 'package:easy_localization/easy_localization.dart';
import 'package:sit/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "timetable";
  final time = const TimeI18n();
  final mine = const _Mine();
  final details = const _Details();
  final import = const _Import();
  final export = const _Export();
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

  String get exportCalendar => "$ns.exportCalendar".tr();

  String get add2Calendar => "$ns.add2Calendar".tr();

  String get use => "$ns.use".tr();

  String get used => "$ns.used".tr();

  String get delete => "$ns.delete".tr();

  String get preview => "$ns.preview".tr();

  String get deleteRequest => "$ns.deleteRequest".tr();

  String get deleteRequestDesc => "$ns.deleteRequestDesc".tr();

  String get emptyTip => "$ns.emptyTip".tr();
}

class _Details {
  const _Details();

  static const ns = "${_I18n.ns}.details";

  String get nameFormTitle => "$ns.nameFormTitle".tr();

  String get descFormTitle => "$ns.descFormTitle".tr();

  String get classId => "$ns.classId".tr();

  String get courseId => "$ns.courseId".tr();
}

class _Import {
  const _Import();

  static const ns = "${_I18n.ns}.import";

  String get title => "$ns.title".tr();

  String get import => "$ns.import".tr();

  String get fromFile => "$ns.fromFile".tr();

  String get fromFileBtn => "$ns.fromFileBtn".tr();

  String get connectivityCheckerDesc => "$ns.connectivityCheckerDesc".tr();

  String get selectSemesterTip => "$ns.selectSemesterTip".tr();

  String get endTip => "$ns.endTip".tr();

  String get failed => "$ns.failed".tr();

  String get failedDesc => "$ns.failedDesc".tr();

  String get failedTip => "$ns.failedTip".tr();

  String get tryImportBtn => "$ns.tryImportBtn".tr();

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

class _Export {
  const _Export();

  static const ns = "${_I18n.ns}.export";

  String get title => "$ns.title".tr();

  String get export => "$ns.export".tr();

  String get lessonMode => "$ns.lessonMode.title".tr();

  String get lessonModeDesc => "$ns.lessonMode.desc".tr();

  String get lessonModeMerged => "$ns.lessonMode.merged.name".tr();

  String get lessonModeMergedInfo => "$ns.lessonMode.merged.info".tr();

  String get lessonModeSeparate => "$ns.lessonMode.separate.name".tr();

  String get lessonModeSeparateInfo => "$ns.lessonMode.separate.info".tr();

  String get enableAlarm => "$ns.enableAlarm.title".tr();

  String get enableAlarmDesc => "$ns.enableAlarm.desc".tr();

  String get alarmMode => "$ns.alarmMode.title".tr();

  String get alarmModeDesc => "$ns.alarmMode.desc".tr();

  String get alarmModeSound => "$ns.alarmMode.sound".tr();

  String get alarmModeDisplay => "$ns.alarmMode.display".tr();

  String get alarmDuration => "$ns.alarmDuration".tr();

  String get alarmBeforeClassBegins => "$ns.alarmBeforeClassBegins.title".tr();

  String alarmBeforeClassBeginsDesc(Duration duration) => "$ns.alarmBeforeClassBegins.desc".tr(namedArgs: {
        "duration": i18n.time.minuteFormat(duration.inMinutes.toString()),
      });
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
