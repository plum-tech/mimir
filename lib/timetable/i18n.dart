import 'package:easy_localization/easy_localization.dart';
import 'package:sit/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "timetable";
  final time = const TimeI18n();
  final mine = const _Mine();
  final p13n = const _P13n();
  final details = const _Details();
  final import = const _Import();
  final export = const _Export();
  final screenshot = const _Screenshot();
  final editor = const _Editor();
  final freeTip = const _FreeTip();
  final campus = const CampusI10n();

  String get navigation => "$ns.navigation".tr();

  String weekOrderedName({required int number}) => "$ns.weekOrderedName".tr(args: [number.toString()]);

  String get startWith => "$ns.startWith".tr();

  String get jump => "$ns.jump".tr();

  String get findToday => "$ns.findToday".tr();

  String get focusTimetable => "$ns.focusTimetable".tr();

  String get signature => "$ns.signature".tr();

  String get signaturePlaceholder => "$ns.signaturePlaceholder".tr();
}

class _Mine {
  const _Mine();

  static const ns = "${_I18n.ns}.mine";

  String get title => "$ns.title".tr();

  String get exportFile => "$ns.exportFile".tr();

  String get exportCalendar => "$ns.exportCalendar".tr();

  String get add2Calendar => "$ns.add2Calendar".tr();

  String get deleteRequest => "$ns.deleteRequest".tr();

  String get deleteRequestDesc => "$ns.deleteRequestDesc".tr();

  String get emptyTip => "$ns.emptyTip".tr();

  String get details => "$ns.details".tr();
}

class _P13n {
  const _P13n();

  static const ns = "${_I18n.ns}.p13n";
  final cell = const _CellStyle();
  final palette = const _Palette();
  final background = const _Background();

  String get title => "$ns.title".tr();

  ({String name, String place, List<String> teachers}) livePreview(int index) {
    return (
      name: "$ns.livePreview.$index.name".tr(),
      place: "$ns.livePreview.$index.place".tr(),
      teachers: "$ns.livePreview.$index.teachers".tr().split(","),
    );
  }
}

class _CellStyle {
  const _CellStyle();

  static const ns = "${_P13n.ns}.cellStyle";

  String get title => "$ns.title".tr();

  String get entrance => "$ns.entrance.title".tr();

  String get entranceDesc => "$ns.entrance.desc".tr();

  String get showTeachers => "$ns.showTeachers.title".tr();

  String get showTeachersDesc => "$ns.showTeachers.desc".tr();

  String get grayOut => "$ns.grayOut.title".tr();

  String get grayOutDesc => "$ns.grayOut.desc".tr();

  String get harmonize => "$ns.harmonize.title".tr();

  String get harmonizeDesc => "$ns.harmonize.desc".tr();

  String get alpha => "$ns.alpha".tr();
}

class _Palette {
  const _Palette();

  static const ns = "${_P13n.ns}.palette";

  String get title => "$ns.title".tr();

  String get fab => "$ns.fab".tr();

  String get customTab => "$ns.tab.custom".tr();

  String get builtinTab => "$ns.tab.builtin".tr();

  String get infoTab => "$ns.tab.info".tr();

  String get colorsTab => "$ns.tab.colors".tr();

  String get shareQrCode => "$ns.shareQrCode".tr();

  String get newPaletteName => "$ns.newPaletteName".tr();

  String copyPaletteName(String old) => "$ns.copyPaletteName".tr(args: [old]);

  String get deleteRequest => "$ns.deleteRequest".tr();

  String get deleteRequestDesc => "$ns.deleteRequestDesc".tr();

  String get addFromQrCode => "$ns.addFromQrCode".tr();

  String get addColor => "$ns.addColor".tr();

  String get name => "$ns.name".tr();

  String get namePlaceholder => "$ns.namePlaceholder".tr();

  String get author => "$ns.author".tr();

  String get authorPlaceholder => "$ns.authorPlaceholder".tr();

  String get color => "$ns.color".tr();

  String get details => "$ns.details".tr();
}

class _Background {
  const _Background();

  static const ns = "${_P13n.ns}.background";

  String get title => "$ns.title".tr();

  String get pickTip => "$ns.pickTip".tr();

  String get opacity => "$ns.opacity".tr();

  String get repeat => "$ns.repeat.title".tr();

  String get repeatDesc => "$ns.repeat.desc".tr();

  String get antialias => "$ns.antialias.title".tr();

  String get antialiasDesc => "$ns.antialias.desc".tr();
}

class _Details {
  const _Details();

  static const ns = "${_I18n.ns}.details";

  String get classCode => "$ns.classCode".tr();

  String get courseCode => "$ns.courseCode".tr();

  String get teacher => "$ns.teacher".tr();
}

class _Screenshot {
  const _Screenshot();

  static const ns = "${_I18n.ns}.screenshot";

  String get title => "$ns.title".tr();

  String get screenshot => "$ns.screenshot".tr();

  String get take => "$ns.take".tr();

  String get enableBackground => "$ns.enableBackground.title".tr();

  String get enableBackgroundDesc => "$ns.enableBackground.desc".tr();
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

class _Editor {
  const _Editor();

  static const ns = "${_I18n.ns}.edit";

  String get name => "$ns.name".tr();
}

class _Export {
  const _Export();

  static const ns = "${_I18n.ns}.export";

  String get title => "$ns.title".tr();

  String get export => "$ns.export".tr();

  String get lessonMode => "$ns.lessonMode.title".tr();

  String get lessonModeMerged => "$ns.lessonMode.merged".tr();

  String get lessonModeMergedTip => "$ns.lessonMode.mergedTip".tr();

  String get lessonModeSeparate => "$ns.lessonMode.separate".tr();

  String get lessonModeSeparateTip => "$ns.lessonMode.separateTip".tr();

  String get enableAlarm => "$ns.enableAlarm.title".tr();

  String get enableAlarmDesc => "$ns.enableAlarm.desc".tr();

  String get alarmMode => "$ns.alarmMode.title".tr();

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
