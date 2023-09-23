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
    Widget buildRow(String title, String content) {
      return "$title: $content".text();
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
      subtitleTextStyle: context.textTheme.bodyMedium,
      subtitle: [
        buildRow(i18n.location, exam.place),
        if (exam.seatNumber != null) buildRow(i18n.seatNumber, exam.seatNumber.toString()),
        if (exam.time.length >= 2) buildRow(i18n.date, buildDate(start: exam.time[0], end: exam.time[1])),
        if (exam.time.length >= 2) buildRow(i18n.time, buildTime(start: exam.time[0], end: exam.time[1])),
      ].column(caa: CrossAxisAlignment.start),
      trailing: exam.isRetake == true ? Chip(label: i18n.retake.text()) : null,
    ).inCard();
  }
}
