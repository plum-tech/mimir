import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ical/serializer.dart';
import 'package:intl/intl.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/utils/file.dart';
import 'package:sit/utils/url_launcher.dart';

import '../entity/course.dart';
import '../entity/timetable.dart';

final timetableDateFormat = DateFormat('yyyyMMdd_hhmmss');

String getExportTimetableFilename() {
  return 'sit-timetable-${timetableDateFormat.format(DateTime.now())}.ics';
}

typedef TimetableExportConfig = ({
  Duration? alarmBefore,
});

///导出的方法
String convertTableToIcs({
  required SitTimetableEntity timetable,
  required TimetableExportConfig config,
}) {
  final ICalendar calendar = ICalendar(
    company: 'mysit.life',
    product: 'SIT Life',
    lang: "ZH",
  );
  // 需要把
  final startDate = timetable.type.startDate;
  final alarmBefore = config.alarmBefore;

  for (final week in timetable.weeks) {
    if (week == null) continue;
    for (final day in week.days) {
      for (final lessonSlot in day.timeslot2LessonSlot) {
        for (final lesson in lessonSlot.lessons) {
          final course = lesson.course;
          final (:begin, :end) = course.calcBeginEndTimepoint();
          final (start: startTimeslot, end: endTimeslot) = course.timeslots;
          final timeslotText = "${startTimeslot == endTimeslot ? startTimeslot : '$startTimeslot–$endTimeslot'}";
          // 这里需要使用UTC时间
          // 实际测试得出，如果不使用UTC，有的手机会将其看作本地时间
          // 有的手机会将其看作UTC+0的时间从而导致实际显示时间与预期不一致
          final date = reflectWeekDayNumberToDate(week: week.index, day: course.dayIndex, startDate: startDate);
          final eventStartTime = date.add(Duration(hours: begin.hour, minutes: begin.minute));
          final eventEndTime = date.add(Duration(hours: end.hour, minutes: end.minute));
          final desc = "$timeslotText, ${course.place}, ${course.teachers.join(', ')}";
          final IEvent event = IEvent(
            uid: "SIT-Course-${course.courseCode}-${week.index}-${day.index}",
            summary: course.courseName,
            location: course.place,
            description: desc,
            start: eventStartTime,
            end: eventEndTime,
            alarm: alarmBefore == null
                ? null
                : IAlarm.display(
                    trigger: eventStartTime.subtract(alarmBefore),
                    description: desc,
                  ),
          );
          calendar.addElement(event);
        }
      }
    }
  }
  return calendar.serialize();
}

Future<void> exportTimetableToICalendar(
  BuildContext context, {
  required SitTimetableEntity timetable,
}) async {
  await FileUtils.writeToTempFileAndOpen(
    content: convertTableToIcs(
      timetable: timetable,
      config: (alarmBefore: null,),
    ),
    filename: getExportTimetableFilename(),
    type: 'text/calendar',
  );
}

// void _exportByUrl(Duration? alarmBefore) async {
//   final url = 'http://localhost:8081/${getExportTimetableFilename()}';
//   HttpServer? server;
//   try {
//     server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8081, shared: true);
//
//     debugPrint('HTTP服务启动成功');
//     server.listen((HttpRequest request) {
//       request.response.headers.contentType = ContentType.parse('text/calendar');
//       request.response.write(convertTableToIcs(meta, courses, alarmBefore));
//       request.response.close();
//     });
//
//     // ignore: use_build_context_synchronously
//     await showAlertDialog(
//       context,
//       title: '已生成链接',
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextButton(
//             onPressed: () => launchUrlInBrowser(url),
//             child: Text(url),
//           ),
//           TextButton(
//             onPressed: () async {
//               await Clipboard.setData(ClipboardData(text: url));
//             },
//             child: const Text('点击此处可复制链接'),
//           ),
//           const Text('注意：关闭本对话框后链接将失效'),
//         ],
//       ),
//       actionTextList: ['关闭'],
//     );
//   } catch (e, st) {
//     debugPrint('HTTP服务启动失败');
//     return;
//   } finally {
//     server?.close();
//     debugPrint('HTTP服务已关闭');
//   }
// }
