import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:ical/serializer.dart';
import 'package:open_file/open_file.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/files.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sanitize_filename/sanitize_filename.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_platform/universal_platform.dart';
import 'entity/timetable.dart';

import 'entity/course.dart';
import 'dart:math';

import 'init.dart';

import 'page/export.dart';

const maxWeekLength = 20;

final Map<String, int> _weekday2Index = {
  '星期一': 1,
  '星期二': 2,
  '星期三': 3,
  '星期四': 4,
  '星期五': 5,
  '星期六': 6,
  '星期日': 7,
};

extension StringEx on String {
  String removeSuffix(String suffix) => endsWith(suffix) ? substring(0, length - suffix.length) : this;

  String removePrefix(String prefix) => startsWith(prefix) ? substring(prefix.length) : this;
}

/// Then the [weekText] could be `1-5周,14周,8-10周(单)`
/// The return value should be
/// ```dart
/// TimetableWeekIndices([
///  WeekIndexType(
///    type: WeekIndexType.all,
///    range: (start: 0, end: 4),
///  ),
///  WeekIndexType(
///    type: WeekIndexType.single,
///    range: (start: 13, end: 13),
///  ),
///  WeekIndexType(
///    type: WeekIndexType.odd,
///    range: (start: 7, end: 9),
///  ),
/// ])
/// ```
TimetableWeekIndices _parseWeekText2RangedNumbers(String weekText) {
  final weeks = weekText.split(',');
// Then the weeks should be ["1-5周","14周","8-10周(单)"]
  final indices = <TimetableWeekIndex>[];
  for (final week in weeks) {
    // odd week
    if (week.endsWith("(单)")) {
      final rangeText = week.removeSuffix("周(单)");
      final range = rangeFromString(rangeText, number2index: true);
      indices.add(TimetableWeekIndex(
        type: TimetableWeekIndexType.odd,
        range: range,
      ));
    } else if (week.endsWith("(双)")) {
      final rangeText = week.removeSuffix("周(双)");
      final range = rangeFromString(rangeText, number2index: true);
      indices.add(TimetableWeekIndex(
        type: TimetableWeekIndexType.even,
        range: range,
      ));
    } else {
      final numberText = week.removeSuffix("周");
      final range = rangeFromString(numberText, number2index: true);
      indices.add(TimetableWeekIndex(
        type: TimetableWeekIndexType.all,
        range: range,
      ));
    }
  }
  return TimetableWeekIndices(indices);
}

SitTimetable parseTimetable(List<CourseRaw> all) {
  final List<SitCourse> courseKey2Entity = [];
  var counter = 0;
  for (final raw in all) {
    final courseKey = counter++;
    final weekIndices = _parseWeekText2RangedNumbers(raw.weekText);
    final dayLiteral = _weekday2Index[raw.weekDayText];
    assert(dayLiteral != null, "It's no corresponding dayIndex of ${raw.weekDayText}");
    if (dayLiteral == null) continue;
    final dayIndex = dayLiteral - 1;
    assert(0 <= dayIndex && dayIndex < 7, "dayIndex is out of range [0,6] but $dayIndex");
    if (!(0 <= dayIndex && dayIndex < 7)) continue;
    final timeslots = rangeFromString(raw.timeslotsText, number2index: true);
    assert(timeslots.start <= timeslots.end, "${timeslots.start} > ${timeslots.end} actually. ${raw.courseName}");
    final course = SitCourse(
      courseKey: courseKey,
      courseName: mapChinesePunctuations(raw.courseName).trim(),
      courseCode: raw.courseCode.trim(),
      classCode: raw.classCode.trim(),
      campus: raw.campus,
      place: reformatPlace(mapChinesePunctuations(raw.place)),
      iconName: CourseCategory.query(raw.courseName),
      weekIndices: weekIndices,
      timeslots: timeslots,
      courseCredit: double.tryParse(raw.courseCredit) ?? 0.0,
      creditHour: int.tryParse(raw.creditHour) ?? 0,
      dayIndex: dayIndex,
      teachers: raw.teachers.split(","),
    );
    courseKey2Entity.add(course);
  }
  final res = SitTimetable(
    courseKey2Entity: courseKey2Entity,
    courseKeyCounter: counter,
    name: "",
    startDate: DateTime.utc(0),
    schoolYear: 0,
    semester: Semester.term1,
  );
  return res;
}

SitTimetableEntity resolveTimetableEntity(SitTimetable timetable) {
  final weeks = List.generate(20, (index) => SitTimetableWeek.$7days(index));

  for (var courseKey = 0; courseKey < timetable.courseKey2Entity.length; courseKey++) {
    final course = timetable.courseKey2Entity[courseKey];
    final timeslots = course.timeslots;
    for (final weekIndex in course.weekIndices.getWeekIndices()) {
      assert(0 <= weekIndex && weekIndex < maxWeekLength,
          "Week index is more out of range [0,$maxWeekLength) but $weekIndex.");
      if (0 <= weekIndex && weekIndex < maxWeekLength) {
        final week = weeks[weekIndex];
        final day = week.days[course.dayIndex];
        final thatDay = reflectWeekDayIndexToDate(
          weekIndex: week.index,
          dayIndex: day.index,
          startDate: timetable.startDate,
        );
        final fullClassTime = course.calcBeginEndTimePoint();
        final lesson = SitTimetableLesson(
          course: course,
          startIndex: timeslots.start,
          endIndex: timeslots.end,
          startTime: thatDay.addTimePoint(fullClassTime.begin),
          endTime: thatDay.addTimePoint(fullClassTime.end),
        );
        for (int slot = timeslots.start; slot <= timeslots.end; slot++) {
          final classTime = course.calcBeginEndTimePointOfLesson(slot);
          day.add(
            SitTimetableLessonPart(
              type: lesson,
              index: slot,
              startTime: thatDay.addTimePoint(classTime.begin),
              endTime: thatDay.addTimePoint(classTime.end),
            ),
            at: slot,
          );
        }
      }
    }
  }
  return SitTimetableEntity(
    type: timetable,
    weeks: weeks,
  );
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

Future<void> exportTimetableFileAndShare(
  SitTimetable timetable, {
  required BuildContext context,
}) async {
  final content = jsonEncode(timetable.toJson());
  final fileName = sanitizeFilename("${timetable.name}.timetable", replacement: "-");
  final timetableFi = Files.temp.subFile(fileName);
  final sharePositionOrigin = context.getSharePositionOrigin();
  await timetableFi.writeAsString(content);
  await Share.shareXFiles(
    [XFile(timetableFi.path)],
    sharePositionOrigin: sharePositionOrigin,
  );
}

Future<void> exportTimetableAsICalendarAndOpen(
  BuildContext context, {
  required SitTimetableEntity timetable,
  required TimetableExportCalendarConfig config,
}) async {
  final name = "${timetable.type.name}, ${context.formatYmdNum(timetable.type.startDate)}";
  final fileName = sanitizeFilename(
    UniversalPlatform.isAndroid ? "$name #${DateTime.now().millisecondsSinceEpoch ~/ 1000}.ics" : "$name.ics",
    replacement: "-",
  );
  final calendarFi = Files.timetable.calendarDir.subFile(fileName);
  final data = convertTimetable2ICal(timetable: timetable, config: config);
  await calendarFi.writeAsString(data);
  await OpenFile.open(calendarFi.path, type: "text/calendar");
}

String convertTimetable2ICal({
  required SitTimetableEntity timetable,
  required TimetableExportCalendarConfig config,
}) {
  final calendar = ICalendar(
    company: 'mysit.life',
    product: 'SIT Life',
    lang: config.locale?.toLanguageTag() ?? "EN",
  );
  final alarm = config.alarm;
  final merged = config.isLessonMerged;
  for (final week in timetable.weeks) {
    for (final day in week.days) {
      for (final lessonSlot in day.timeslot2LessonSlot) {
        for (final part in lessonSlot.lessons) {
          final course = part.course;
          final teachers = course.teachers.join(', ');
          final lesson = part.type;
          final startTime = (merged ? lesson.startTime : part.startTime).toUtc();
          final endTime = (merged ? lesson.endTime : part.endTime).toUtc();
          final uid = merged
              ? "${R.appId}.${course.courseCode}.${week.index}.${day.index}.${lesson.startIndex}-${lesson.endIndex}"
              : "${R.appId}.${course.courseCode}.${week.index}.${day.index}.${part.index}";
          // Use UTC
          final event = IEvent(
            uid: uid,
            summary: course.courseName,
            location: course.place,
            description: teachers,
            start: startTime,
            end: endTime,
            // DON'T USE duration, that is broken on iOS.
            // duration: part.calcuClassDuration().toDuration(),
            alarm: alarm == null
                ? null
                : alarm.isSoundAlarm
                    ? IAlarm.audio(
                        trigger: startTime.subtract(alarm.alarmBeforeClass).toUtc(),
                        duration: alarm.alarmDuration,
                      )
                    : IAlarm.display(
                        trigger: startTime.subtract(alarm.alarmBeforeClass).toUtc(),
                        description: "${course.courseName} ${course.place} $teachers",
                        duration: alarm.alarmDuration,
                      ),
          );
          calendar.addElement(event);
          if (merged) {
            // skip the `lessonParts` loop
            break;
          }
        }
      }
    }
  }
  return calendar.serialize();
}
