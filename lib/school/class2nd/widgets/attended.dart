import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/list.dart';
import '../entity/score.dart';
import "../i18n.dart";

class AttendedActivityCard extends StatelessWidget {
  final Class2ndAttendedActivity attended;

  const AttendedActivityCard(this.attended, {super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = context.textTheme.titleMedium;
    final subtitleStyle = context.textTheme.bodySmall;

    final color = attended.isPassed ? Colors.green : context.colorScheme.primary;
    final trailingStyle = context.textTheme.titleMedium?.copyWith(color: color);
    final activity = ActivityParser.parse(attended);

    return ListTile(
      isThreeLine: true,
      title: Text(attended.title, style: titleStyle),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${i18n.attended.time}: ${context.formatYmdhmsNum(attended.time)}', style: subtitleStyle),
          Text('${i18n.attended.id}: ${attended.applyId}', style: subtitleStyle),
        ],
      ),
      trailing: Text(attended.points.abs() > 0.01 ? attended.points.toStringAsFixed(2) : attended.status,
          style: trailingStyle),
      onTap: attended.activityId != -1
          ? () {
              context.push("/class2nd/activity-detail", extra: activity);
            }
          : null,
    );
  }
}
