import 'dart:io';

import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../entity/course.dart';
import '../entity/meta.dart';
import '../using.dart';
import '../utils.dart';

class ExportDialog {
  final BuildContext context;
  final TimetableMetaLegacy meta;
  final List<Course> courses;
  ExportDialog(this.context, this.meta, this.courses);

  void exportByUrl(Duration? alarmBefore) async {
    final url = 'http://localhost:8081/${getExportTimetableFilename()}';
    HttpServer? server;
    try {
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8081, shared: true);

      Log.info('HTTP服务启动成功');
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
                EasyLoading.showSuccess('成功复制到剪切板');
              },
              child: const Text('点击此处可复制链接'),
            ),
            const Text('注意：关闭本对话框后链接将失效'),
          ],
        ),
        actionTextList: ['关闭'],
      );
    } catch (e, st) {
      Log.info('HTTP服务启动失败');
      Catcher.reportCheckedError(e, st);
      return;
    } finally {
      server?.close();
      Log.info('HTTP服务已关闭');
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
                Log.info('构造：${valueNotifier.value}');
                return DropdownButton<int>(
                  value: valueNotifier.value,
                  items: Iterable.generate(10, (i) => 5 * (i + 1)).map((e) {
                    return DropdownMenuItem<int>(
                      value: e,
                      child: Text('$e 分钟前'),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    Log.info('value: $value');
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
  Widget contentWidget = Container();

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
