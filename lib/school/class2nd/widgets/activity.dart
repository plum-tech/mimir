import 'package:flutter/material.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/tags.dart';
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
        subtitle: TagsGroup(tags),
        onTap: onTap,
      ),
    );
  }
}
