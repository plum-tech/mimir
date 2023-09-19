import 'package:flutter/material.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../i18n.dart';
import '../entity/exam.dart';

class ExamCard extends StatefulWidget {
  final ExamEntry exam;

  const ExamCard({super.key, required this.exam});

  @override
  State<ExamCard> createState() => _ExamCardState();
}

class _ExamCardState extends State<ExamCard> {
  ExamEntry get exam => widget.exam;

  @override
  Widget build(BuildContext context) {
    final itemStyle = Theme.of(context).textTheme.bodyMedium;
    final name = exam.courseName;
    final strStartTime = exam.time.isNotEmpty ? dateFullNum(exam.time[0]) : '/';
    final strEndTime = exam.time.isNotEmpty ? dateFullNum(exam.time[1]) : '/';
    final place = exam.place;
    final seatNumber = exam.seatNumber;
    final isSecondExam = exam.referralStatus;

    TableRow buildRow(String icon, String title, String content) {
      return TableRow(children: [
        _buildItem(icon, title),
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
            buildRow('timetable/campus.png', i18n.location, place),
            buildRow('timetable/courseId.png', i18n.seatNumber, '$seatNumber'),
            buildRow('timetable/day.png', i18n.startTime, strStartTime),
            buildRow('timetable/day.png', i18n.endTime, strEndTime),
            buildRow('', i18n.isRetake, isSecondExam),
          ],
        )
      ],
    ).padSymmetric(v: 8, h: 16).inCard();
  }

  Widget _buildItem(String icon, String text) {
    final itemStyle = context.textTheme.bodyLarge;
    final iconImage = AssetImage('assets/$icon');
    return Row(
      children: [
        icon.isEmpty ? const SizedBox(height: 24, width: 24) : Image(image: iconImage, width: 24, height: 24),
        const SizedBox(width: 8, height: 32),
        Expanded(child: Text(text, overflow: TextOverflow.ellipsis, style: itemStyle))
      ],
    );
  }
}
