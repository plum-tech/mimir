import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mimir/school/entity/school.dart';
import 'package:rettulf/rettulf.dart';
import '../entity/timetable.dart';

class TimetableSlotInfo extends StatelessWidget {
  final SitCourse course;
  final int maxLines;

  const TimetableSlotInfo({
    super.key,
    required this.course,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText.rich(
      TextSpan(children: [
        TextSpan(
          text: course.courseName,
          style: context.textTheme.bodyMedium,
        ),
        TextSpan(
          text: "\n${beautifyPlace(course.place)}\n${course.teachers.join(',')}",
          style: context.textTheme.bodySmall,
        ),
      ]),
      minFontSize: 0,
      stepGranularity: 0.1,
      maxLines: maxLines,
      textAlign: TextAlign.center,
    );
  }
}
