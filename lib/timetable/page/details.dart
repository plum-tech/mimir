import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/l10n/time.dart';
import 'package:text_scroll/text_scroll.dart';

import '../i18n.dart';
import '../entity/timetable.dart';

class TimetableCourseDetailsSheet extends StatelessWidget {
  final String courseCode;
  final SitTimetableEntity timetable;

  /// 一门课可能包括实践和理论课. 由于正方不支持这种设置, 实际教务系统在处理中会把这两部分拆开, 但是它们的课程名称和课程代码是一样的
  /// classes 中存放的就是对应的所有课程, 我们在这把它称为班级.
  const TimetableCourseDetailsSheet({
    super.key,
    required this.courseCode,
    required this.timetable,
  });

  @override
  Widget build(BuildContext context) {
    final courses = timetable.findAndCacheCoursesByCourseCode(courseCode);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: TextScroll(
              courses[0].courseName,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverToBoxAdapter(
              child: buildTable(courses),
            ),
          ),
          const SliverToBoxAdapter(
            child: Divider(),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverList.builder(
              itemCount: courses.length,
              itemBuilder: (ctx, i) {
                final course = courses[i];
                return CourseDescCard(course);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTable(List<SitCourse> courses) {
    final teachers = courses.expand((course) => course.teachers).toSet();
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
      },
      children: [
        TableRow(children: [
          i18n.course.courseCode.text(),
          courseCode.text(),
        ]),
        TableRow(children: [
          i18n.course.classCode.text(),
          courses[0].classCode.text(),
        ]),
        if (teachers.isNotEmpty)
          TableRow(children: [
            i18n.course.teacher(teachers.length).text(),
            teachers.join(", ").text(),
          ]),
      ],
    );
  }
}

class CourseDescCard extends StatelessWidget {
  final SitCourse course;

  const CourseDescCard(
    this.course, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final weekNumbers = course.weekIndices.l10n();
    final (:begin, :end) = course.calcBeginEndTimePoint();
    return ListTile(
      title: course.place.text(),
      subtitle: [
        "${Weekday.fromIndex(course.dayIndex).l10n()} ${begin.l10n(context)}–${end.l10n(context)}".text(),
        if (course.teachers.length > 1) course.teachers.join(", ").text(),
        ...weekNumbers.map((n) => n.text()),
      ].column(mas: MainAxisSize.min, caa: CrossAxisAlignment.start),
      trailing: course.teachers.length == 1 ? course.teachers.first.text() : null,
    );
  }
}
