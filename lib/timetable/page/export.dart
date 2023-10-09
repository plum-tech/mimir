import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ical/serializer.dart';
import 'package:intl/intl.dart';
import 'package:sit/utils/file.dart';
import 'package:sit/utils/url_launcher.dart';

import '../entity/course.dart';
import '../entity/timetable.dart';

// TODO: New export
class ExportDialog {
  final BuildContext context;
  final TimetableMeta meta;
  final List<CourseRaw> courses;

  ExportDialog(this.context, this.meta, this.courses);

  void exportByUrl(Duration? alarmBefore) async {
    final url = 'http://localhost:8081/${getExportTimetableFilename()}';
    HttpServer? server;
    try {
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8081, shared: true);

      debugPrint('HTTP服务启动成功');
      server.listen((HttpRequest request) {
        request.response.headers.contentType = ContentType.parse('text/calendar');
        request.response.write(convertTableToIcs(meta, courses, alarmBefore));
        request.response.close();
      });

      // ignore: use_build_context_synchronously
      await showAlertDialog(
        context,
        title: '已生成链接',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => launchUrlInBrowser(url),
              child: Text(url),
            ),
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: url));
              },
              child: const Text('点击此处可复制链接'),
            ),
            const Text('注意：关闭本对话框后链接将失效'),
          ],
        ),
        actionTextList: ['关闭'],
      );
    } catch (e, st) {
      debugPrint('HTTP服务启动失败');
      return;
    } finally {
      server?.close();
      debugPrint('HTTP服务已关闭');
    }
  }

  /// 询问用户是否导入
  /// 返回null表示用户不想导入了
  Future<bool?> showWantToSetAlarm() async {
    final result = await showAlertDialog(
      context,
      title: '设置课前提醒',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('您是否想要设置课前提醒？'),
        ],
      ),
      actionWidgetList: [
        ElevatedButton(onPressed: () {}, child: const Text('设置课前提醒')),
        SizedBox(width: 10.w),
        ElevatedButton(onPressed: () {}, child: const Text('不想设置')),
      ],
    );
    if (result == null) return null;
    if (result == 0) return true;
    return false;
  }

  Future<Duration?> showDurationPicker() async {
    // TODO: 选择提醒时间对话框
    ValueNotifier<int> valueNotifier = ValueNotifier(15);
    final result = await showAlertDialog(
      context,
      title: '设置提醒时间',
      content: [
        Row(
          children: [
            const Text('距离开课'),
            ValueListenableBuilder(
              valueListenable: valueNotifier,
              builder: (context, int data, child) {
                debugPrint('构造：${valueNotifier.value}');
                return DropdownButton<int>(
                  value: valueNotifier.value,
                  items: Iterable.generate(10, (i) => 5 * (i + 1)).map((e) {
                    return DropdownMenuItem<int>(
                      value: e,
                      child: Text('$e 分钟前'),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    debugPrint('value: $value');
                    valueNotifier.value = value ?? valueNotifier.value;
                  },
                );
              },
            ),
          ],
        ),
      ],
      actionTextList: ['确认'],
    );
    if (result == null) return null;
    return Duration(minutes: valueNotifier.value);
  }

  void export() async {
    final wantToSetAlarm = await showWantToSetAlarm();
    if (wantToSetAlarm == null) return;
    Duration? alarmBefore;

    // 如果想设置
    if (wantToSetAlarm) {
      alarmBefore = await showDurationPicker();

      // 被用户dismiss掉了
      if (alarmBefore == null) return;
    }

    // ignore: use_build_context_synchronously
    await showAlertDialog(
      context,
      title: '请选择导出方式',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => exportTimetableToCalendar(meta, courses, alarmBefore),
            child: const Text('导出至文件'),
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
            onPressed: () => exportByUrl(alarmBefore),
            child: const Text('导出为URL'),
          ),
        ],
      ),
      actionWidgetList: [
        TextButton(
          onPressed: () {},
          child: const Text('关闭对话框'),
        ),
      ],
    );
  }
}

/// 显示对话框,对话框关闭后Future结束
Future<int?> showAlertDialog(
  BuildContext context, {
  String? title,
  dynamic content,
  List<String>? actionTextList,
  List<Widget>? actionWidgetList,
}) async {
  if (actionTextList != null && actionWidgetList != null) {
    throw Exception('actionTextList 与 actionWidgetList 参数不可同时传入');
  }

  if (actionTextList == null && actionWidgetList == null) {
    actionWidgetList = [];
  }
  Widget contentWidget = const SizedBox();

  if (content is List<Widget>) {
    contentWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: content,
    );
  } else if (content is Widget) {
    contentWidget = content;
  } else if (context is String) {
    contentWidget = Text(content);
  } else {
    throw TypeError();
  }

  final List<Widget> actions = () {
    if (actionTextList != null) {
      return actionTextList.asMap().entries.map((e) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context, e.key);
            },
            child: Text(e.value),
          ),
        );
      }).toList();
    } else {
      return actionWidgetList!.asMap().entries.map((e) {
        return InkWell(
          onTap: () {
            Navigator.pop(context, e.key);
          },

          /// 把外部Widget的点击吸收掉
          child: AbsorbPointer(
            child: e.value,
          ),
        );
      }).toList();
    }
  }();

  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: title == null ? null : Center(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
      content: contentWidget,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: actions,
        ),
      ],
    ),
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
