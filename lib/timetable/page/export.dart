import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ical/serializer.dart';
import 'package:intl/intl.dart';
import 'package:sit/utils/file.dart';
import 'package:sit/utils/url_launcher.dart';

import '../entity/course.dart';
import '../entity/timetable.dart';

final timetableDateFormat = DateFormat('yyyyMMdd_hhmmss');

String getExportTimetableFilename() {
  return 'sit-timetable-${timetableDateFormat.format(DateTime.now())}.ics';
}

///导出的方法
String convertTableToIcs(SitTimetable timetable, Duration? alarmBefore) {
  final ICalendar iCal = ICalendar(
    company: 'Liplum',
    product: 'Mímir',
    lang: 'ZH',
    refreshInterval: const Duration(days: 36500),
  );
  // 需要把
  final startDate = DateTime(timetable.startDate.year, timetable.startDate.month, timetable.startDate.day);
  for (final course in timetable.courseKey2Entity) {
    // _addEventForCourse(iCal, course, startDate, alarmBefore);
  }
  return iCal.serialize();
}

Future<void> exportTimetableToICalendar(
  BuildContext context, {
  required SitTimetable timetable,
}) async {
  await FileUtils.writeToTempFileAndOpen(
    content: convertTableToIcs(timetable, null),
    filename: getExportTimetableFilename(),
    type: 'text/calendar',
  );
}

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

