import 'package:flutter/material.dart';

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
