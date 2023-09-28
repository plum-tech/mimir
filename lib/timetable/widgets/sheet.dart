import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../i18n.dart';
import '../entity/timetable.dart';

class TimetableCourseSheet extends StatelessWidget {
  final String courseCode;
  final SitTimetable timetable;

  /// 一门课可能包括实践和理论课. 由于正方不支持这种设置, 实际教务系统在处理中会把这两部分拆开, 但是它们的课程名称和课程代码是一样的
  /// classes 中存放的就是对应的所有课程, 我们在这把它称为班级.
  const TimetableCourseSheet({
    super.key,
    required this.courseCode,
    required this.timetable,
  });

  List<SitCourse> get classes => timetable.findAndCacheCoursesByCourseCode(courseCode);

  /// 解析课程ID对应的不同时间段的课程信息
  List<String> generateTimeString() {
    return classes.map((e) {
      final weekNumbers = e.localizedWeekNumbers();
      final (:begin, :end) = e.calcBeginEndTimepoint();
      final timeText = "$begin–$end";
      return "$weekNumbers $timeText\n ${e.place}";
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(classes[0].courseName, style: context.textTheme.titleLarge),
          const Divider(),
          buildTable(),
          const Divider(),
          ...generateTimeString().map((e) => e.text()),
        ],
      ).padSymmetric(v: 20, h: 20),
    );
  }

  Widget buildTable() {
    return Table(
      children: [
        TableRow(children: [
          i18n.detail.courseId.text(),
          courseCode.text()
        ]),
        TableRow(children: [
          i18n.detail.classId.text(),
          classes[0].classCode.text(),
        ]),
      ],
    );
  }
}
