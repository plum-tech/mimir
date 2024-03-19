import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/expansion_tile.dart';
import 'package:sit/l10n/time.dart';
import 'package:sit/school/widgets/course.dart';
import 'package:sit/timetable/entity/timetable.dart';

class TimetableCourseCard extends StatelessWidget {
  final String courseName;
  final List<SitCourse> courses;
  final Color color;

  const TimetableCourseCard({
    super.key,
    required this.courseName,
    required this.courses,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FilledCard(
      clip: Clip.hardEdge,
      child: AnimatedExpansionTile(
        leading: CourseIcon(courseName: courseName),
        initiallyExpanded: true,
        rotateTrailing: false,
        title: courseName.text(),
        trailing: FilledCard(
          color: color,
          child: const SizedBox(width: 32, height: 32),
        ),
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
