import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' show join;
import 'package:screenshot/screenshot.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/fab.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/r.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/page/screenshot.dart';

import '../entity/display.dart';
import '../events.dart';
import '../i18n.dart';
import '../entity/timetable.dart';
import '../init.dart';
import '../entity/pos.dart';
import '../widgets/style.dart';
import '../widgets/timetable/board.dart';
import 'cell_style.dart';

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
    $currentPos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: $currentPos >> (ctx, pos) => i18n.weekOrderedName(number: pos.weekIndex + 1).text(),
        actions: [
          buildSwitchViewButton(),
          buildMoreActionsButton(),
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
            title: i18n.screenshot.screenshot.text(),
            onTap: () async {
              ctx.pop();
              await takeTimetableScreenshot();
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.view_comfortable_outlined),
            title: i18n.p13n.cell.title.text(),
            onTap: () async {
              ctx.pop();
              final cellStyle = await context.show$Sheet$((ctx) => const TimetableCellStyleEditor());
              Settings.timetable.cell.cellStyle = cellStyle;
            },
          ),
        ),
      ],
    );
  }

  Future<void> takeTimetableScreenshot() async {
    final config = await context.show$Sheet$<TimetableScreenshotConfig>((ctx) => TimetableScreenshotConfigEditor(
          timetable: timetable,
          initialGrayOutTakenLessons: TimetableStyle.of(context).cell.grayOutTakenLessons,
        ));
    if (config == null) return;
    if (!mounted) return;
    var fullSize = context.mediaQuery.size;
    fullSize = Size(fullSize.width, fullSize.height);
    final screenshotController = ScreenshotController();
    final screenshot = await screenshotController.captureFromLongWidget(
      InheritedTheme.captureAll(
        context,
        MediaQuery(
          data: MediaQueryData(size: fullSize),
          child: Material(
            child: TimetableStyleProv(
              child: TimetableWeeklyScreenshotFilm(
                config: config,
                timetable: timetable,
                weekIndex: $currentPos.value.weekIndex,
                fullSize: fullSize,
              ),
            ),
          ),
        ),
      ),
      delay: const Duration(milliseconds: 100),
      context: context,
      pixelRatio: View.of(context).devicePixelRatio,
    );
    final imgFi = await File(join(R.tmpDir, "screenshot.png")).create();
    await imgFi.writeAsBytes(screenshot);

    await OpenFile.open(imgFi.path, type: "image/png");

    // await Share.shareXFiles(
    //   [XFile(imgFi.path, mimeType: "image/png")],
    // );
  }

  Future<void> selectWeeklyTimetablePageToJump() async {
    final initialIndex = $currentPos.value.weekIndex;
    final controller = FixedExtentScrollController(initialItem: initialIndex);
    final todayPos = timetable.type.locate(DateTime.now());
    final todayIndex = todayPos.weekIndex;
    final week2Go = await context.showPicker(
          count: 20,
          controller: controller,
          ok: i18n.jump,
          okEnabled: (curSelected) => curSelected != initialIndex,
          actions: [
            (ctx, curSelected) => PlatformTextButton(
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
      eventBus.fire(JumpToPosEvent($currentPos.value.copyWith(weekIndex: week2Go)));
    }
  }

  Future<void> selectDailyTimetablePageToJump() async {
    final currentPos = $currentPos.value;
    final initialWeekIndex = currentPos.weekIndex;
    final initialDayIndex = currentPos.dayIndex;
    final $week = FixedExtentScrollController(initialItem: initialWeekIndex);
    final $day = FixedExtentScrollController(initialItem: initialDayIndex);
    final todayPos = timetable.type.locate(DateTime.now());
    final todayWeekIndex = todayPos.weekIndex;
    final todayDayIndex = todayPos.dayIndex;
    final (week2Go, day2Go) = await context.showDualPicker(
          countA: 20,
          countB: 7,
          controllerA: $week,
          controllerB: $day,
          ok: i18n.jump,
          okEnabled: (weekSelected, daySelected) => weekSelected != initialWeekIndex || daySelected != initialDayIndex,
          actions: [
            (ctx, week, day) => PlatformTextButton(
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
      eventBus.fire(JumpToPosEvent(TimetablePos(weekIndex: week2Go, dayIndex: day2Go)));
    }
  }
}
