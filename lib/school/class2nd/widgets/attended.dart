import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/list.dart';
import '../entity/attended.dart';
import '../utils.dart';
import 'activity.dart';

class AttendedActivityCard extends StatelessWidget {
  final Class2ndAttendedActivity attended;

  const AttendedActivityCard(this.attended, {super.key});

  @override
  Widget build(BuildContext context) {
    final color = attended.isPassed ? Colors.green : context.colorScheme.primary;
    final trailingStyle = context.textTheme.titleMedium?.copyWith(color: color);
    final activity = ActivityParser.parse(attended);
    final (:title, :tags) = splitTitleAndTags(attended.title);
    tags.insert(0, attended.category.l10nName());
    return FilledCard(
      clip: Clip.hardEdge,
      child: ListTile(
        isThreeLine: true,
        titleTextStyle: context.textTheme.titleMedium,
        title: Text("$title #${attended.applyId}"),
        subtitleTextStyle: context.textTheme.bodyMedium,
        subtitle: [
          Divider(color: context.colorScheme.onSurfaceVariant),
          context.formatYmdhmsNum(attended.time).text(),
          ActivityTagsGroup(tags),
        ].column(caa: CrossAxisAlignment.start),
        trailing: Text(attended.points.abs() > 0.01 ? attended.points.toStringAsFixed(2) : attended.status,
            style: trailingStyle),
        onTap: attended.activityId != -1
            ? () {
                context.push("/class2nd/activity-detail", extra: activity);
              }
            : null,
      ),
    );
  }
}
