import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sit/design/dash_decoration.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/timetable/platte.dart';
import 'package:rettulf/rettulf.dart';

import '../../entity/timetable.dart';
import '../../page/screenshot.dart';
import '../slot.dart';
import 'header.dart';
import '../style.dart';
import '../../entity/pos.dart';
import '../../i18n.dart';

class TimetableWeeklyScreenshotFilm extends StatelessWidget {
  final TimetableScreenshotConfig config;
  final SitTimetableEntity timetable;
  final TimetablePos todayPos;
  final int weekIndex;
  final Size fullSize;

  const TimetableWeeklyScreenshotFilm({
    super.key,
    required this.timetable,
    required this.todayPos,
    required this.weekIndex,
    required this.fullSize,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final cellSize = Size(fullSize.width * 3 / 23, fullSize.height / 11);
    final timetableWeek = timetable.weeks[weekIndex];
    return [
      buildTitle().text(style: context.textTheme.titleLarge).padSymmetric(v: 10),
      buildSingleWeekView(
        timetableWeek,
        context: context,
        cellSize: cellSize,
        fullSize: fullSize,
      ),
    ].column();
  }

  String buildTitle() {
    final week = i18n.weekOrderedName(number: weekIndex + 1);
    final signature = config.signature;
    if (signature.isNotEmpty) {
      return "$signature $week";
    }
    return week;
  }

  Widget buildSingleWeekView(
    SitTimetableWeek timetableWeek, {
    required BuildContext context,
    required Size cellSize,
    required Size fullSize,
  }) {
    return List.generate(
      8,
      (index) {
        if (index == 0) {
          return buildLeftColumn(context, cellSize);
        } else {
          return _buildCellsByDay(context, timetableWeek.days[index - 1], cellSize);
        }
      },
    ).row();
  }

  /// 布局左侧边栏, 显示节次
  Widget buildLeftColumn(BuildContext ctx, Size cellSize) {
    final textStyle = ctx.textTheme.bodyMedium;
    final side = getBorderSide(ctx);
    final cells = <Widget>[];
    cells.add(SizedBox(
      width: cellSize.width * 0.6,
      child: const EmptyHeaderCellTextBox(),
    ));
    for (var i = 0; i < 11; i++) {
      cells.add(Container(
        decoration: BoxDecoration(
          border: Border(right: side),
        ),
        child: SizedBox.fromSize(
          size: Size(cellSize.width * 0.6, cellSize.height),
          child: (i + 1).toString().text(style: textStyle).center(),
        ),
      ));
    }
    return cells.column();
  }

  /// 构建某一天的那一列格子.
  Widget _buildCellsByDay(
    BuildContext context,
    SitTimetableDay day,
    Size cellSize,
  ) {
    final cells = <Widget>[];
    cells.add(SizedBox(
      width: cellSize.width,
      child: HeaderCell(
        weekIndex: weekIndex,
        dayIndex: day.index,
        startDate: timetable.type.startDate,
      ),
    ));
    for (int timeslot = 0; timeslot < day.timeslot2LessonSlot.length; timeslot++) {
      final lessonSlot = day.timeslot2LessonSlot[timeslot];
      if (lessonSlot.lessons.isEmpty) {
        cells.add(Container(
          decoration: DashDecoration(
            color: context.colorScheme.onBackground.withOpacity(0.3),
            strokeWidth: 0.5,
            borders: {
              if (timeslot != 0) LinePosition.top,
              if (timeslot != day.timeslot2LessonSlot.length - 1) LinePosition.bottom,
            },
          ),
          child: SizedBox(width: cellSize.width, height: cellSize.height),
        ));
      } else {
        /// TODO: Multi-layer lessonSlot
        final firstLayerLesson = lessonSlot.lessons[0];

        /// TODO: Range checking
        final course = firstLayerLesson.course;
        final cell = CourseCell(
          lesson: firstLayerLesson,
          timetable: timetable,
          course: course,
          cellSize: cellSize,
        );
        cells.add(cell.sized(w: cellSize.width, h: cellSize.height * firstLayerLesson.duration));

        /// Skip to the end
        timeslot = firstLayerLesson.endIndex;
      }
    }

    return Column(children: cells);
  }
}

class CourseCell extends StatelessWidget {
  final SitTimetableLesson lesson;
  final SitCourse course;
  final SitTimetableEntity timetable;
  final Size cellSize;

  const CourseCell({
    super.key,
    required this.lesson,
    required this.timetable,
    required this.course,
    required this.cellSize,
  });

  @override
  Widget build(BuildContext context) {
    final color = TimetableStyle.of(context)
        .platte
        .resolveColor(course)
        .byTheme(context.theme)
        .harmonizeWith(context.colorScheme.primary);
    return FilledCard(
      clip: Clip.hardEdge,
      color: color,
      margin: EdgeInsets.all(0.5.w),
      child: TimetableSlotInfo(
        course: course,
        maxLines: context.isPortrait ? 8 : 5,
      ).padOnly(t: cellSize.height * 0.2),
    );
  }
}
