import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:mimir/timetable/entity/timetable.dart';
import 'package:rettulf/rettulf.dart';
import '../entity/pos.dart';
import '../events.dart';
import '../i18n.dart';

class FreeDayTip extends StatelessWidget {
  final TimetablePos todayPos;
  final SitTimetable timetable;
  final int weekIndex;
  final int dayIndex;

  const FreeDayTip({
    super.key,
    required this.timetable,
    required this.todayPos,
    required this.weekIndex,
    required this.dayIndex,
  });

  @override
  Widget build(BuildContext context) {
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
      subtitle: CupertinoButton(
        onPressed: () async {
          await jumpToNearestDayWithClass(context, weekIndex, dayIndex);
        },
        child: i18n.freeTip.findNearestDayWithClass.text(),
      ),
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
    if (!ctx.mounted) return;
    await ctx.showTip(title: i18n.congratulations, desc: i18n.freeTip.termTip, ok: i18n.ok);
  }
}

class FreeWeekTip extends StatelessWidget {
  final TimetablePos todayPos;
  final SitTimetable timetable;
  final int weekIndex;

  const FreeWeekTip({
    super.key,
    required this.todayPos,
    required this.timetable,
    required this.weekIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isThisWeek = todayPos.week == (weekIndex + 1);
    final String desc;
    if (isThisWeek) {
      desc = i18n.freeTip.isThisWeekTip;
    } else {
      desc = i18n.freeTip.weekTip;
    }
    return LeavingBlank(
      icon: Icons.free_cancellation_rounded,
      desc: desc,
      subtitle: CupertinoButton(
        onPressed: () async {
          await jumpToNearestWeekWithClass(context, weekIndex);
        },
        child: i18n.freeTip.findNearestWeekWithClass.text(),
      ),
    );
  }

  /// Find the nearest week with class forward.
  /// No need to look back to passed weeks, unless there's no week after [weekIndex] that has any class.
  Future<void> jumpToNearestWeekWithClass(BuildContext ctx, int weekIndex) async {
    for (int i = weekIndex; i < timetable.weeks.length; i++) {
      final week = timetable.weeks[i];
      if (week != null) {
        eventBus.fire(JumpToPosEvent(TimetablePos(week: i + 1, day: 1)));
        return;
      }
    }
    // Now there's no class forward, so let's search backward.
    for (int i = weekIndex; 0 <= i; i--) {
      final week = timetable.weeks[i];
      if (week != null) {
        eventBus.fire(JumpToPosEvent(TimetablePos(week: i + 1, day: 1)));
        return;
      }
    }
    // WHAT? NO CLASS IN THE WHOLE TERM?
    // Alright, let's congratulate them!
    if (!ctx.mounted) return;
    await ctx.showTip(title: i18n.congratulations, desc: i18n.freeTip.termTip, ok: i18n.ok);
  }
}
