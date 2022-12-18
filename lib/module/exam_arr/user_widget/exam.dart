import 'package:flutter/material.dart';
import 'package:mimir/module/exam_arr/entity/exam.dart';
import 'package:rettulf/rettulf.dart';

import '../using.dart';

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
    final itemStyle = Theme.of(context).textTheme.bodyText2;
    final name = stylizeCourseName(exam.courseName);
    final strStartTime = exam.time.isNotEmpty ? dateFullNum(exam.time[0]) : '/';
    final strEndTime = exam.time.isNotEmpty ? dateFullNum(exam.time[1]) : '/';
    final place = stylizeCourseName(exam.place);
    final seatNumber = exam.seatNumber;
    final isSecondExam = exam.isSecondExam;

    TableRow buildRow(String icon, String title, String content) {
      return TableRow(children: [
        _buildItem(icon, title),
        Text(content, style: itemStyle, overflow: TextOverflow.ellipsis),
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: Theme.of(context).textTheme.headline6).padAll(12),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {0: FlexColumnWidth(4), 1: FlexColumnWidth(5)},
          children: [
            buildRow('timetable/campus.png', i18n.examLocation, place),
            buildRow('timetable/courseId.png', i18n.examSeatNumber, '$seatNumber'),
            buildRow('timetable/day.png', i18n.examStartTime, strStartTime),
            buildRow('timetable/day.png', i18n.examEndTime, strEndTime),
            buildRow('', i18n.examIsRetake, isSecondExam),
          ],
        )
      ],
    );
  }

  Widget _buildItem(String icon, String text) {
    final itemStyle = context.textTheme.bodyText1;
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
