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
        subtitle: ActivityTagsGroup(activity.tags),
        onTap: () {
          context.push("/class2nd/activity-detail?enable-apply=true", extra: activity);
        },
      ),
    );
  }
}

class ActivityTagsGroup extends StatelessWidget {
  final List<String> tags;

  const ActivityTagsGroup(
    this.tags, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return tags
        .map(
          (tag) => RawChip(
            label: tag.text(),
            padding: EdgeInsets.zero,
            labelStyle: textTheme.bodySmall,
            elevation: 4,
          ),
        )
        .toList()
        .wrap(spacing: 4);
  }
}
