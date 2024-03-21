import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/expansion_tile.dart';
import 'package:sit/l10n/time.dart';
import 'package:sit/school/widgets/course.dart';
import 'package:sit/timetable/entity/timetable.dart';
import '../i18n.dart';

class TimetableCourseCard extends StatelessWidget {
  final String courseName;
  final String courseCode;
  final String classCode;
  final List<SitCourse> courses;
  final Color? color;

  const TimetableCourseCard({
    super.key,
    required this.courseName,
    required this.courseCode,
    required this.classCode,
    required this.courses,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FilledCard(
      clip: Clip.hardEdge,
      color: color,
      child: AnimatedExpansionTile(
        leading: CourseIcon(courseName: courseName),
        title: courseName.text(),
        subtitle: [
          if (courseCode.isNotEmpty) "${i18n.course.courseCode} $courseCode".text(),
          if (classCode.isNotEmpty) "${i18n.course.classCode} $classCode".text(),
        ].column(caa: CrossAxisAlignment.start),
        children: courses.map((course) {
          final weekNumbers = course.weekIndices.l10n();
          final (:begin, :end) = course.calcBeginEndTimePoint();
          return ListTile(
            isThreeLine: true,
            title: course.place.text(),
            trailing: course.teachers.join(", ").text(),
            subtitle: [
              "${Weekday.fromIndex(course.dayIndex).l10n()} ${begin.l10n(context)}–${end.l10n(context)}".text(),
              ...weekNumbers.map((n) => n.text()),
            ].column(mas: MainAxisSize.min, caa: CrossAxisAlignment.start),
          );
        }).toList(),
      ),
    );
  }
}
