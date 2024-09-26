import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/backend/stats/utils/stats.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/design/widget/app.dart';
import 'package:mimir/design/widget/task_builder.dart';
import 'package:mimir/feature/feature.dart';
import 'package:mimir/init.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/utils/error.dart';

class OpenLabDoorAppCard extends ConsumerStatefulWidget {
  const OpenLabDoorAppCard({super.key});

  @override
  ConsumerState<OpenLabDoorAppCard> createState() => _OpenLabDoorAppCardState();
}

class _OpenLabDoorAppCardState extends ConsumerState<OpenLabDoorAppCard> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: "机协实验室".text(),
      subtitle: '请先连接 Wi-Fi "Robot"'.text(),
      leftActions: [
        TaskBuilder(
          task: openDoor,
          builder: (context, task, running) {
            return FilledButton.icon(
              icon: Icon(context.icons.unlock),
              onPressed: task,
              label: "开门".text(),
            );
          },
        ),
      ],
    );
  }

  Future<void> openDoor() async {
    final result = await sitRobotOpenDoor();
    if (result) {
      await Future.delayed(const Duration(milliseconds: 2000));
      if (!mounted) return;
      context.showSnackBar(content: "开门成功".text());
      Stats.feature(AppFeature.sitRobotOpenLabDoor, "/open?success");
    } else {
      Stats.feature(AppFeature.sitRobotOpenLabDoor, "/open?failed");
      if (!mounted) return;
      context.showSnackBar(content: "开门失败".text());
    }
  }
}

const _url =
    "aHR0cDovLzIxMC4zNS45OC4xNzg6NzEwMS9MTVdlYi9XZWJBcGkvSFNoaVlhblNoaS5hc2h4P01ldGhvZD1TYXZlUmVtb3RlT3BlbkRvb3ImU2hpWWFuU2hpSUQmS2FIYW89NTE1RkY1NzImTWFjSUQ9Mjg6NTI6Rjk6MTg6ODQ6Njc=";

Future<bool> sitRobotOpenDoor() async {
  try {
    final res = await Init.schoolDio.get(
      String.fromCharCodes(base64Decode(_url)),
    );
    return res.data.toString() == "1,5000";
  } catch (error, stackTrace) {
    debugPrintError(error, stackTrace);
    return false;
  }
}
