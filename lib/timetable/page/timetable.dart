import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/widgets/fab.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/display.dart';
import '../events.dart';
import '../i18n.dart';
import '../entity/timetable.dart';
import '../init.dart';
import '../widgets/style.dart';
import '../entity/pos.dart';
import '../widgets/view.dart';

class TimetableBoardPage extends StatefulWidget {
  final SitTimetable timetable;

  const TimetableBoardPage({super.key, required this.timetable});

  @override
  State<TimetableBoardPage> createState() => _TimetableBoardPageState();
}

class _TimetableBoardPageState extends State<TimetableBoardPage> {
  final scrollController = ScrollController();

  // 模式：周课表 日课表
  late ValueNotifier<DisplayMode> $displayMode;

  // 课表元数据
  late final ValueNotifier<TimetablePos> $currentPos;

  SitTimetable get timetable => widget.timetable;

  @override
  void initState() {
    super.initState();
    final initialMode = TimetableInit.storage.lastDisplayMode ?? DisplayMode.weekly;
    $displayMode = ValueNotifier(initialMode);
    $displayMode.addListener(() {
      TimetableInit.storage.lastDisplayMode = $displayMode.value;
    });
    TimetableInit.storage.lastDisplayMode = initialMode;
    $currentPos = ValueNotifier(timetable.locate(DateTime.now()));
  }

  @override
  void dispose() {
    scrollController.dispose();
    $displayMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            $displayMode >> (ctx, mode) => $currentPos >> (ctx, pos) => i18n.weekOrderedName(number: pos.week).text(),
        actions: [
          buildSwitchViewButton(),
          buildMyTimetablesButton(),
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
          child: AutoHideFAB(
            controller: scrollController,
            child: const Icon(Icons.undo_rounded),
            onPressed: () async {
              if ($displayMode.value == DisplayMode.weekly) {
                await selectWeeklyTimetablePageToJump();
              } else {
                await selectDailyTimetablePageToJump();
              }
            },
          )),
      body: TimetableViewer(
        timetable: timetable,
        $currentPos: $currentPos,
        $displayMode: $displayMode,
      ),
    );
  }

  Widget buildSwitchViewButton() {
    return $displayMode >>
        (ctx, mode) => SegmentedButton<DisplayMode>(
              showSelectedIcon: false,
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 4)),
                visualDensity: VisualDensity.compact,
              ),
              segments: DisplayMode.values
                  .map((e) => ButtonSegment<DisplayMode>(
                        value: e,
                        label: e.l10n().text(),
                      ))
                  .toList(),
              selected: <DisplayMode>{mode},
              onSelectionChanged: (newSelection) {
                $displayMode.value = mode.toggle();
              },
            );
  }

  Widget buildMyTimetablesButton() {
    return IconButton(
      icon: const Icon(Icons.person_rounded),
      onPressed: () async {
        await context.push("/timetable/mine");
        setState(() {});
      },
    );
  }

  Future<void> selectWeeklyTimetablePageToJump() async {
    final currentWeek = $currentPos.value.week;
    final initialIndex = currentWeek - 1;
    final controller = FixedExtentScrollController(initialItem: initialIndex);
    final todayPos = timetable.locate(DateTime.now());
    final todayIndex = todayPos.week - 1;
    final week2Go = await context.showPicker(
          count: 20,
          controller: controller,
          ok: i18n.jump,
          okEnabled: (curSelected) => curSelected != initialIndex,
          actions: [
            (ctx, curSelected) => CupertinoButton(
                  onPressed: (curSelected == todayIndex)
                      ? null
                      : () {
                          controller.animateToItem(todayIndex,
                              duration: const Duration(milliseconds: 500), curve: Curves.fastEaseInToSlowEaseOut);
                        },
                  child: i18n.findToday.text(),
                )
          ],
          make: (ctx, i) {
            return Text(i18n.weekOrderedName(number: i + 1));
          },
        ) ??
        initialIndex;
    controller.dispose();
    if (week2Go != initialIndex) {
      eventBus.fire(JumpToPosEvent($currentPos.value.copyWith(week: week2Go + 1)));
      $currentPos.value = $currentPos.value.copyWith(week: week2Go + 1);
    }
  }

  Future<void> selectDailyTimetablePageToJump() async {
    final currentPos = $currentPos.value;
    final initialWeekIndex = currentPos.week - 1;
    final initialDayIndex = currentPos.day - 1;
    final $week = FixedExtentScrollController(initialItem: initialWeekIndex);
    final $day = FixedExtentScrollController(initialItem: initialDayIndex);
    final todayPos = timetable.locate(DateTime.now());
    final todayWeekIndex = todayPos.week - 1;
    final todayDayIndex = todayPos.day - 1;
    final (week2Go, day2Go) = await context.showDualPicker(
          countA: 20,
          countB: 7,
          controllerA: $week,
          controllerB: $day,
          ok: i18n.jump,
          okEnabled: (weekSelected, daySelected) => weekSelected != initialWeekIndex || daySelected != initialDayIndex,
          actions: [
            (ctx, week, day) => CupertinoButton(
                  onPressed: (week == todayWeekIndex && day == todayDayIndex)
                      ? null
                      : () {
                          $week.animateToItem(todayWeekIndex,
                              duration: const Duration(milliseconds: 500), curve: Curves.fastEaseInToSlowEaseOut);

                          $day.animateToItem(todayDayIndex,
                              duration: const Duration(milliseconds: 500), curve: Curves.fastEaseInToSlowEaseOut);
                        },
                  child: i18n.findToday.text(),
                )
          ],
          makeA: (ctx, i) => i18n.weekOrderedName(number: i + 1).text(),
          makeB: (ctx, i) => i18n.weekday(index: i).text(),
        ) ??
        (initialWeekIndex, initialDayIndex);
    $week.dispose();
    $day.dispose();
    if (week2Go != initialWeekIndex || day2Go != initialDayIndex) {
      eventBus.fire(JumpToPosEvent(TimetablePos(week: week2Go + 1, day: day2Go + 1)));
      $currentPos.value = TimetablePos(week: week2Go + 1, day: day2Go + 1);
    }
  }
}
