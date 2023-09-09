import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/colors.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/list.dart';
import '../entity/score.dart';
import "../i18n.dart";
import '../page/detail.dart';

class AttendedActivityTile extends StatelessWidget {
  final ScJoinedActivity rawActivity;

  const AttendedActivityTile(this.rawActivity, {super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = context.textTheme.titleMedium;
    final subtitleStyle = context.textTheme.bodySmall;

    final color = rawActivity.isPassed ? Colors.green : context.themeColor;
    final trailingStyle = context.textTheme.titleLarge?.copyWith(color: color);
    final activity = ActivityParser.parse(rawActivity);

    return ListTile(
      isThreeLine: true,
      title: Text(activity.realTitle, style: titleStyle),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${i18n.application.time}: ${context.formatYmdhmsNum(rawActivity.time)}', style: subtitleStyle),
          Text('${i18n.application.id}: ${rawActivity.applyId}', style: subtitleStyle),
        ],
      ),
      trailing: Text(rawActivity.amount.abs() > 0.01 ? rawActivity.amount.toStringAsFixed(2) : rawActivity.status,
          style: trailingStyle),
      onTap: rawActivity.activityId != -1
          ? () {
              context.push("/class2nd/activity-detail", extra: activity);
            }
          : null,
    );
  }
}
