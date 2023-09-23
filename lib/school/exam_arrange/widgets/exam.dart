import 'package:flutter/material.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../i18n.dart';
import '../entity/exam.dart';

class ExamCard extends StatelessWidget {
  final ExamEntry exam;

  const ExamCard({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    final itemStyle = Theme.of(context).textTheme.bodyMedium;
    final name = exam.courseName;
    final strStartTime = exam.time.isNotEmpty ? context.formatMdHmNum(exam.time[0]) : '/';
    final strEndTime = exam.time.isNotEmpty ? context.formatMdHmNum(exam.time[1]) : '/';
    final place = exam.place;
    final seatNumber = exam.seatNumber;
    final isSecondExam = exam.referralStatus;

    Widget buildItem(String text) {
      final itemStyle = context.textTheme.bodyLarge;
      return Row(
        children: [
          const SizedBox(width: 8, height: 32),
          Expanded(child: Text(text, overflow: TextOverflow.ellipsis, style: itemStyle))
        ],
      );
    }

    TableRow buildRow(String title, String content) {
      return TableRow(children: [
        buildItem(title),
        Text(content, style: itemStyle, overflow: TextOverflow.ellipsis),
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: Theme.of(context).textTheme.titleLarge).padAll(12),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {0: FlexColumnWidth(4), 1: FlexColumnWidth(5)},
          children: [
            buildRow( i18n.location, place),
            buildRow(i18n.seatNumber, '$seatNumber'),
            buildRow( i18n.startTime, strStartTime),
            buildRow( i18n.endTime, strEndTime),
            buildRow( i18n.isRetake, isSecondExam),
          ],
        )
      ],
    ).padSymmetric(v: 8, h: 16).inCard();
  }
}
