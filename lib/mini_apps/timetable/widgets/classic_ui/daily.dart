import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rettulf/rettulf.dart';

import '../../entity/entity.dart';
import '../../using.dart';
import '../../utils.dart';
import 'header.dart';
import '../style.dart';
import 'sheet.dart';
import '../../entity/pos.dart';

class DailyTimetable extends StatefulWidget {
  final SitTimetable timetable;
  final ValueNotifier<TimetablePos> $currentPos;

  @override
  State<StatefulWidget> createState() => DailyTimetableState();

  const DailyTimetable({
    super.key,
    required this.timetable,
    required this.$currentPos,
  });
}

class DailyTimetableState extends State<DailyTimetable> {
  SitTimetable get timetable => widget.timetable;

  TimetablePos get currentPos => widget.$currentPos.value;

  set currentPos(TimetablePos newValue) => widget.$currentPos.value = newValue;

  /// 翻页控制
  late PageController _pageController;

  int pos2PageOffset(TimetablePos pos) => (pos.week - 1) * 7 + pos.day - 1;

  TimetablePos page2Pos(int page) {
    final week = page ~/ 7 + 1;
    final day = page % 7 + 1;
    return TimetablePos(week: week, day: day);
  }

  TimetablePos? _lastPos;
  bool isJumping = false;

  @override
  void initState() {
    super.initState();
    final pos = timetable.locate(DateTime.now());
    _pageController = PageController(initialPage: pos2PageOffset(pos))..addListener(onPageChange);
    widget.$currentPos.addListener(() {
      final curPos = widget.$currentPos.value;
      if (_lastPos != curPos) {
        jumpTo(curPos);
        _lastPos = curPos;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final targetOffset = pos2PageOffset(currentPos);
      final currentOffset = _pageController.page?.round() ?? targetOffset;
      if (currentOffset != targetOffset) {
        _pageController.jumpToPage(targetOffset);
      }
    });
    final side = getBorderSide(context);
    return [
      widget.$currentPos >>
          (ctx, cur) => TimetableHeader(
                selectedDay: cur.day,
                currentWeek: cur.week,
                startDate: timetable.startDate,
                onDayTap: (selectedDay) {
                  currentPos = TimetablePos(week: cur.week, day: selectedDay);
                },
              )
                  .container(decoration: BoxDecoration(border: Border(top: side, bottom: side, right: side)))
                  .flexible(flex: 2),
      NotificationListener<ScrollNotification>(
          onNotification: (e) {
            if (e is ScrollEndNotification) {
              isJumping = false;
            }
            return false;
          },
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: 20 * 7,
            itemBuilder: (_, int index) {
              int weekIndex = index ~/ 7;
              int dayIndex = index % 7;
              final todayPos = timetable.locate(DateTime.now());
              return _OneDayPage(
                timetable: timetable,
                todayPos: todayPos,
                weekIndex: weekIndex,
                dayIndex: dayIndex,
                $currentPos: widget.$currentPos,
              );
            },
          )).flexible(flex: 10)
    ].column();
  }

  void onPageChange() {
    if (!isJumping) {
      setState(() {
        final page = (_pageController.page ?? 0).round();
        final newPos = page2Pos(page);
        if (currentPos != newPos) {
          currentPos = newPos;
        }
      });
    }
  }

  /// 跳转到指定星期与天
  void jumpTo(TimetablePos pos) {
    if (_pageController.hasClients) {
      final targetOffset = pos2PageOffset(pos);
      final currentPos = _pageController.page ?? targetOffset;
      final distance = (targetOffset - currentPos).abs();
      _pageController.animateToPage(
        targetOffset,
        duration: calcuSwitchAnimationDuration(distance),
        curve: Curves.fastLinearToSlowEaseIn,
      );
      isJumping = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}

class _OneDayPage extends StatefulWidget {
  final SitTimetable timetable;
  final TimetablePos todayPos;
  final ValueNotifier<TimetablePos> $currentPos;
  final int weekIndex;
  final int dayIndex;

  const _OneDayPage({
    super.key,
    required this.timetable,
    required this.todayPos,
    required this.$currentPos,
    required this.weekIndex,
    required this.dayIndex,
  });

  @override
  State<_OneDayPage> createState() => _OneDayPageState();
}

class _OneDayPageState extends State<_OneDayPage> with AutomaticKeepAliveClientMixin {
  SitTimetable get timetable => widget.timetable;

  TimetablePos get currentPos => widget.$currentPos.value;

  set currentPos(TimetablePos newValue) => widget.$currentPos.value = newValue;

  /// Cache the who page to avoid expensive rebuilding.
  Widget? _cached;

  Size? lastSize;

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
    int weekIndex = widget.weekIndex;
    int dayIndex = widget.dayIndex;
    final week = timetable.weeks[weekIndex];
    if (week == null) {
      return _buildFreeDayTip(ctx, weekIndex, dayIndex);
    } else {
      final day = week.days[dayIndex];
      final lessonsInDay = day.browseUniqueLessonsAt(layer: 0).toList();
      if (lessonsInDay.isEmpty) {
        return _buildFreeDayTip(ctx, weekIndex, dayIndex);
      } else {
        return ListView.builder(
          controller: ScrollController(),
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          itemCount: lessonsInDay.length,
          itemBuilder: (ctx, indexOfLessons) {
            final lesson = lessonsInDay[indexOfLessons];
            final course = timetable.courseKey2Entity[lesson.courseKey];
            return LessonBlock(
              lesson: lesson,
              course: course,
              timetable: timetable,
            );
          },
        );
      }
    }
  }

  Widget _buildFreeDayTip(BuildContext ctx, int weekIndex, int dayIndex) {
    final todayPos = widget.todayPos;
    final isToday = todayPos.week == weekIndex + 1 && todayPos.day == dayIndex + 1;
    final String desc;
    if (isToday) {
      desc = i18n.freeTip.isTodayTip;
    } else {
      desc = i18n.freeTip.dayTip;
    }
    return LeavingBlank(
      icon: Icons.free_cancellation_rounded,
      desc: desc,
      subtitle: buildJumpToNearestDayWithClassBtn(ctx, weekIndex, dayIndex),
    );
  }

  Widget buildJumpToNearestDayWithClassBtn(BuildContext ctx, int weekIndex, int dayIndex) {
    return CupertinoButton(
      onPressed: () async {
        await jumpToNearestDayWithClass(ctx, weekIndex, dayIndex);
      },
      child: i18n.freeTip.findNearestDayWithClass.text(),
    );
  }

  /// Find the nearest day with class forward.
  /// No need to look back to passed days, unless there's no day after [weekIndex] and [dayIndex] that has any class.
  Future<void> jumpToNearestDayWithClass(BuildContext ctx, int weekIndex, int dayIndex) async {
    for (int i = weekIndex; i < timetable.weeks.length; i++) {
      final week = timetable.weeks[i];
      if (week != null) {
        final dayIndexStart = weekIndex == i ? dayIndex : 0;
        for (int j = dayIndexStart; j < week.days.length; j++) {
          final day = week.days[j];
          if (day.hasAnyLesson()) {
            currentPos = TimetablePos(week: i + 1, day: j + 1);
            return;
          }
        }
      }
    }
    // Now there's no class forward, so let's search backward.
    for (int i = weekIndex; 0 <= i; i--) {
      final week = timetable.weeks[i];
      if (week != null) {
        final dayIndexStart = weekIndex == i ? dayIndex : week.days.length - 1;
        for (int j = dayIndexStart; 0 <= j; j--) {
          final day = week.days[j];
          if (day.hasAnyLesson()) {
            currentPos = TimetablePos(week: i + 1, day: j + 1);
            return;
          }
        }
      }
    }
    // WHAT? NO CLASS IN THE WHOLE TERM?
    // Alright, let's congratulate them!
    if (!mounted) return;
    await ctx.showTip(title: i18n.congratulations, desc: i18n.freeTip.termTip, ok: i18n.ok);
  }

  @override
  bool get wantKeepAlive => true;
}

class LessonBlock extends StatefulWidget {
  final SitTimetableLesson lesson;
  final SitCourse course;
  final SitTimetable timetable;

  const LessonBlock({
    super.key,
    required this.lesson,
    required this.course,
    required this.timetable,
  });

  @override
  State<LessonBlock> createState() => _LessonBlockState();
}

class _LessonBlockState extends State<LessonBlock> {
  static const iconSize = 45.0;

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final Widget courseIcon = Image.asset(
      CourseCategory.iconPathOf(iconName: course.iconName),
      width: iconSize,
      height: iconSize,
    );
    final timetable = course.buildingTimetable;
    final classBegin = timetable[widget.lesson.startIndex].begin;
    final classEnd = timetable[widget.lesson.endIndex].end;
    final time = "$classBegin - $classEnd";
    final duration = course.duration(basedOn: widget.lesson);
    final colors = TimetableStyle.of(context).colors;
    final color = colors[course.courseCode.hashCode.abs() % colors.length].byTheme(context.theme);
    return Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(8.0.w)),
          boxShadow: [
            BoxShadow(
              color: Colors.black87.withOpacity(0.5),
              offset: const Offset(1.5, 1.5),
              blurRadius: 3,
            )
          ],
        ),
        child: ListTile(
          leading: courseIcon,
          title: Text(stylizeCourseName(course.courseName)),
          trailing: [
            Text(formatPlace(course.place), softWrap: true, overflow: TextOverflow.ellipsis),
            duration.localized().text(softWrap: true),
          ].column(),
          subtitle: [
            time.text(style: const TextStyle(fontWeight: FontWeight.bold), softWrap: true),
            course.teachers.join(', ').text(),
            course.localizedWeekNumbers().text(),
          ].column(caa: CrossAxisAlignment.start),
        ).on(tap: () async {
          if (!mounted) return;
          await context.showSheet((ctx) => Sheet(courseCode: course.courseCode, timetable: widget.timetable));
        }));
  }
}
