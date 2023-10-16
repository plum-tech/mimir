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

  List<SitCourse> get classes => timetable.findAndCacheCoursesByCourseCode(courseCode);

  /// 解析课程ID对应的不同时间段的课程信息
  List<String> generateTimeString() {
    return classes.map((e) {
      final weekNumbers = e.localizedWeekNumbers();
      final (:begin, :end) = e.calcBeginEndTimePoint();
      final timeText = "$begin–$end";
      return "$weekNumbers $timeText\n ${e.place}";
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextScroll(
          classes[0].courseName,
        ),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTable(),
            const Divider(),
            ...generateTimeString().map((e) => e.text()),
          ],
        ).padSymmetric(v: 20, h: 20),
      ),
    );
  }

  Widget buildTable() {
    return Table(
      children: [
        TableRow(children: [i18n.details.courseId.text(), courseCode.text()]),
        TableRow(children: [
          i18n.details.classId.text(),
          classes[0].classCode.text(),
        ]),
      ],
    );
  }
}
