import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' show join;
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/widgets/fab.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/r.dart';

import '../entity/display.dart';
import '../events.dart';
import '../i18n.dart';
import '../entity/timetable.dart';
import '../init.dart';
import '../entity/pos.dart';
import '../widgets/timetable/board.dart';
import '../widgets/timetable/weekly.dart';

class TimetableBoardPage extends StatefulWidget {
  final SitTimetableEntity timetable;

  const TimetableBoardPage({super.key, required this.timetable});

  @override
  State<TimetableBoardPage> createState() => _TimetableBoardPageState();
}

class _TimetableBoardPageState extends State<TimetableBoardPage> {
  final scrollController = ScrollController();
  final $displayMode = ValueNotifier(TimetableInit.storage.lastDisplayMode ?? DisplayMode.weekly);
  late final ValueNotifier<TimetablePos> $currentPos;

  SitTimetableEntity get timetable => widget.timetable;

  @override
  void initState() {
    super.initState();
    $displayMode.addListener(() {
      TimetableInit.storage.lastDisplayMode = $displayMode.value;
    });
    $currentPos = ValueNotifier(timetable.type.locate(DateTime.now()));
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
        title: $currentPos >> (ctx, pos) => i18n.weekOrderedName(number: pos.week).text(),
        actions: [
          buildSwitchViewButton(),
          if (kDebugMode) buildMoreActionsButton(),
          buildMyTimetablesButton(),
        ],
      ),
      floatingActionButton: InkWell(
        onLongPress: () {
          final today = timetable.type.locate(DateTime.now());
          if ($currentPos.value != today) {
            eventBus.fire(JumpToPosEvent(today));
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
        ),
      ),
      body: TimetableBoard(
        timetable: timetable,
        $displayMode: $displayMode,
        $currentPos: $currentPos,
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

  Widget buildMoreActionsButton() {
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      padding: EdgeInsets.zero,
      itemBuilder: (ctx) => <PopupMenuEntry>[
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.screenshot),
            title: i18n.screenshot.text(),
            onTap: () async {
              ctx.pop();
              await takeScreenshotOfTimetable();
            },
          ),
        ),
      ],
    );
  }

  final screenshotController = ScreenshotController();

  Future<void> takeScreenshotOfTimetable() async {
    final screenshot = await screenshotController.captureFromLongWidget(
      InheritedTheme.captureAll(
        context,
        Material(
          child: TimetableWeeklyScreenshotFilm(
            timetable: timetable,
            todayPos: timetable.type.locate(DateTime.now()),
            weekIndex: 3,
          ),
        ),
      ),
      delay: const Duration(milliseconds: 100),
      context: context,
      pixelRatio: View.of(context).devicePixelRatio,
    );
    final imgFi = await File(join(R.tmpDir, "screenshot.png")).create();
    await imgFi.writeAsBytes(screenshot);

    /// Share Plugin
    await Share.shareXFiles(
      [XFile(imgFi.path, mimeType: "image/png")],
    );
  }

  Future<void> selectWeeklyTimetablePageToJump() async {
    final currentWeek = $currentPos.value.week;
    final initialIndex = currentWeek - 1;
    final controller = FixedExtentScrollController(initialItem: initialIndex);
    final todayPos = timetable.type.locate(DateTime.now());
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
    }
  }

  Future<void> selectDailyTimetablePageToJump() async {
    final currentPos = $currentPos.value;
    final initialWeekIndex = currentPos.week - 1;
    final initialDayIndex = currentPos.day - 1;
    final $week = FixedExtentScrollController(initialItem: initialWeekIndex);
    final $day = FixedExtentScrollController(initialItem: initialDayIndex);
    final todayPos = timetable.type.locate(DateTime.now());
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
    }
  }
}
