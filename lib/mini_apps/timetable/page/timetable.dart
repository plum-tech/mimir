import 'package:flutter/material.dart';
import 'package:mimir/mini_apps/timetable/events.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/course.dart';
import '../entity/entity.dart';
import '../init.dart';
import '../widgets/style.dart';
import '../entity/pos.dart';
import '../using.dart';
import '../widgets/new_ui/timetable.dart' as new_ui;
import '../widgets/classic_ui/timetable.dart' as classic_ui;

const DisplayMode defaultMode = DisplayMode.weekly;

class TimetablePage extends StatefulWidget {
  final SitTimetable timetable;

  const TimetablePage({super.key, required this.timetable});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  /// 最大周数
  /// TODO 还没用上
  // static const int maxWeekCount = 20;
  final storage = TimetableInit.timetableStorage;

  // 模式：周课表 日课表
  late ValueNotifier<DisplayMode> $displayMode;

  // 课表元数据
  late final ValueNotifier<TimetablePos> $currentPos;

  SitTimetable get timetable => widget.timetable;

  @override
  void initState() {
    super.initState();
    Log.info('Timetable init');
    final initialMode = storage.lastDisplayMode ?? DisplayMode.weekly;
    $displayMode = ValueNotifier(initialMode);
    $displayMode.addListener(() {
      storage.lastDisplayMode = $displayMode.value;
    });
    storage.lastDisplayMode = initialMode;
    $currentPos = ValueNotifier(timetable.locate(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: $displayMode >>
            (ctx, mode) =>
                $currentPos >>
                (ctx, pos) => mode == DisplayMode.weekly
                    ? i18n.weekOrderedName(number: pos.week).text()
                    : "${i18n.weekOrderedName(number: pos.week)} ${i18n.weekday(index: pos.day - 1)}".text(),
        actions: [
          buildSwitchViewButton(context),
          buildMyTimetablesButton(context),
        ],
      ),
      floatingActionButton: InkWell(
          onLongPress: () {
            final today = timetable.locate(DateTime.now());
            if ($currentPos.value != today) {
              if (TimetableStyle.of(context).useNewUI) {
                eventBus.fire(JumpToPosEvent(today));
              } else {
                $currentPos.value = today;
              }
            }
          },
          child: FloatingActionButton(
            child: const Icon(Icons.undo_rounded),
            onPressed: () async {
              if ($displayMode.value == DisplayMode.weekly) {
                await selectWeeklyTimetablePageToJump(context);
              } else {
                await selectDailyTimetablePageToJump(context);
              }
            },
          )),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext ctx) {
    if (TimetableStyle.of(ctx).useNewUI) {
      return new_ui.TimetableViewer(
        timetable: timetable,
        $currentPos: $currentPos,
        $displayMode: $displayMode,
      );
    } else {
      return classic_ui.TimetableViewer(
        timetable: timetable,
        $currentPos: $currentPos,
        $displayMode: $displayMode,
      );
    }
  }

  Widget buildSwitchViewButton(BuildContext ctx) {
    return IconButton(
      icon: const Icon(Icons.swap_horiz_rounded),
      onPressed: () {
        $displayMode.value = $displayMode.value.toggle();
      },
    );
  }

  Widget buildMyTimetablesButton(BuildContext ctx) {
    return IconButton(
        icon: const Icon(Icons.person_rounded),
        onPressed: () async {
          await Navigator.of(ctx).pushNamed(Routes.timetableMine);
        });
  }

  Future<void> selectWeeklyTimetablePageToJump(BuildContext ctx) async {
    final currentWeek = $currentPos.value.week;
    final initialIndex = currentWeek - 1;
    final controller = FixedExtentScrollController(initialItem: initialIndex);
    final todayPos = timetable.locate(DateTime.now());
    final todayIndex = todayPos.week - 1;
    final index2Go = await ctx.showPicker(
        count: 20,
        controller: controller,
        ok: i18n.jump,
        okEnabled: (curSelected) => curSelected != initialIndex,
        actions: [
          (ctx, curSelected) => i18n.findToday.text().cupertinoBtn(
              onPressed: (curSelected == todayIndex)
                  ? null
                  : () {
                      controller.animateToItem(todayIndex,
                          duration: const Duration(milliseconds: 500), curve: Curves.fastLinearToSlowEaseIn);
                    })
        ],
        make: (ctx, i) {
          return Text(i18n.weekOrderedName(number: i + 1));
        });
    controller.dispose();
    if (index2Go != null && index2Go != initialIndex) {
      if (!mounted) return;
      if (TimetableStyle.of(ctx).useNewUI) {
        eventBus.fire(JumpToPosEvent($currentPos.value.copyWith(week: index2Go + 1)));
      } else {
        $currentPos.value = $currentPos.value.copyWith(week: index2Go + 1);
      }
    }
  }

  Future<void> selectDailyTimetablePageToJump(BuildContext ctx) async {
    final currentPos = $currentPos.value;
    final initialWeekIndex = currentPos.week - 1;
    final initialDayIndex = currentPos.day - 1;
    final $week = FixedExtentScrollController(initialItem: initialWeekIndex);
    final $day = FixedExtentScrollController(initialItem: initialDayIndex);
    final todayPos = timetable.locate(DateTime.now());
    final todayWeekIndex = todayPos.week - 1;
    final todayDayIndex = todayPos.day - 1;
    final indices2Go = await ctx.showDualPicker(
        countA: 20,
        countB: 7,
        controllerA: $week,
        controllerB: $day,
        ok: i18n.jump,
        okEnabled: (weekSelected, daySelected) => weekSelected != initialWeekIndex || daySelected != initialDayIndex,
        actions: [
          (ctx, week, day) => i18n.findToday.text().cupertinoBtn(
              onPressed: (week == todayWeekIndex && day == todayDayIndex)
                  ? null
                  : () {
                      $week.animateToItem(todayWeekIndex,
                          duration: const Duration(milliseconds: 500), curve: Curves.fastLinearToSlowEaseIn);

                      $day.animateToItem(todayDayIndex,
                          duration: const Duration(milliseconds: 500), curve: Curves.fastLinearToSlowEaseIn);
                    })
        ],
        makeA: (ctx, i) => i18n.weekOrderedName(number: i + 1).text(),
        makeB: (ctx, i) => i18n.weekday(index: i).text());
    $week.dispose();
    $day.dispose();
    final week2Go = indices2Go?.a;
    final day2Go = indices2Go?.b;
    if (week2Go != null && day2Go != null && (week2Go != initialWeekIndex || day2Go != initialDayIndex)) {
      if (!mounted) return;
      if (TimetableStyle.of(ctx).useNewUI) {
        eventBus.fire(JumpToPosEvent(TimetablePos(week: week2Go + 1, day: day2Go + 1)));
      } else {
        $currentPos.value = TimetablePos(week: week2Go + 1, day: day2Go + 1);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    $displayMode.dispose();
  }
}
