import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/school/widgets/course.dart';
import 'package:sit/timetable/entity/platte.dart';
import 'package:sit/timetable/entity/timetable.dart';
import 'package:sit/timetable/platte.dart';

class TimetableCourseCard extends StatelessWidget {
  final SitCourse course;
  final TimetablePalette? palette;

  const TimetableCourseCard(
    this.course, {
    super.key,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return FilledCard(
      child: ListTile(
        isThreeLine: true,
        leading: CourseIcon(courseName: course.courseName),
        title: course.courseName.text(),
        subtitle: [
          course.place.text(),
          course.teachers.join(", ").text(),
        ].column(caa: CrossAxisAlignment.start),
        trailing: FilledCard(
          color: palette?.resolveColor(course).byTheme(context.theme),
          child: const SizedBox(width: 32, height: 32),
        ),
      ),
    );
  }
}
