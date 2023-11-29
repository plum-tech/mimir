import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/school/class2nd/utils.dart';

import '../entity/announce.dart';

class OaAnnounceTile extends StatelessWidget {
  final OaAnnounceRecord record;

  const OaAnnounceTile(
    this.record, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final (:title, :tags) = separateTagsFromTitle(record.title);

    return ListTile(
      isThreeLine: true,
      titleTextStyle: textTheme.titleMedium,
      title: title.text(),
      subtitleTextStyle: textTheme.bodySmall,
      subtitle: (record.departments + tags)
          .map((e) => Chip(
                label: e.trim().text(style: textTheme.bodySmall),
                padding: EdgeInsets.zero,
                elevation: 4,
              ))
          .toList()
          .wrap(spacing: 4),
      trailing: context.formatYmdNum(record.dateTime).text(style: textTheme.bodySmall),
      onTap: () {
        context.push("/oa-announce/details", extra: record);
      },
    );
  }
}
