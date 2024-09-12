import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/files.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/utils/ical.dart';
import 'package:open_file/open_file.dart';
import 'package:sanitize_filename/sanitize_filename.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_platform/universal_platform.dart';

import '../entity/timetable.dart';
import '../entity/timetable_entity.dart';
import '../page/ical.dart';

Future<void> exportTimetableFileAndShare(
  Timetable timetable, {
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
  required TimetableEntity timetable,
  required TimetableICalConfig config,
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
  required TimetableEntity timetable,
  required TimetableICalConfig config,
}) {
  final calendar = ICal(
    company: 'mysit.life',
    product: 'SIT Life',
    lang: config.locale?.toLanguageTag() ?? "EN",
  );
  final alarm = config.alarm;
  final merged = config.isLessonMerged;
  final added = <SitTimetableLesson>{};
  for (final day in timetable.days) {
    for (final lessonSlot in day.timeslot2LessonSlot) {
      for (final part in lessonSlot.lessons) {
        final lesson = part.type;
        if (merged && added.contains(lesson)) {
          continue;
        } else {
          added.add(lesson);
        }
        final course = part.course;
        final teachers = course.teachers.join(', ');
        final startTime = (merged ? lesson.startTime : part.startTime).toUtc();
        final endTime = (merged ? lesson.endTime : part.endTime).toUtc();
        final uid = merged
            ? "${R.appId}.${course.courseCode}.${day.weekIndex}.${day.weekday.index}.${lesson.startIndex}-${lesson.endIndex}"
            : "${R.appId}.${course.courseCode}.${day.weekIndex}.${day.weekday.index}.${part.index}";
        // Use UTC
        final event = calendar.addEvent(
          uid: uid,
          summary: course.courseName,
          location: course.place,
          description: teachers,
          comment: teachers,
          start: startTime,
          end: endTime,
        );
        if (alarm != null) {
          final trigger = startTime.subtract(alarm.alarmBeforeClass).toUtc();
          if (alarm.isDisplayAlarm) {
            event.addAlarmDisplay(
              triggerDate: trigger,
              description: "${course.courseName} ${course.place} $teachers",
              repeating: (repeat: 1, duration: alarm.alarmDuration),
            );
          } else {
            event.addAlarmAudio(
              triggerDate: trigger,
              repeating: (repeat: 1, duration: alarm.alarmDuration),
            );
          }
        }
        if (merged) {
          // skip the `lessonParts` loop
          break;
        }
      }
    }
  }
  return calendar.build();
}
