import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/announce.dart';

class OaAnnounceTile extends StatelessWidget {
  final AnnounceRecord record;

  const OaAnnounceTile(
    this.record, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return ListTile(
      isThreeLine: true,
      titleTextStyle: textTheme.titleMedium,
      title: Text(
        record.title,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
      subtitleTextStyle: textTheme.bodySmall,
      subtitle: record.departments
          .map((e) => Chip(
                label: e.trim().text(style: textTheme.bodySmall),
                padding: EdgeInsets.zero,
              ))
          .toList()
          .wrap(spacing: 8),
      trailing: context.formatYmdNum(record.dateTime).text(style: textTheme.bodySmall),
      onTap: () {
        context.push("/oa-announce/details", extra: record);
      },
    );
  }
}
