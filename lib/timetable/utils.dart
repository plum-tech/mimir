import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:sit/r.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/settings.dart';
import 'package:sit/timetable/storage/timetable.dart';
import 'package:sanitize_filename/sanitize_filename.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_platform/universal_platform.dart';
import 'entity/timetable.dart';

import 'entity/course.dart';
import 'dart:math';

import 'init.dart';
import 'package:path/path.dart' show join;

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
      place: mapChinesePunctuations(raw.place),
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
  final List<SitTimetableWeek?> weeks = List.generate(20, (index) => null);
  SitTimetableWeek getWeekAt(int index) {
    final week = weeks[index] ??= SitTimetableWeek.$7days();
    weeks[index] = week;
    return week;
  }

  for (var courseKey = 0; courseKey < timetable.courseKey2Entity.length; courseKey++) {
    final course = timetable.courseKey2Entity[courseKey];
    final timeslots = course.timeslots;
    for (final weekIndex in course.weekIndices.getWeekIndices()) {
      assert(0 <= weekIndex && weekIndex < maxWeekLength,
          "Week index is more out of range [0,$maxWeekLength) but $weekIndex.");
      if (0 <= weekIndex && weekIndex < maxWeekLength) {
        final week = getWeekAt(weekIndex);
        final day = week.days[course.dayIndex];
        for (int slot = timeslots.start; slot <= timeslots.end; slot++) {
          day.add(SitTimetableLesson(timeslots.start, timeslots.end, course), at: slot);
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
  final id = addNewTimetable(timetable);
  return (id: id, timetable: timetable);
}

/// Adds the [timetable] into [TimetableStorage.timetable].
/// Updates the selected timetable id.
/// If [TimetableSettings.autoUseImported] is enabled, the [timetable] will be used.
int addNewTimetable(SitTimetable timetable) {
  final id = TimetableInit.storage.timetable.add(timetable);
  if (Settings.timetable.autoUseImported) {
    TimetableInit.storage.timetable.selectedId = id;
  } else {
    // use this timetable if no one else
    TimetableInit.storage.timetable.selectedId ??= id;
  }
  return id;
}

Future<void> exportTimetableFileAndShare(
  SitTimetable timetable, {
  required BuildContext context,
}) async {
  final content = jsonEncode(timetable.toJson());
  final fileName = sanitizeFilename("${timetable.name}.timetable", replacement: "-");
  final timetableFi = File(join(R.tmpDir, fileName));
  final box = context.findRenderObject() as RenderBox?;
  final sharePositionOrigin = box == null ? null : box.localToGlobal(Offset.zero) & box.size;
  if (UniversalPlatform.isIOS || UniversalPlatform.isMacOS) {
    assert(sharePositionOrigin != null, "sharePositionOrigin should be nonnull on iPad and macOS");
  }
  await timetableFi.writeAsString(content);
  await Share.shareXFiles(
    [XFile(timetableFi.path)],
    sharePositionOrigin: sharePositionOrigin,
  );
}
