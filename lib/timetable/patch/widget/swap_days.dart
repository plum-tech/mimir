import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/timetable/entity/loc.dart';
import 'package:mimir/utils/save.dart';

import '../../entity/timetable.dart';
import '../../page/preview.dart';
import '../../i18n.dart';
import '../entity/patch.dart';
import 'shared.dart';

class TimetableSwapDaysPatchSheet extends StatefulWidget {
  final Timetable timetable;
  final TimetableSwapDaysPatch? patch;

  const TimetableSwapDaysPatchSheet({
    super.key,
    required this.timetable,
    required this.patch,
  });

  @override
  State<TimetableSwapDaysPatchSheet> createState() => _TimetableSwapDaysPatchSheetState();
}

class _TimetableSwapDaysPatchSheetState extends State<TimetableSwapDaysPatchSheet> {
  TimetableDayLoc? get initialA => widget.patch?.a;

  TimetableDayLoc? get initialB => widget.patch?.b;
  late var mode = initialA?.mode ?? TimetableDayLocMode.date;
  late var aPos = initialA?.mode == TimetableDayLocMode.pos ? initialA?.pos : null;
  late var aDate = initialA?.mode == TimetableDayLocMode.date ? initialA?.date : null;
  late var bPos = initialB?.mode == TimetableDayLocMode.pos ? initialB?.pos : null;
  late var bDate = initialB?.mode == TimetableDayLocMode.date ? initialB?.date : null;
  var anyChanged = false;

  void markChanged() => anyChanged |= true;

  bool canSave() => buildPatch() != null;

  @override
  Widget build(BuildContext context) {
    final patch = buildPatch();
    return PromptSaveBeforeQuitScope(
      changed: anyChanged && canSave(),
      onSave: onSave,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              title: TimetablePatchType.swapDays.l10n().text(),
              actions: [
                PlatformTextButton(
                  onPressed: onPreview,
                  child: i18n.preview.text(),
                ),
                PlatformTextButton(
                  onPressed: canSave() ? onSave : null,
                  child: i18n.save.text(),
                ),
              ],
            ),
            SliverList.list(children: [
              buildMode().padSymmetric(v: 8, h: 16),
              if (patch != null && !patch.allLocInRange(widget.timetable)) const PatchOutOfRangeWarningTile(),
              ...switch (mode) {
                TimetableDayLocMode.pos => buildPosTab(),
                TimetableDayLocMode.date => buildDateTab(),
              },
              if (patch != null)
                ListTile(
                  title: patch.l10n().text(),
                )
            ]),
          ],
        ),
      ),
    );
  }

  Widget buildMode() {
    return TimetableDayLocModeSwitcher(
      selected: mode,
      onSelected: (newMode) async {
        setState(() {
          mode = newMode;
        });
      },
    );
  }

  List<Widget> buildPosTab() {
    return [
      TimetableDayLocPosSelectionTile(
        title: i18n.patch.swappedDay,
        timetable: widget.timetable,
        pos: aPos,
        onChanged: (newPos) {
          setState(() {
            aPos = newPos;
          });
          markChanged();
        },
      ),
      TimetableDayLocPosSelectionTile(
        title: i18n.patch.swappedDay,
        timetable: widget.timetable,
        pos: bPos,
        onChanged: (newPos) {
          setState(() {
            bPos = newPos;
          });
          markChanged();
        },
      ),
    ];
  }

  List<Widget> buildDateTab() {
    return [
      TimetableDayLocDateSelectionTile(
        title: i18n.patch.swappedDay,
        timetable: widget.timetable,
        date: aDate,
        onChanged: (newPos) {
          setState(() {
            aDate = newPos;
          });
          markChanged();
        },
      ),
      TimetableDayLocDateSelectionTile(
        title: i18n.patch.swappedDay,
        timetable: widget.timetable,
        date: bDate,
        onChanged: (newPos) {
          setState(() {
            bDate = newPos;
          });
          markChanged();
        },
      ),
    ];
  }

  Future<void> onPreview() async {
    await previewTimetable(context, timetable: buildTimetable());
  }

  void onSave() {
    context.pop(buildPatch());
  }

  Timetable buildTimetable() {
    final patch = buildPatch();
    final newPatches = List.of(widget.timetable.patches);
    if (patch != null) {
      newPatches.add(patch);
    }
    return widget.timetable.copyWith(
      patches: newPatches,
    );
  }

  TimetableSwapDaysPatch? buildPatch() {
    final aPos = this.aPos;
    final aDate = this.aDate;
    final bPos = this.bPos;
    final bDate = this.bDate;
    final a = switch (mode) {
      TimetableDayLocMode.pos => aPos != null ? TimetableDayLoc.pos(aPos) : null,
      TimetableDayLocMode.date => aDate != null ? TimetableDayLoc.date(aDate) : null,
    };
    final b = switch (mode) {
      TimetableDayLocMode.pos => bPos != null ? TimetableDayLoc.pos(bPos) : null,
      TimetableDayLocMode.date => bDate != null ? TimetableDayLoc.date(bDate) : null,
    };
    return a != null && b != null ? TimetableSwapDaysPatch(a: a, b: b) : null;
  }
}
