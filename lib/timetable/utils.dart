import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:ical/serializer.dart';
import 'package:open_file/open_file.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/entity/campus.dart';
import 'package:sit/files.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sanitize_filename/sanitize_filename.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sit/utils/strings.dart';
import 'package:universal_platform/universal_platform.dart';
import '../school/exam_result/entity/score.dart';
import 'entity/timetable.dart';

import 'entity/course.dart';
import 'dart:math';

import 'init.dart';

import 'page/export.dart';
import 'package:html/parser.dart';

const maxWeekLength = 20;

final Map<String, int> _weekday2Index = {
  '星期一': 0,
  '星期二': 1,
  '星期三': 2,
  '星期四': 3,
  '星期五': 4,
  '星期六': 5,
  '星期日': 6,
};

/// Then the [weekText] could be `1-5周,14周,8-10周(单)`
/// The return value should be
/// ```dart
/// TimetableWeekIndices([
///  TimetableWeekIndex.all(
///    (start: 0, end: 4)
///  ),
///  TimetableWeekIndex.single(
///    13,
///  ),
///  TimetableWeekIndex.odd(
///    (start: 7, end: 9),
///  ),
/// ])
/// ```
TimetableWeekIndices _parseWeekText2RangedNumbers(
  String weekText, {
  required String allSuffix,
  required String oddSuffix,
  required String evenSuffix,
}) {
  final weeks = weekText.split(',');
// Then the weeks should be ["1-5周","14周","8-10周(单)"]
  final indices = <TimetableWeekIndex>[];
  for (final week in weeks) {
    // odd week
    if (week.endsWith(oddSuffix)) {
      final rangeText = week.removeSuffix(oddSuffix);
      final range = rangeFromString(rangeText, number2index: true);
      indices.add(TimetableWeekIndex.odd(range));
    } else if (week.endsWith(evenSuffix)) {
      final rangeText = week.removeSuffix(evenSuffix);
      final range = rangeFromString(rangeText, number2index: true);
      indices.add(TimetableWeekIndex.even(range));
    } else if (week.endsWith(allSuffix)) {
      final numberText = week.removeSuffix(allSuffix);
      final range = rangeFromString(numberText, number2index: true);
      indices.add(TimetableWeekIndex.all(range));
    }
  }
  return TimetableWeekIndices(indices);
}

Campus _parseCampus(String campus) {
  if (campus.contains("徐汇")) {
    return Campus.xuhui;
  } else {
    return Campus.fengxian;
  }
}

SitTimetable parseUndergraduateTimetableFromCourseRaw(List<UndergraduateCourseRaw> all) {
  final List<SitCourse> courseKey2Entity = [];
  var counter = 0;
  for (final raw in all) {
    final courseKey = counter++;
    final weekIndices = _parseWeekText2RangedNumbers(
      mapChinesePunctuations(raw.weekText),
      allSuffix: "周",
      oddSuffix: "周(单)",
      evenSuffix: "周(双)",
    );
    final dayIndex = _weekday2Index[raw.weekDayText];
    assert(dayIndex != null && 0 <= dayIndex && dayIndex < 7, "dayIndex isn't in range [0,6] but $dayIndex");
    if (dayIndex == null || !(0 <= dayIndex && dayIndex < 7)) continue;
    final timeslots = rangeFromString(raw.timeslotsText, number2index: true);
    assert(timeslots.start <= timeslots.end, "${timeslots.start} > ${timeslots.end} actually. ${raw.courseName}");
    final course = SitCourse(
      courseKey: courseKey,
      courseName: mapChinesePunctuations(raw.courseName).trim(),
      courseCode: raw.courseCode.trim(),
      classCode: raw.classCode.trim(),
      campus: _parseCampus(raw.campus),
      place: reformatPlace(mapChinesePunctuations(raw.place)),
      weekIndices: weekIndices,
      timeslots: timeslots,
      courseCredit: double.tryParse(raw.courseCredit) ?? 0.0,
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
  var fileName = "${timetable.name}.timetable";
  if (timetable.signature.isNotEmpty) {
    fileName = "${timetable.signature} $fileName";
  }
  fileName = sanitizeFilename(fileName, replacement: "-");
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

List<PostgraduateCourseRaw> parsePostgraduateCourseRawsFromHtml(String timetableHtmlContent) {
  List<PostgraduateCourseRaw> courseList = [];
  const mapOfWeekday = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];

  void processNodes(List nodes, String weekday) {
    if (nodes.length < 5) {
      // 如果节点数量小于 5，不足以构成一个完整的 Course，忽略
      return;
    }

    final locationWithTeacherStr = mapChinesePunctuations(nodes[4].text);
    final locationWithTeacherList = locationWithTeacherStr.split("  ");
    final location = locationWithTeacherList[0];
    final teacher = locationWithTeacherList[1];

    var courseNameWithClassCode = mapChinesePunctuations(nodes[0].text);
    final String courseName;
    final String classCode;
    RegExpMatch? courseNameWithClassCodeMatch =
        RegExp(r"(.*?)(学硕\d+班|专硕\d+班|\d+班)$").firstMatch(courseNameWithClassCode);
    if (courseNameWithClassCodeMatch != null) {
      courseName = courseNameWithClassCodeMatch.group(1) ?? "";
      classCode = courseNameWithClassCodeMatch.group(2) ?? "";
    } else {
      courseName = courseNameWithClassCode;
      classCode = "";
    }

    var weekTextWithTimeslotsText = mapChinesePunctuations(nodes[2].text);
    final String weekText;
    final String timeslotsText;
    RegExpMatch? weekTextWithTimeslotsTextMatch =
        RegExp(r"([\d-]+周(\([^)]*\))?)([\d-]+节)").firstMatch(weekTextWithTimeslotsText);
    if (weekTextWithTimeslotsTextMatch != null) {
      weekText = weekTextWithTimeslotsTextMatch.group(1) ?? "";
      timeslotsText = weekTextWithTimeslotsTextMatch.group(3) ?? "";
    } else {
      weekText = "";
      timeslotsText = "";
    }

    final course = PostgraduateCourseRaw(
      courseName: courseName,
      weekDayText: weekday,
      weekText: weekText,
      timeslotsText: timeslotsText,
      teachers: teacher,
      place: location,
      classCode: classCode,
      courseCode: "",
      courseCredit: "",
      creditHour: "",
    );

    courseList.add(course);

    // 移除处理过的节点，继续处理剩余的节点
    nodes.removeRange(0, 7);

    if (nodes.isNotEmpty) {
      processNodes(nodes, weekday);
    }
  }

  final document = parse(timetableHtmlContent);
  final table = document.querySelector('table');
  final trList = table!.querySelectorAll('tr');
  for (var tr in trList) {
    final tdList = tr.querySelectorAll('td');
    for (var td in tdList) {
      if (td.innerHtml.contains("br")) {
        final index = tdList.indexOf(td);
        String weekday;
        if (tdList.length > 8) {
          weekday = mapOfWeekday[index - 2];
        } else {
          weekday = mapOfWeekday[index - 1];
        }
        final nodes = td.nodes;
        processNodes(nodes, weekday);
      }
    }
  }
  return courseList;
}

void completePostgraduateCourseRawsFromPostgraduateScoreRaws(
    List<PostgraduateCourseRaw> courseList, List<PostgraduateScoreRaw> scoreList) {
  var name2Score = <String, PostgraduateScoreRaw>{};

  for (var score in scoreList) {
    var key = score.courseName.replaceAll(" ", "");
    name2Score[key] = score;
  }

  for (var course in courseList) {
    var key = course.courseName.replaceAll(" ", "");
    var score = name2Score[key];
    if (score != null) {
      course.courseCode = score.courseCode;
      course.courseCredit = score.courseCredit;
    }
  }
}

SitTimetable parsePostgraduateTimetableFromCourseRaw(
  List<PostgraduateCourseRaw> all, {
  required Campus campus,
}) {
  final List<SitCourse> courseKey2Entity = [];
  var counter = 0;
  for (final raw in all) {
    final courseKey = counter++;
    final weekIndices = _parseWeekText2RangedNumbers(
      mapChinesePunctuations(raw.weekText),
      allSuffix: "周",
      oddSuffix: "周(单周)",
      evenSuffix: "周(双周)",
    );
    final dayIndex = _weekday2Index[raw.weekDayText];
    assert(dayIndex != null && 0 <= dayIndex && dayIndex < 7, "dayIndex isn't in range [0,6] but $dayIndex");
    if (dayIndex == null || !(0 <= dayIndex && dayIndex < 7)) continue;
    final timeslotsText = raw.timeslotsText.endsWith("节")
        ? raw.timeslotsText.substring(0, raw.timeslotsText.length - 1)
        : raw.timeslotsText;
    final timeslots = rangeFromString(timeslotsText, number2index: true);
    assert(timeslots.start <= timeslots.end, "${timeslots.start} > ${timeslots.end} actually. ${raw.courseName}");
    final course = SitCourse(
      courseKey: courseKey,
      courseName: mapChinesePunctuations(raw.courseName).trim(),
      courseCode: raw.courseCode.trim(),
      classCode: raw.classCode.trim(),
      campus: campus,
      place: reformatPlace(mapChinesePunctuations(raw.place)),
      weekIndices: weekIndices,
      timeslots: timeslots,
      courseCredit: double.tryParse(raw.courseCredit) ?? 0.0,
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
