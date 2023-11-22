import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/details.dart';
import '../entity/list.dart';
import '../i18n.dart';

class ActivityDetailsCard extends StatelessWidget {
  final Class2ndActivityDetails? details;
  final Class2ndActivity activity;

  const ActivityDetailsCard({
    super.key,
    required this.activity,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.bodyMedium;
    final keyStyle = valueStyle?.copyWith(fontWeight: FontWeight.bold);

    buildRow(String key, Object? value) => TableRow(
          children: [
            Text(key, style: keyStyle),
            value == null ? const SizedBox() : value.toString().text(style: valueStyle),
          ],
        );

    return Column(
      children: [
        Text(details?.title ?? activity.realTitle, style: context.textTheme.titleLarge, softWrap: true).padAll(10),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
          },
          children: [
            buildRow(i18n.info.activityId, activity.id),
            buildRow(i18n.info.location, details?.place),
            buildRow(i18n.info.principal, details?.principal),
            buildRow(i18n.info.organizer, details?.organizer),
            buildRow(i18n.info.undertaker, details?.undertaker),
            buildRow(i18n.info.contactInfo, details?.contactInfo),
            buildRow(i18n.info.startTime, details?.startTime),
            buildRow(i18n.info.duration, details?.duration),
            buildRow(i18n.info.tags, activity.tags.join(' ')),
          ],
        ).padH(10),
      ],
    ).scrolled(physics: const NeverScrollableScrollPhysics()).padAll(8).inCard();
  }
}
