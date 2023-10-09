import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sit/design/adaptive/foundation.dart';
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
  final SitTimetable timetable;

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

  SitTimetable get timetable => widget.timetable;

  TimetablePos get currentPos => widget.$currentPos.value;

  set currentPos(TimetablePos newValue) => widget.$currentPos.value = newValue;

  int page2Week(int page) => page + 1;

  int week2PageOffset(int week) => week - 1;
  late StreamSubscription<JumpToPosEvent> $jumpToPos;

  @override
  void initState() {
    super.initState();
    dateSemesterStart = timetable.startDate;
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
                  startDate: timetable.startDate,
                ).flexible(flex: 500)
      ].row(),
      PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemCount: 20,
        itemBuilder: (BuildContext ctx, int weekIndex) {
          final todayPos = timetable.locate(DateTime.now());
          return _OneWeekPage(
            timetable: timetable,
            todayPos: todayPos,
            weekIndex: weekIndex,
            $currentPos: widget.$currentPos,
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

class _OneWeekPage extends StatefulWidget {
  final SitTimetable timetable;
  final TimetablePos todayPos;
  final ValueNotifier<TimetablePos> $currentPos;
  final int weekIndex;

  const _OneWeekPage({
    super.key,
    required this.timetable,
    required this.todayPos,
    required this.$currentPos,
    required this.weekIndex,
  });

  @override
  State<_OneWeekPage> createState() => _OneWeekPageState();
}

class _OneWeekPageState extends State<_OneWeekPage> with AutomaticKeepAliveClientMixin {
  SitTimetable get timetable => widget.timetable;

  /// Cache the who page to avoid expensive rebuilding.
  Widget? _cached;

  TimetablePos get currentPos => widget.$currentPos.value;

  set currentPos(TimetablePos newValue) => widget.$currentPos.value = newValue;

  Size? lastSize;

  @override
  void didChangeDependencies() {
    _cached = null;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant _OneWeekPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.timetable != oldWidget.timetable ||
        widget.todayPos != oldWidget.todayPos ||
        widget.weekIndex != oldWidget.weekIndex ||
        widget.$currentPos != oldWidget.$currentPos) {
      _cached = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuery.size;
    if (lastSize != size) {
      _cached = null;
      lastSize = size;
    }
    super.build(context);
    final cache = _cached;
    if (cache != null) {
      return cache;
    } else {
      final res = buildPage(context);
      _cached = res;
      return res;
    }
  }

  Widget buildPage(BuildContext ctx) {
    final weekIndex = widget.weekIndex;
    final timetableWeek = timetable.weeks[weekIndex];
    if (timetableWeek == null) {
      // free week
      return [
        buildLeftColumn(ctx).flexible(flex: 2),
        FreeWeekTip(
          todayPos: widget.todayPos,
          timetable: timetable,
          weekIndex: weekIndex,
        ).flexible(flex: 21),
      ].row(textDirection: TextDirection.ltr);
    }
    return [
      buildLeftColumn(ctx).flexible(flex: 2),
      TimetableSingleWeekView(
        timetableWeek: timetableWeek,
        timetable: timetable,
        currentWeek: weekIndex,
      ).flexible(flex: 21)
    ].row(textDirection: TextDirection.ltr).scrolled();
  }

  /// 布局左侧边栏, 显示节次
  Widget buildLeftColumn(BuildContext ctx) {
    /// 构建每一个格子
    Widget buildCell(BuildContext ctx, int index) {
      final textStyle = ctx.textTheme.bodyMedium;
      final side = getBorderSide(ctx);

      return Container(
        decoration: BoxDecoration(
          border: Border(
            top: side,
            right: side,
            left: side,
            bottom: side,
          ),
        ),
        child: (index + 1).toString().text(style: textStyle).center(),
      );
    }

    // 用 [GridView] 构造整个左侧边栏
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 11,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 22 / 23 * (1.sw) / (1.sh),
      ),
      itemBuilder: buildCell,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TimetableSingleWeekView extends StatelessWidget {
  final ScrollController? scrollController;
  final SitTimetableWeek timetableWeek;
  final SitTimetable timetable;
  final int currentWeek;

  const TimetableSingleWeekView({
    super.key,
    required this.timetableWeek,
    required this.timetable,
    required this.currentWeek,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final rawColumnSize = MediaQuery.of(context).size;
    final cellSize = Size(rawColumnSize.width * 3 / 23, rawColumnSize.height / 11);
    return SizedBox(
      width: rawColumnSize.width * 7,
      height: rawColumnSize.height,
      child: ListView.builder(
        itemCount: 7,
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        // The scrolling has been handled outside
        itemBuilder: (BuildContext context, int index) =>
            _buildCellsByDay(context, timetableWeek.days[index], cellSize).center(),
      ),
    );
  }

  /// 构建某一天的那一列格子.
  Widget _buildCellsByDay(BuildContext context, SitTimetableDay day, Size cellSize) {
    final cells = <Widget>[];
    for (int timeslot = 0; timeslot < day.timeslots2Lessons.length; timeslot++) {
      final lessons = day.timeslots2Lessons[timeslot];
      if (lessons.isEmpty) {
        cells.add(SizedBox(width: cellSize.width, height: cellSize.height).sized());
      } else {
        /// TODO: Multi-layer lessons
        final firstLayerLesson = lessons[0];

        /// TODO: Range checking
        final course = timetable.courseKey2Entity[firstLayerLesson.courseKey];
        final cell = CourseCell(
          lesson: firstLayerLesson,
          timetable: timetable,
          course: course,
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
  final SitTimetable timetable;

  const CourseCell({
    super.key,
    required this.lesson,
    required this.timetable,
    required this.course,
  });

  @override
  State<CourseCell> createState() => _CourseCellState();
}

class _CourseCellState extends State<CourseCell> {
  final $tooltip = GlobalKey<TooltipState>(debugLabel: "tooltip");

  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuery.size;
    final color = TimetableStyle.of(context)
        .platte
        .resolveColor(widget.course)
        .byTheme(context.theme)
        .harmonizeWith(context.colorScheme.primary);
    final padding = context.isPortrait ? size.height / 40 : size.height / 80;
    final (:begin, :end) = widget.course.calcBeginEndTimepoint();
    return Tooltip(
      key: $tooltip,
      preferBelow: false,
      triggerMode: TooltipTriggerMode.manual,
      message: "${begin.toStringPrefixed0()}–${end.toStringPrefixed0()}",
      child: FilledCard(
        clip: Clip.hardEdge,
        color: color,
        margin: EdgeInsets.all(0.5.w),
        child: InkWell(
          onTap: () async {
            $tooltip.currentState?.ensureTooltipVisible();
          },
          onLongPress: () async {
            await context.show$Sheet$(
              (ctx) => TimetableCourseSheet(courseCode: widget.course.courseCode, timetable: widget.timetable),
            );
          },
          child: TimetableSlotInfo(
            course: widget.course,
            maxLines: context.isPortrait ? 8 : 5,
          ).padOnly(t: padding),
        ),
      ),
    );
  }
}
