import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ical/serializer.dart';
import 'package:mimir/r.dart';
import 'package:mimir/school/entity/school.dart';
import 'package:mimir/utils/file.dart';
import 'package:sanitize_filename/sanitize_filename.dart';
import 'package:share_plus/share_plus.dart';
import 'entity/timetable.dart';

import 'entity/course.dart';
import 'dart:math';

import 'init.dart';
import 'package:path/path.dart' show join;

const maxWeekLength = 20;

void _addEventForCourse(ICalendar cal, CourseRaw course, DateTime startDate, Duration? alarmBefore) {
  // final timetable = getTeacherBuildingTimetable(course.campus, course.place);
  // final indexStart = getIndexStart(course.timeIndex);
  // final indexEnd = getIndexEnd(indexStart, course.timeIndex);
  // final timeStart = timetable[indexStart - 1].begin;
  // final timeEnd = timetable[indexEnd - 1].end;
  //
  // final description =
  //     '第 ${indexStart == indexEnd ? indexStart : '$indexStart-$indexEnd'} 节，${course.place}，${course.teacher.join(' ')}';
  //
  // // 一学期最多有 20 周
  // for (int currentWeek = 1; currentWeek < 20; ++currentWeek) {
  //   // 本周没课, 跳过
  //   if ((1 << currentWeek) & course.weekIndex == 0) continue;
  //
  //   // 这里需要使用UTC时间
  //   // 实际测试得出，如果不使用UTC，有的手机会将其看作本地时间
  //   // 有的手机会将其看作UTC+0的时间从而导致实际显示时间与预期不一致
  //   final date = parseWeekDayNumberToDate(week: currentWeek, day: course.dayIndex, basedOn: startDate);
  //   final eventStartTime = date.add(Duration(hours: timeStart.hour, minutes: timeStart.minute));
  //   final eventEndTime = date.add(Duration(hours: timeEnd.hour, minutes: timeEnd.minute));
  //   final IEvent event = IEvent(
  //     // uid: 'SIT-${course.courseId}-${const Uuid().v1()}',
  //     summary: course.courseName,
  //     location: course.place,
  //     description: description,
  //     start: eventStartTime,
  //     end: eventEndTime,
  //     alarm: alarmBefore == null
  //         ? null
  //         : IAlarm.display(
  //             trigger: eventStartTime.subtract(alarmBefore),
  //             description: description,
  //           ),
  //   );
  //   cal.addElement(event);
  // }
}

///导出的方法
String convertTableToIcs(TimetableMeta meta, List<CourseRaw> courses, Duration? alarmBefore) {
  final ICalendar iCal = ICalendar(
    company: 'Liplum',
    product: 'Mímir',
    lang: 'ZH',
    refreshInterval: const Duration(days: 36500),
  );
  // 需要把
  final startDate = DateTime(meta.startDate.year, meta.startDate.month, meta.startDate.day);
  for (final course in courses) {
    _addEventForCourse(iCal, course, startDate, alarmBefore);
  }
  return iCal.serialize();
}

final timetableDateFormat = DateFormat('yyyyMMdd_hhmmss');

String getExportTimetableFilename() {
  return 'sit-timetable-${timetableDateFormat.format(DateTime.now())}.ics';
}

Future<void> exportTimetableToCalendar(TimetableMeta meta, List<CourseRaw> courses, Duration? alarmBefore) async {
  await FileUtils.writeToTempFileAndOpen(
    content: convertTableToIcs(meta, courses, alarmBefore),
    filename: getExportTimetableFilename(),
    type: 'text/calendar',
  );
}

final Map<String, int> _weekday2Index = {
  '星期一': 1,
  '星期二': 2,
  '星期三': 3,
  '星期四': 4,
  '星期五': 5,
  '星期六': 6,
  '星期日': 7,
};

enum WeekStep {
  single('s'),
  all('a'),
  odd('o'),
  even('e');

  final String indicator;

  const WeekStep(this.indicator);

  String l10n() => "timetable.weekStep.$name".tr();

  static WeekStep by(String indicator) {
    switch (indicator) {
      case 'o':
        return WeekStep.odd;
      case 'e':
        return WeekStep.even;
      case 'a':
        return WeekStep.all;
      default: // case 's':
        return WeekStep.single;
    }
  }
}

extension StringEx on String {
  String removeSuffix(String suffix) => endsWith(suffix) ? substring(0, length - suffix.length) : this;

  String removePrefix(String prefix) => startsWith(prefix) ? substring(prefix.length) : this;
}

/// Then the [weekText] could be `1-5周,14周,8-10周(单)`
/// The return value should be `a1-5,s14,o8-10`
List<String> _weekText2RangedNumbers(String weekText) {
  final weeks = weekText.split(',');
// Then the weeks should be ["1-5周","14周","8-10周(单)"]
  final res = <String>[];
  for (final week in weeks) {
    final isRange = week.contains("-");
    if (week.endsWith("(单)") && isRange) {
      final range = week.removeSuffix("周(单)");
      res.add('${WeekStep.odd.indicator}$range');
    } else if (week.endsWith("(双)") && isRange) {
      final range = week.removeSuffix("周(双)");
      res.add('${WeekStep.even.indicator}$range');
    } else {
      final number = week.removeSuffix("周");
      if (number.isNotEmpty) {
        if (number.contains("-")) {
          res.add("${WeekStep.all.indicator}$number");
        } else {
          res.add("${WeekStep.single.indicator}$number");
        }
      }
    }
  }
  return res;
}

SitTimetable parseTimetableEntity(List<CourseRaw> all) {
  final List<SitTimetableWeek?> weeks = List.generate(20, (index) => null);
  SitTimetableWeek getWeekAt(int index) {
    final week = weeks[index] ??= SitTimetableWeek.$7days();
    weeks[index] = week;
    return week;
  }

  final List<SitCourse> courseKey2Entity = [];
  var counter = 0;
  for (final raw in all) {
    final courseKey = counter++;
    final weekIndices = _weekText2RangedNumbers(raw.weekText);
    final dayLiteral = _weekday2Index[raw.weekDayText];
    assert(dayLiteral != null, "It's no corresponding dayIndex of ${raw.weekDayText}");
    if (dayLiteral == null) continue;
    final dayIndex = dayLiteral - 1;
    assert(0 <= dayIndex && dayIndex < 7, "dayIndex is out of range [0,6] but $dayIndex");
    if (!(0 <= dayIndex && dayIndex < 7)) continue;
    final course = SitCourse(
      courseKey,
      mapChinesePunctuations(raw.courseName).trim(),
      raw.courseCode.trim(),
      raw.classCode.trim(),
      raw.campus,
      mapChinesePunctuations(raw.place),
      CourseCategory.query(raw.courseName),
      weekIndices,
      raw.timeslotsText,
      double.tryParse(raw.courseCredit) ?? 0.0,
      int.tryParse(raw.creditHour) ?? 0,
      dayIndex,
      raw.teachers.split(","),
    );
    courseKey2Entity.add(course);

    for (final weekNumber in SitCourse.rangedWeekNumbers2EachWeekNumbers(weekIndices)) {
      final weekIndex = weekNumber - 1;
      assert(0 <= weekIndex && weekIndex < maxWeekLength,
          "Week index is more out of range [0,$maxWeekLength) but $weekIndex.");
      if (0 <= weekIndex && weekIndex < maxWeekLength) {
        final week = getWeekAt(weekIndex);
        final day = week.days[dayIndex];
        if (raw.timeslotsText.contains("-")) {
          // in range of time slots
          final range = raw.timeslotsText.split("-");
          final startIndex = int.parse(range[0]) - 1;
          final endIndex = int.parse(range[1]) - 1; // inclusive
          for (int slot = startIndex; slot <= endIndex; slot++) {
            day.add(SitTimetableLesson(startIndex, endIndex, courseKey), at: slot);
          }
        } else {
          final slot = int.parse(raw.timeslotsText) - 1;
          day.add(SitTimetableLesson(slot, slot, courseKey), at: slot);
        }
      }
    }
  }
  final res = SitTimetable(
    weeks: weeks,
    courseKey2Entity: courseKey2Entity,
    courseKeyCounter: counter,
    name: "",
    startDate: DateTime.utc(0),
    schoolYear: 0,
    semester: Semester.term1,
  );
  return res;
}

Duration calcuSwitchAnimationDuration(num distance) {
  final time = sqrt(max(1, distance) * 100000);
  return Duration(milliseconds: time.toInt());
}

Future<({int id, SitTimetable timetable})?> importTimetableFromFile() async {
  final result = await FilePicker.platform.pickFiles(
      // Cannot limit the extensions. My RedMi phone just reject all files.
      // type: FileType.custom,
      // allowedExtensions: const ["timetable", "json"],
      );
  if (result == null) return null;
  final path = result.files.single.path;
  if (path == null) return null;
  final file = File(path);
  final content = await file.readAsString();
  final json = jsonDecode(content);
  final timetable = SitTimetable.fromJson(json);
  final id = TimetableInit.storage.timetable.add(timetable);
  return (id: id, timetable: timetable);
}

Future<void> exportTimetableFileAndShare(SitTimetable timetable) async {
  final content = jsonEncode(timetable.toJson());
  final fileName = sanitizeFilename("${timetable.name}.timetable", replacement: "-");
  final timetableFi = File(join(R.tmpDir, fileName));
  await timetableFi.writeAsString(content);
  await Share.shareXFiles(
    [XFile(timetableFi.path)],
  );
}
