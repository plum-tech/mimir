import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/school/widgets/course.dart';
import 'package:sit/timetable/entity/timetable.dart';

class TimetableCourseCard extends StatelessWidget {
  final SitCourse course;
  final Color color;

  const TimetableCourseCard(
    this.course, {
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FilledCard(
      child: ListTile(
        isThreeLine: true,
        leading: CourseIcon(courseName: course.courseName),
        title: course.courseName.text(),
        subtitle: [
          if (course.place.isNotEmpty) course.place.text(),
          if (course.teachers.isNotEmpty) course.teachers.join(", ").text(),
        ].column(caa: CrossAxisAlignment.start),
        trailing: FilledCard(
          color: color,
          child: const SizedBox(width: 32, height: 32),
        ),
      ),
    );
  }
}
