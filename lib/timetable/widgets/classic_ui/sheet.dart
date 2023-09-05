import 'package:flutter/material.dart';
import 'package:mimir/mini_apps/shared/entity/school.dart';

import '../../i18n.dart';
import '../../entity/entity.dart';

class Sheet extends StatelessWidget {
  final String courseCode;
  final SitTimetable timetable;

  /// 一门课可能包括实践和理论课. 由于正方不支持这种设置, 实际教务系统在处理中会把这两部分拆开, 但是它们的课程名称和课程代码是一样的
  /// classes 中存放的就是对应的所有课程, 我们在这把它称为班级.
  const Sheet({
    super.key,
    required this.courseCode,
    required this.timetable,
  });

  List<SitCourse> get classes => timetable.findAndCacheCoursesByCourseCode(courseCode);

  /// 解析课程ID对应的不同时间段的课程信息
  List<String> generateTimeString() {
    return classes.map((e) {
      final weekNumbers = e.localizedWeekNumbers();
      final fullClass = e.composeFullClassTime();
      final timeText = "${fullClass.begin} - ${fullClass.end}";
      return "$weekNumbers $timeText\n ${e.place}";
    }).toList();
  }

  Widget _buildTitle(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 5),
      child: Container(
        decoration: const BoxDecoration(),
        child: Text(stylizeCourseName(classes[0].courseName), style: titleStyle),
      ),
    );
  }

  Widget _buildItem(BuildContext context, String icon, String text) {
    final itemStyle = Theme.of(context).textTheme.bodyMedium;
    final iconImage = AssetImage('assets/timetable/$icon');

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: Row(
        children: [
          Image(image: iconImage, width: 35, height: 35),
          Container(width: 15),
          Expanded(child: Text(text, softWrap: true, style: itemStyle))
        ],
      ),
    );
  }

  List<Widget> _buildItems(BuildContext context) {
    final fixedItems = [
      _buildItem(context, 'courseId.png', i18n.detail.courseId(courseCode)),
      _buildItem(context, 'dynClassId.png', i18n.detail.classId(classes[0].classCode)),
      _buildItem(context, 'campus.png', classes[0].localizedCampusName()),
    ];
    final List<String> timeStrings = generateTimeString();
    return fixedItems + timeStrings.map((e) => _buildItem(context, 'day.png', e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildTitle(context)] + _buildItems(context),
          ),
        ),
      ),
    );
  }
}
