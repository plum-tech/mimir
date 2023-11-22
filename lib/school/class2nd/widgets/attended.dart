import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/attended.dart';
import '../utils.dart';
import 'activity.dart';
import "../i18n.dart";

class AttendedActivityCard extends StatelessWidget {
  final Class2ndAttendedActivity attended;

  const AttendedActivityCard(this.attended, {super.key});

  @override
  Widget build(BuildContext context) {
    final (:title, :tags) = separateTagsFromTitle(attended.title);
    tags.insert(0, attended.category.l10nName());
    final points = attended.points;
    final honestyPoints = attended.honestyPoints;
    return FilledCard(
      clip: Clip.hardEdge,
      child: ListTile(
          isThreeLine: true,
          titleTextStyle: context.textTheme.titleMedium,
          title: title.text(),
          subtitleTextStyle: context.textTheme.bodyMedium,
          subtitle: [
            "#${attended.application.applyId}".text(),
            Divider(color: context.colorScheme.onSurfaceVariant),
            context.formatYmdhmsNum(attended.application.time).text(),
            if (honestyPoints != null && honestyPoints.abs() > 0)
              "${honestyPoints.toStringAsFixed(2)} ${i18n.attended.honestyPoints}"
                  .text(style: TextStyle(color: honestyPoints.isNegative ? context.$red$ : null)),
            ActivityTagsGroup(tags),
          ].column(caa: CrossAxisAlignment.start),
          trailing: points != null
              ? Text(
                  points.toStringAsFixed(2),
                  style: context.textTheme.titleMedium?.copyWith(color: points > 0 ? Colors.green : null),
                )
              : Text(
                  attended.application.status,
                  style: context.textTheme.titleMedium
                      ?.copyWith(color: attended.application.isPassed ? Colors.green : null),
                ),
          onTap: () async {
            await context.push("/class2nd/attended-details", extra: attended);
          }),
    );
  }
}
