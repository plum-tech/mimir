import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/expansion_tile.dart';

import '../entity/timetable.dart';
import '../entity/timetable_issue.dart';

extension TimetableIssuesX on List<TimetableIssue> {
  List<Widget> build(BuildContext context, SitTimetable timetable) {
    final emptyIssues = whereType<TimetableEmptyIssue>().toList();
    final cbeIssues = whereType<TimetableCbeIssue>().toList();
    final courseOverlapIssues = whereType<TimetableCourseOverlapIssue>().toList();
    return [
      if (emptyIssues.isNotEmpty)
        TimetableEmptyIssueWidget(
          issues: emptyIssues,
        ),
      if (cbeIssues.isNotEmpty)
        TimetableCbeIssueWidget(
          issues: cbeIssues,
          timetable: timetable,
        ),
      if (courseOverlapIssues.isNotEmpty)
        TimetableCourseOverlapIssueWidget(
          issues: courseOverlapIssues,
          timetable: timetable,
        ),
    ];
  }
}

class TimetableEmptyIssueWidget extends StatefulWidget {
  final List<TimetableEmptyIssue> issues;

  const TimetableEmptyIssueWidget({
    super.key,
    required this.issues,
  });

  @override
  State<TimetableEmptyIssueWidget> createState() => _TimetableEmptyIssueWidgetState();
}

class _TimetableEmptyIssueWidgetState extends State<TimetableEmptyIssueWidget> {
  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        title: "Empty timetable detected".text(),
        subtitle: "Your timetable is empty. Make sure you have not imported a wrong one.".text(),
      ),
    );
  }
}

class TimetableCbeIssueWidget extends StatefulWidget {
  final List<TimetableCbeIssue> issues;
  final SitTimetable timetable;

  const TimetableCbeIssueWidget({
    super.key,
    required this.issues,
    required this.timetable,
  });

  @override
  State<TimetableCbeIssueWidget> createState() => _TimetableCbeIssueWidgetState();
}

class _TimetableCbeIssueWidgetState extends State<TimetableCbeIssueWidget> {
  @override
  Widget build(BuildContext context) {
    final timetable = widget.timetable;
    return Card.outlined(
      clipBehavior: Clip.hardEdge,
      child: AnimatedExpansionTile(
        initiallyExpanded: true,
        title: "CBE course detected".text(),
        subtitle: "Solution: CBE course can be hidden".text(),
        children: widget.issues.map((issue) {
          final course = timetable.courses["${issue.courseKey}"]!;
          return ListTile(
            subtitle: [
              course.courseName.text(),
              course.place.text(),
            ].column(caa: CrossAxisAlignment.start),
            trailing: PlatformTextButton(
              child: "Resolve".text(),
              onPressed: () {},
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TimetableCourseOverlapIssueWidget extends StatefulWidget {
  final List<TimetableCourseOverlapIssue> issues;
  final SitTimetable timetable;

  const TimetableCourseOverlapIssueWidget({
    super.key,
    required this.issues,
    required this.timetable,
  });

  @override
  State<TimetableCourseOverlapIssueWidget> createState() => _TimetableCourseOverlapIssueWidgetState();
}

class _TimetableCourseOverlapIssueWidgetState extends State<TimetableCourseOverlapIssueWidget> {
  @override
  Widget build(BuildContext context) {
    final timetable = widget.timetable;
    return Card.outlined(
      clipBehavior: Clip.hardEdge,
      child: AnimatedExpansionTile(
        initiallyExpanded: true,
        title: "Overlap courses detected".text(),
        children: widget.issues.map((issue) {
          final courses = issue.courseKeys.map((key) => timetable.courses["$key"]).whereType<SitCourse>().toList();
          return ListTile(
            subtitle: courses.map((course) => course.courseName).join(", ").text(),
          );
        }).toList(),
      ),
    );
  }
}
