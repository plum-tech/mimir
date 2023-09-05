import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mimir/design/colors.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:mimir/design/widgets/dialog.dart';
import 'package:mimir/mini_apps/shared/entity/school.dart';
import 'package:rettulf/rettulf.dart';

import '../../i18n.dart';
import '../../entity/entity.dart';
import '../../events.dart';
import '../../utils.dart';
import '../style.dart';
import '../../entity/pos.dart';
import 'shared.dart';

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

  late StreamSubscription<JumpToPosEvent> $jumpToPos;

  @override
  void initState() {
    super.initState();
    final pos = timetable.locate(DateTime.now());
    _pageController = PageController(initialPage: pos2PageOffset(pos))..addListener(onPageChange);
    $jumpToPos = eventBus.on<JumpToPosEvent>().listen((event) {
      jumpTo(event.where);
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final targetOffset = pos2PageOffset(currentPos);
      final currentOffset = _pageController.page?.round() ?? targetOffset;
      if (currentOffset != targetOffset) {
        _pageController.jumpToPage(targetOffset);
      }
    });
    return PageView.builder(
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
        );
      },
    );
  }

  void onPageChange() {
    setState(() {
      final page = (_pageController.page ?? 0).round();
      final newPos = page2Pos(page);
      if (currentPos != newPos) {
        currentPos = newPos;
      }
    });
  }

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
    }
  }
}

class _OneDayPage extends StatefulWidget {
  final SitTimetable timetable;
  final TimetablePos todayPos;
  final int weekIndex;
  final int dayIndex;

  const _OneDayPage({
    super.key,
    required this.timetable,
    required this.todayPos,
    required this.weekIndex,
    required this.dayIndex,
  });

  @override
  State<_OneDayPage> createState() => _OneDayPageState();
}

class _OneDayPageState extends State<_OneDayPage> with AutomaticKeepAliveClientMixin {
  SitTimetable get timetable => widget.timetable;

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
      return [
        const SizedBox(height: 60),
        _buildFreeDayTip(ctx, weekIndex, dayIndex).expanded(),
      ].column();
    } else {
      final day = week.days[dayIndex];
      if (!day.hasAnyLesson()) {
        return [
          const SizedBox(height: 60),
          _buildFreeDayTip(ctx, weekIndex, dayIndex).expanded(),
        ].column();
      } else {
        final slotCount = day.timeslots2Lessons.length;
        final builder = _RowBuilder();
        builder.setup();
        for (int timeslot = 0; timeslot < slotCount; timeslot++) {
          builder.add(timeslot, buildLessonsInTimeslot(ctx, day.timeslots2Lessons[timeslot], timeslot));
        }
        // Since the course list is small, no need to use [ListView.builder].
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: builder.build(),
        );
      }
    }
  }

  Widget? buildLessonsInTimeslot(BuildContext ctx, List<SitTimetableLesson> lessonsInSlot, int timeslot) {
    if (lessonsInSlot.isEmpty) {
      return null;
    } else if (lessonsInSlot.length == 1) {
      final lesson = lessonsInSlot[0];
      return timetable.buildSingleLesson(ctx, lesson, timeslot);
    } else {
      return LessonOverlapGroup(lessonsInSlot, timeslot, timetable);
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
            eventBus.fire(JumpToPosEvent(TimetablePos(week: i + 1, day: j + 1)));
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
            eventBus.fire(JumpToPosEvent(TimetablePos(week: i + 1, day: j + 1)));
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

class LessonCard extends StatefulWidget {
  final SitTimetableLesson lesson;
  final SitCourse course;
  final List<SitCourse> courseKey2Entity;
  final Color color;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.course,
    required this.courseKey2Entity,
    required this.color,
  });

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  static const iconSize = 45.0;

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final Widget courseIcon = Image.asset(
      CourseCategory.iconPathOf(iconName: course.iconName),
      width: iconSize,
      height: iconSize,
    );
    return ListTile(
      leading: courseIcon,
      title: AutoSizeText(
        stylizeCourseName(course.courseName),
        maxLines: 1,
      ),
      subtitle: [
        Text(formatPlace(course.place), softWrap: true, overflow: TextOverflow.ellipsis),
        course.teachers.join(', ').text(),
      ].column(caa: CrossAxisAlignment.start),
    ).inCard(
      margin: const EdgeInsets.all(8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      clip: Clip.antiAlias,
      elevation: 10,
      color: widget.color,
    );
  }
}

extension _LessonCardEx on SitTimetable {
  Widget buildSingleLesson(BuildContext ctx, SitTimetableLesson lesson, int timeslot) {
    final colors = TimetableStyle.of(ctx).colors;
    final course = courseKey2Entity[lesson.courseKey];
    final color = colors[course.courseCode.hashCode.abs() % colors.length].byTheme(ctx.theme);
    final classTime = course.buildingTimetable[timeslot];
    return [
      _buildClassTimeCard(color, classTime),
      LessonCard(
        lesson: lesson,
        course: course,
        courseKey2Entity: courseKey2Entity,
        color: color,
      ).expanded()
    ].row();
  }
}

Widget _buildClassTimeCard(Color color, ClassTime classTime) {
  return ElevatedText(
    color: color,
    margin: 10,
    elevation: 15,
    child: [
      classTime.begin.toStringPrefixed0().text(style: const TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5.h),
      classTime.end.toStringPrefixed0().text(),
    ].column(),
  );
}

class LessonOverlapGroup extends StatelessWidget {
  final List<SitTimetableLesson> lessonsInSlot;
  final int timeslot;
  final SitTimetable timetable;

  const LessonOverlapGroup(this.lessonsInSlot, this.timeslot, this.timetable, {super.key});

  @override
  Widget build(BuildContext context) {
    if (lessonsInSlot.isEmpty) return const SizedBox();
    final List<Widget> all = [];
    ClassTime? classTime;
    final colors = TimetableStyle.of(context).colors;
    for (int lessonIndex = 0; lessonIndex < lessonsInSlot.length; lessonIndex++) {
      final lesson = lessonsInSlot[lessonIndex];
      final course = timetable.courseKey2Entity[lesson.courseKey];
      final color = colors[course.courseCode.hashCode.abs() % colors.length].byTheme(context.theme);
      classTime = course.buildingTimetable[timeslot];
      final row = LessonCard(
        lesson: lesson,
        course: course,
        courseKey2Entity: timetable.courseKey2Entity,
        color: color,
      );
      all.add(row);
    }
    // [classTime] must be nonnull.
    return [
      _buildClassTimeCard(colors[0].byTheme(context.theme), classTime!),
      all.column().expanded(),
    ].row().padAll(3).inCard();
  }
}

enum _RowBuilderState {
  row,
  divider,
  none;
}

class _RowBuilder {
  final List<Widget> _rows = [];
  _RowBuilderState lastAdded = _RowBuilderState.none;

  void add(int index, Widget? row) {
    // WOW! MEAL TIME!
    // For each four classes, there's a meal.
    if (index != 0 && index % 4 == 0 && lastAdded != _RowBuilderState.divider) {
      _rows.add(const Divider(thickness: 2));
      lastAdded = _RowBuilderState.divider;
    }
    if (row != null) {
      _rows.add(row);
      lastAdded = _RowBuilderState.row;
    }
  }

  void setup() {
    // Leave the room for header.
    _rows.add(const SizedBox(height: 60));
  }

  List<Widget> build() {
    // Remove surplus dividers.
    for (int i = _rows.length - 1; 0 <= i; i--) {
      if (_rows[i] is Divider) {
        _rows.removeLast();
      } else {
        break;
      }
    }
    return _rows;
  }
}
