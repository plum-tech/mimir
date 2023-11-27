import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/list.dart';
import '../utils.dart';

class ActivityCard extends StatelessWidget {
  final Class2ndActivity activity;
  final VoidCallback? onTap;

  const ActivityCard(
    this.activity, {
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final (:title, :tags) = separateTagsFromTitle(activity.title);
    return FilledCard(
      clip: Clip.hardEdge,
      child: ListTile(
        isThreeLine: true,
        title: title.text(),
        titleTextStyle: textTheme.titleMedium,
        trailing: context.formatYmdNum(activity.time).text(style: textTheme.bodyMedium),
        subtitle: ActivityTagsGroup(tags),
        onTap: onTap,
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
          (tag) => Chip(
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
