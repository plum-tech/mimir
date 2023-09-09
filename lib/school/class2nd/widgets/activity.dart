import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/list.dart';

class ActivityCard extends StatelessWidget {
  final Class2ndActivity activity;

  const ActivityCard(this.activity, {super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return FilledCard(
      child: ListTile(
        isThreeLine: true,
        title: activity.realTitle.text(),
        titleTextStyle: textTheme.titleMedium,
        trailing: context.formatYmdNum(activity.ts).text(style: textTheme.bodyMedium),
        subtitle: activity.tags
            .map((tag) => RawChip(
                  label: tag.text(),
                  padding: EdgeInsets.zero,
                  labelStyle: textTheme.bodySmall,
                ))
            .toList()
            .wrap(spacing: 4),
        onTap: () {
          context.push("/class2nd/activity-detail?enable-apply=true", extra: activity);
        },
      ),
    ).hero(activity.id);
  }
}
