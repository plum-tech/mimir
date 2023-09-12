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
        Text(activity.realTitle, style: context.textTheme.titleLarge, softWrap: true).padAll(10),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
          },
          children: [
            buildRow(i18n.id, activity.id),
            buildRow(i18n.location, details?.place),
            buildRow(i18n.principal, details?.principal),
            buildRow(i18n.organizer, details?.organizer),
            buildRow(i18n.undertaker, details?.undertaker),
            buildRow(i18n.contactInfo, details?.contactInfo),
            buildRow(i18n.startTime, details?.startTime),
            buildRow(i18n.duration, details?.duration),
            buildRow(i18n.tags, activity.tags.join(' ')),
          ],
        ).padH(10),
      ],
    ).scrolled(physics: const NeverScrollableScrollPhysics()).padAll(8).inCard();
  }
}
