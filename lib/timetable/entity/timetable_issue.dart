import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/l10n/time.dart';
import 'package:statistics/statistics.dart';

import 'timetable.dart';
import 'timetable_entity.dart';

sealed class TimetableIssue {
  Widget build(BuildContext context, SitTimetable timetable);
}

class TimetableEmptyIssue implements TimetableIssue {
  const TimetableEmptyIssue();

  @override
  Widget build(BuildContext context, SitTimetable timetable) {
    return Card.outlined(
      child: ListTile(
        title: "Empty timetable detected".text(),
        subtitle: "Your timetable is empty. Make sure you have not imported a wrong one.".text(),
      ),
    );
  }
}

/// Credit by Examination
class TimetableCbeIssue implements TimetableIssue {
  final int courseKey;

  const TimetableCbeIssue({
    required this.courseKey,
  });

  static bool detectCbe(SitCourse course) {
    if (course.courseName.contains("自修")) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context, SitTimetable timetable) {
    final course = timetable.courses["$courseKey"]!;
    return Card.outlined(
      child: ListTile(
        leading: Tooltip(
          message: "CBE course can be hidden",
          triggerMode: TooltipTriggerMode.tap,
          child: Icon(context.icons.info),
        ),
        title: "CBE course detected".text(),
        subtitle: [
          course.courseName.text(),
          course.place.text(),
        ].column(caa: CrossAxisAlignment.start),
        trailing: PlatformTextButton(
          child: "Resolve".text(),
          onPressed: () {

          },
        ),
      ),
    );
  }
}

class TimetableCourseOverlapIssue implements TimetableIssue {
  final List<int> courseKeys;
  final int weekIndex;
  final Weekday weekday;
  final ({int start, int end}) timeslots;

  const TimetableCourseOverlapIssue({
    required this.courseKeys,
    required this.weekIndex,
    required this.weekday,
    required this.timeslots,
  });

  @override
  Widget build(BuildContext context, SitTimetable timetable) {
    final courses = courseKeys.map((key) => timetable.courses["$key"]).whereType<SitCourse>().toList();
    return Card.outlined(
      child: ListTile(
        title: "Overlap courses detected".text(),
        subtitle: courses.map((course) => course.courseName).join(", ").text(),
      ),
    );
  }

  bool isSameOne(TimetableCourseOverlapIssue other) {
    if (courseKeys.toSet().equalsElements(other.courseKeys.toSet())) {
      return true;
    }
    return false;
  }
}

extension SitTimetable4IssueX on SitTimetable {
  List<TimetableIssue> inspect() {
    final issues = <TimetableIssue>[];
    // check if empty
    if (courses.isEmpty) {
      issues.add(const TimetableEmptyIssue());
    }

    // check if any cbe
    for (final course in courses.values) {
      if (!course.hidden && TimetableCbeIssue.detectCbe(course)) {
        issues.add(TimetableCbeIssue(
          courseKey: course.courseKey,
        ));
      }
    }

    // TODO: finish overlap issue inspection
    final overlaps = <TimetableCourseOverlapIssue>[];
    final entity = resolve();
    for (final week in entity.weeks) {
      for (final day in week.days) {
        for (var timeslot = 0; timeslot < day.timeslot2LessonSlot.length; timeslot++) {
          final lessonSlot = day.timeslot2LessonSlot[timeslot];
          if (lessonSlot.lessons.length >= 2) {
            final issue = TimetableCourseOverlapIssue(
              courseKeys: lessonSlot.lessons.map((l) => l.course.courseKey).toList(),
              weekIndex: week.index,
              weekday: Weekday.values[day.index],
              timeslots: (start: timeslot, end: timeslot),
            );
            if (overlaps.every((overlap) => !overlap.isSameOne(issue))) {
              overlaps.add(issue);
            }
          }
        }
      }
    }
    issues.addAll(overlaps);
    return issues;
  }
}
