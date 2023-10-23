import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
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
          SliverAppBar(
            floating: true,
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
    return Table(
      children: [
        TableRow(children: [
          i18n.details.courseCode.text(),
          courseCode.text(),
        ]),
        TableRow(children: [
          i18n.details.classCode.text(),
          courses[0].classCode.text(),
        ]),
        TableRow(children: [
          i18n.details.teacher.text(),
          // TODO: merge all teachers?
          courses[0].teachers.join(", ").text(),
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
    final weekNumbers = course.localizedWeekNumbers();
    final (:begin, :end) = course.calcBeginEndTimePoint();
    final timeText = "$begin–$end";
    return ListTile(
      title: "$weekNumbers $timeText".text(),
      subtitle: "${course.place} ${course.teachers.join(", ")}".text(),
    );
  }
}
