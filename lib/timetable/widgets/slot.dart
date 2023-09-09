import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mimir/design/colors.dart';
import 'package:mimir/school/entity/school.dart';
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
        ),
        TextSpan(
          text: "\n${beautifyPlace(course.place)}\n${course.teachers.join(',')}",
          style: TextStyle(color: context.textColor.withOpacity(0.65), fontSize: 12.sp),
        ),
      ]),
      minFontSize: 0,
      stepGranularity: 0.1,
      maxLines: maxLines,
      textAlign: TextAlign.center,
    );
  }
}
