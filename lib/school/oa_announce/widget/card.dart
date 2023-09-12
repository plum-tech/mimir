import 'package:flutter/material.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';
import '../entity/announce.dart';
import '../i18n.dart';

class OaAnnounceInfoCard extends StatelessWidget {
  final OaAnnounceRecord record;
  final OaAnnounceDetails? details;

  const OaAnnounceInfoCard({
    super.key,
    required this.record,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.bodyMedium;
    final keyStyle = valueStyle?.copyWith(fontWeight: FontWeight.bold);

    TableRow buildRow(String key, String value) => TableRow(
          children: [
            Text(key, style: keyStyle),
            Text(value, style: valueStyle),
          ],
        );

    return Card(
      elevation: 3,
      child: [
        record.title.text(style: context.textTheme.titleLarge),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(3),
          },
          children: [
            buildRow(i18n.publishingDepartment, record.departments.join(",")),
            buildRow(i18n.author, details?.author ?? ""),
            buildRow(i18n.publishTime, context.formatYmdWeekText(record.dateTime)),
          ],
        ),
      ].column(maa: MainAxisAlignment.spaceEvenly).scrolled(physics: const NeverScrollableScrollPhysics()).padAll(8),
    );
  }
}
