import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ical/serializer.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:sanitize_filename/sanitize_filename.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/school/entity/school.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../entity/timetable.dart';

typedef TimetableExportConfig = ({
  Duration? alarmBefore,
  Locale? locale,
});

String _getICalFileName(BuildContext context, SitTimetableEntity timetable) {
  return sanitizeFilename(
    "${timetable.type.name} ${context.formatYmdNum(timetable.type.startDate)}.ics",
    replacement: "-",
  );
}

Future<void> exportTimetableAsICalendarAndOpen(
  BuildContext context, {
  required SitTimetableEntity timetable,
}) async {
  final fileName = _getICalFileName(context, timetable);
  final imgFi = File(join(R.tmpDir, fileName));
  final data = convertTimetable2ICal(
    timetable: timetable,
    config: (
      alarmBefore: null,
      locale: context.locale,
    ),
  );
  await imgFi.writeAsString(data);
  await OpenFile.open(imgFi.path, type: "text/calendar");
}

Future<void> addTimetableToCalendar(
  BuildContext context, {
  required SitTimetableEntity timetable,
}) async {
  final data = convertTimetable2ICal(
    timetable: timetable,
    config: (
      alarmBefore: null,
      locale: context.locale,
    ),
  );
  final uri = "data:text/calendar;charset=utf8,$data";
  // FIXME: doesn't work
  final result = await launchUrlString(uri, mode: LaunchMode.externalApplication);
  debugPrint(result.toString());
}

///导出的方法
String convertTimetable2ICal({
  required SitTimetableEntity timetable,
  required TimetableExportConfig config,
}) {
  final ICalendar calendar = ICalendar(
    company: 'mysit.life',
    product: 'SIT Life',
    lang: config.locale?.toLanguageTag() ?? "EN",
  );
  final startDate = timetable.type.startDate;
  final alarmBefore = config.alarmBefore;

  for (final week in timetable.weeks) {
    if (week == null) continue;
    for (final day in week.days) {
      for (final lessonSlot in day.timeslot2LessonSlot) {
        for (final lesson in lessonSlot.lessons) {
          final course = lesson.course;
          final (:begin, :end) = course.calcBeginEndTimepoint();
          // 这里需要使用UTC时间
          // 实际测试得出，如果不使用UTC，有的手机会将其看作本地时间
          // 有的手机会将其看作UTC+0的时间从而导致实际显示时间与预期不一致
          final thatDay = reflectWeekDayNumberToDate(weekIndex: week.index, dayIndex: day.index, startDate: startDate);
          final eventStartTime = thatDay.add(Duration(hours: begin.hour, minutes: begin.minute));
          final eventEndTime = thatDay.add(Duration(hours: end.hour, minutes: end.minute));
          final classDuration = lesson.calcuClassDuration();
          final event = IEvent(
            uid: "SIT-Course-${course.courseCode}-${week.index}-${day.index}",
            summary: course.courseName,
            location: course.place,
            description: course.teachers.join(', '),
            start: eventStartTime,
            end: eventEndTime,
            duration: Duration(hours: classDuration.hour, minutes: classDuration.minute),
            alarm: alarmBefore == null
                ? null
                : IAlarm.display(
                    trigger: eventStartTime.subtract(alarmBefore),
                    description: "",
                  ),
          );
          calendar.addElement(event);
        }
      }
    }
  }
  return calendar.serialize();
}
