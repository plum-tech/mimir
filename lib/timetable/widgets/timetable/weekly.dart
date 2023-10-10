import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/dash_decoration.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/timetable/platte.dart';
import 'package:rettulf/rettulf.dart';

import '../../events.dart';
import '../../entity/timetable.dart';
import '../../utils.dart';
import '../free.dart';
import '../slot.dart';
import 'header.dart';
import '../style.dart';
import '../sheet.dart';
import '../../entity/pos.dart';

class WeeklyTimetable extends StatefulWidget {
  final SitTimetableEntity timetable;

  final ValueNotifier<TimetablePos> $currentPos;

  @override
  State<StatefulWidget> createState() => WeeklyTimetableState();

  const WeeklyTimetable({
    super.key,
    required this.timetable,
    required this.$currentPos,
  });
}

class WeeklyTimetableState extends State<WeeklyTimetable> {
  late PageController _pageController;
  late DateTime dateSemesterStart;
  final $cellSize = ValueNotifier(Size.zero);
  final faceIndex = 0;

  SitTimetableEntity get timetable => widget.timetable;

  TimetablePos get currentPos => widget.$currentPos.value;

  set currentPos(TimetablePos newValue) => widget.$currentPos.value = newValue;

  int page2Week(int page) => page + 1;

  int week2PageOffset(int week) => week - 1;
  late StreamSubscription<JumpToPosEvent> $jumpToPos;

  @override
  void initState() {
    super.initState();
    dateSemesterStart = timetable.type.startDate;
    _pageController = PageController(initialPage: currentPos.week - 1)
      ..addListener(() {
        setState(() {
          final page = (_pageController.page ?? 0).round();
          final newWeek = page2Week(page);
          if (newWeek != currentPos.week) {
            currentPos = currentPos.copyWith(week: newWeek);
          }
        });
      });
    $jumpToPos = eventBus.on<JumpToPosEvent>().listen((event) {
      jumpTo(event.where);
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final targetOffset = week2PageOffset(currentPos.week);
      final currentOffset = _pageController.page?.round() ?? targetOffset;
      if (currentOffset != targetOffset) {
        _pageController.jumpToPage(targetOffset);
      }
    });
  }

  @override
  void dispose() {
    $jumpToPos.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return [
      [
        const SizedBox().align(at: Alignment.center).flexible(flex: 47),
        widget.$currentPos >>
            (ctx, cur) => TimetableHeader(
                  selectedDay: 0,
                  currentWeek: cur.week,
                  startDate: timetable.type.startDate,
                ).flexible(flex: 500)
      ].row(),
      PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemCount: 20,
        itemBuilder: (BuildContext ctx, int weekIndex) {
          final todayPos = timetable.type.locate(DateTime.now());
          return TimetableOneWeekPage(
            timetable: timetable,
            todayPos: todayPos,
            weekIndex: weekIndex,
          );
        },
      ).expanded()
    ].column(mas: MainAxisSize.min, maa: MainAxisAlignment.start, caa: CrossAxisAlignment.start);
  }

  /// 跳到某一周
  void jumpTo(TimetablePos pos) {
    if (_pageController.hasClients) {
      final targetOffset = week2PageOffset(pos.week);
      final currentPos = _pageController.page ?? targetOffset;
      final distance = (targetOffset - currentPos).abs();
      _pageController.animateToPage(
        targetOffset,
        duration: calcuSwitchAnimationDuration(distance),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    }
  }
}

class TimetableOneWeekPage extends StatefulWidget {
  final SitTimetableEntity timetable;
  final TimetablePos todayPos;
  final int weekIndex;

  const TimetableOneWeekPage({
    super.key,
    required this.timetable,
    required this.todayPos,
    required this.weekIndex,
  });

  @override
  State<TimetableOneWeekPage> createState() => _TimetableOneWeekPageState();
}

class _TimetableOneWeekPageState extends State<TimetableOneWeekPage> with AutomaticKeepAliveClientMixin {
  SitTimetableEntity get timetable => widget.timetable;

  /// Cache the who page to avoid expensive rebuilding.
  Widget? _cached;

  @override
  void didChangeDependencies() {
    _cached = null;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cache = _cached;
    if (cache != null) {
      return cache;
    } else {
      final res = LayoutBuilder(
        builder: (context, box) {
          return buildPage(
            context,
            fullSize: Size(box.maxWidth, box.maxHeight),
          );
        },
      );
      _cached = res;
      return res;
    }
  }

  @override
  bool get wantKeepAlive => true;

  Widget buildPage(
    BuildContext ctx, {
    required Size fullSize,
  }) {
    // TODO: No magic number
    fullSize = Size(fullSize.width, fullSize.height * 1.5);
    final cellSize = Size(fullSize.width * 3 / 23, fullSize.height / 11);
    final weekIndex = widget.weekIndex;
    final timetableWeek = timetable.weeks[weekIndex];

    if (timetableWeek == null) {
      // free week
      return FreeWeekTip(
        todayPos: widget.todayPos,
        timetable: timetable,
        weekIndex: weekIndex,
      ).scrolled().center();
    }
    return SizedBox(
      width: fullSize.width,
      height: fullSize.height,
      child: buildSingleWeekView(
        timetableWeek,
        cellSize: cellSize,
        fullSize: fullSize,
      ),
    ).scrolled();
  }

  /// 布局左侧边栏, 显示节次
  Widget buildLeftColumn(BuildContext ctx, Size cellSize) {
    final textStyle = ctx.textTheme.bodyMedium;
    final side = getBorderSide(ctx);
    return Iterable.generate(11, (index) {
      return Container(
        decoration: BoxDecoration(
          border: Border(right: side),
        ),
        child: SizedBox.fromSize(
          size: Size(cellSize.width * 0.6, cellSize.height),
          child: (index + 1).toString().text(style: textStyle).center(),
        ),
      );
    }).toList().column();
  }

  Widget buildSingleWeekView(
    SitTimetableWeek timetableWeek, {
    required Size cellSize,
    required Size fullSize,
  }) {
    return ListView.builder(
      itemCount: 8,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      // The scrolling has been handled outside
      itemBuilder: (context, index) {
        if (index == 0) {
          return buildLeftColumn(context, cellSize);
        } else {
          return _buildCellsByDay(context, timetableWeek.days[index - 1], cellSize).center();
        }
      },
    );
  }

  /// 构建某一天的那一列格子.
  Widget _buildCellsByDay(
    BuildContext context,
    SitTimetableDay day,
    Size cellSize,
  ) {
    final cells = <Widget>[];
    for (int timeslot = 0; timeslot < day.timeslot2LessonSlot.length; timeslot++) {
      final lessonSlot = day.timeslot2LessonSlot[timeslot];
      if (lessonSlot.lessons.isEmpty) {
        cells.add(Container(
          decoration: DashDecoration(
            color: context.colorScheme.onBackground.withOpacity(0.3),
            strokeWidth: 0.5,
            borders: const {LinePosition.bottom},
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

    return SizedBox(
      width: cellSize.width,
      height: cellSize.height * 11,
      child: Column(children: cells),
    );
  }
}

class CourseCell extends StatefulWidget {
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
  State<CourseCell> createState() => _CourseCellState();
}

class _CourseCellState extends State<CourseCell> {
  final $tooltip = GlobalKey<TooltipState>(debugLabel: "tooltip");

  @override
  Widget build(BuildContext context) {
    final color = TimetableStyle.of(context)
        .platte
        .resolveColor(widget.course)
        .byTheme(context.theme)
        .harmonizeWith(context.colorScheme.primary);
    final lessons = widget.course.calcBeginEndTimePointForEachLesson();
    return Tooltip(
      key: $tooltip,
      preferBelow: false,
      triggerMode: TooltipTriggerMode.manual,
      message: lessons.map((time) => "${time.begin.toStringPrefixed0()}–${time.end.toStringPrefixed0()}").join("\n"),
      child: FilledCard(
        clip: Clip.hardEdge,
        color: color,
        margin: EdgeInsets.all(0.5.w),
        child: InkWell(
          onTap: () async {
            $tooltip.currentState?.ensureTooltipVisible();
          },
          onLongPress: () async {
            await HapticFeedback.lightImpact();
            if (!mounted) return;
            await context.show$Sheet$(
              (ctx) => TimetableCourseSheet(courseCode: widget.course.courseCode, timetable: widget.timetable),
            );
          },
          child: TimetableSlotInfo(
            course: widget.course,
            maxLines: context.isPortrait ? 8 : 5,
          ).padOnly(t: widget.cellSize.height * 0.2),
        ),
      ),
    );
  }
}
