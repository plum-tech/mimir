import 'package:flutter/material.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/school/widgets/course.dart';
import 'package:rettulf/rettulf.dart';

import '../i18n.dart';
import '../entity/exam.dart';

class ExamCard extends StatelessWidget {
  final ExamEntry exam;

  const ExamCard({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    final itemStyle = Theme.of(context).textTheme.bodyMedium;

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

    String buildDate({required DateTime start, required DateTime end}) {
      if (start.year == end.year && start.month == end.month && start.day == end.day) {
        // at the same day
        return context.formatMdWeekText(start);
      } else {
        return "${context.formatMdNum(start)}–${context.formatMdNum(end)}";
      }
    }

    String buildTime({required DateTime start, required DateTime end}) {
      if (start.year == end.year && start.month == end.month && start.day == end.day) {
        // at the same day
        return "${context.formatHmNum(start)}–${context.formatHmNum(end)}";
      } else {
        return "${context.formatMdhmNum(start)}–${context.formatMdhmNum(end)}";
      }
    }

    return ListTile(
      isThreeLine: true,
      titleTextStyle: context.textTheme.titleLarge,
      title: exam.courseName.text(),
      subtitle: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const {0: FlexColumnWidth(4), 1: FlexColumnWidth(5)},
        children: [
          buildRow(i18n.location, exam.place),
          buildRow(i18n.seatNumber, exam.seatNumber.toString()),
          if (exam.time.length >= 2) buildRow(i18n.date, buildDate(start: exam.time[0], end: exam.time[1])),
          if (exam.time.length >= 2) buildRow(i18n.time, buildTime(start: exam.time[0], end: exam.time[1])),
        ],
      ),
      trailing: exam.isRetake == null ? i18n.retake.text() : null,
    ).inCard();
  }
}
