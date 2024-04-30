import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart' hide isCupertino;
import 'package:go_router/go_router.dart';
import 'package:sit/design/adaptive/menu.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/fab.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/page/screenshot.dart';
import '../entity/display.dart';
import '../events.dart';
import '../i18n.dart';
import '../entity/timetable_entity.dart';
import '../init.dart';
import '../entity/pos.dart';
import '../utils.dart';
import '../widgets/focus.dart';
import '../widgets/timetable/board.dart';
import 'mine.dart';

class TimetableBoardPage extends StatefulWidget {
  final int id;
  final SitTimetableEntity timetable;

  const TimetableBoardPage({
    super.key,
    required this.id,
    required this.timetable,
  });

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
          buildMyTimetablesButton(),
          buildMoreActionsButton(),
        ],
      ),
      floatingActionButton: InkWell(
        onLongPress: () async {
          if ($displayMode.value == DisplayMode.weekly) {
            await selectWeeklyTimetablePageToJump();
          } else {
            await selectDailyTimetablePageToJump();
          }
        },
        child: AutoHideFAB(
          controller: scrollController,
          child: const Icon(Icons.undo_rounded),
          onPressed: () async {
            final today = timetable.type.locate(DateTime.now());
            if ($currentPos.value != today) {
              eventBus.fire(JumpToPosEvent(today));
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
    return PlatformIconButton(
      icon: Icon(context.icons.person, color: isCupertino ? context.colorScheme.primary : null),
      onPressed: () async {
        final focusMode = Settings.focusTimetable;
        if (focusMode) {
          await context.push("/me");
        } else {
          await context.push("/timetable/mine");
        }
      },
    );
  }

  Widget buildMoreActionsButton() {
    final focusMode = Settings.focusTimetable;
    return PullDownMenuButton(
      itemBuilder: (ctx) => [
        PullDownItem(
          icon: Icons.screenshot,
          title: i18n.screenshot.screenshot,
          onTap: () async {
            await takeTimetableScreenshot(
              context: context,
              timetable: timetable,
              weekIndex: $currentPos.value.weekIndex,
            );
          },
        ),
        if (focusMode)
          PullDownItem(
            icon: Icons.calendar_month_outlined,
            title: i18n.mine.title,
            onTap: () async {
              await context.push("/timetable/mine");
            },
          ),
        PullDownItem(
          icon: Icons.palette_outlined,
          title: i18n.p13n.palette.title,
          onTap: () async {
            await context.push("/timetable/p13n");
          },
        ),
        PullDownItem(
          icon: Icons.view_comfortable_outlined,
          title: i18n.p13n.cell.title,
          onTap: () async {
            await context.push("/timetable/cell-style");
          },
        ),
        PullDownItem(
          icon: Icons.image_outlined,
          title: i18n.p13n.background.title,
          onTap: () async {
            await context.push("/timetable/background");
          },
        ),
        PullDownItem(
          icon: Icons.dashboard_customize,
          title: i18n.patch.title,
          onTap: () async {
            await editTimetablePatch(
              context: ctx,
              id: widget.id,
              timetable: widget.timetable.type,
            );
          },
        ),
        if (focusMode) ...buildFocusPopupActions(context),
        const PullDownDivider(),
        PullDownSelectable(
          title: i18n.focusTimetable,
          selected: focusMode,
          onTap: () async {
            Settings.focusTimetable = !focusMode;
          },
        ),
      ],
    );
  }

  Future<void> selectWeeklyTimetablePageToJump() async {
    final initialIndex = $currentPos.value.weekIndex;
    final week2Go = await selectWeekInTimetable(
      context: context,
      timetable: timetable.type,
      initialWeekIndex: initialIndex,
      submitLabel: i18n.jump,
    );
    if (week2Go == null) return;
    if (week2Go != initialIndex) {
      eventBus.fire(JumpToPosEvent($currentPos.value.copyWith(weekIndex: week2Go)));
    }
  }

  Future<void> selectDailyTimetablePageToJump() async {
    final currentPos = $currentPos.value;
    final pos2Go = await selectDayInTimetable(
      context: context,
      timetable: timetable.type,
      initialPos: currentPos,
      submitLabel: i18n.jump,
    );
    if (pos2Go == null) return;
    if (pos2Go != currentPos) {
      eventBus.fire(JumpToPosEvent(pos2Go));
    }
  }
}
