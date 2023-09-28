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

    final style = context.textTheme.bodyLarge;
    return [
      [
        exam.courseName.text(style: context.textTheme.titleLarge),
        if (exam.isRetake == true) Chip(label: i18n.retake.text(), elevation: 2),
      ].row(maa: MainAxisAlignment.spaceBetween),
      const Divider(),
      Table(
        children: [
          TableRow(children: [
            i18n.location.text(style: style),
            exam.place.text(style: style),
          ]),
          if (exam.seatNumber != null)
            TableRow(children: [
              i18n.seatNumber.text(style: style),
              exam.seatNumber.toString().text(style: style),
            ]),
          if (exam.time.length >= 2)
            TableRow(children: [
              i18n.date.text(style: style),
              buildDate(start: exam.time[0], end: exam.time[1]).text(style: style),
            ]),
          if (exam.time.length >= 2)
            TableRow(children: [
              i18n.time.text(style: style),
              buildTime(start: exam.time[0], end: exam.time[1]).text(style: style),
            ]),
        ],
      )
    ].column(caa: CrossAxisAlignment.start).padSymmetric(v: 20, h: 20).inCard();
  }
}
