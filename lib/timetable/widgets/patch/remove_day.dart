import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/adaptive/swipe.dart';
import 'package:sit/timetable/entity/loc.dart';
import 'package:sit/timetable/entity/pos.dart';
import 'package:sit/utils/date.dart';
import 'package:sit/utils/save.dart';

import '../../entity/patch.dart';
import '../../entity/timetable.dart';
import '../../page/preview.dart';
import '../../i18n.dart';
import '../../utils.dart';
import 'shared.dart';

class TimetableRemoveDayPatchSheet extends ConsumerStatefulWidget {
  final SitTimetable timetable;
  final TimetableRemoveDayPatch? patch;

  const TimetableRemoveDayPatchSheet({
    super.key,
    required this.timetable,
    required this.patch,
  });

  @override
  ConsumerState<TimetableRemoveDayPatchSheet> createState() => _TimetableRemoveDayPatchSheetState();
}

class _TimetableRemoveDayPatchSheetState extends ConsumerState<TimetableRemoveDayPatchSheet> {
  List<TimetableDayLoc> get initialLoc => widget.patch?.all ?? <TimetableDayLoc>[];
  late var mode = initialLoc.firstOrNull?.mode ?? TimetableDayLocMode.date;
  late var pos = mode == TimetableDayLocMode.pos ? initialLoc.map((loc) => loc.pos).toList() : <TimetablePos>[];
  late var date = mode == TimetableDayLocMode.date ? initialLoc.map((loc) => loc.date).toList() : <DateTime>[];
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
              title: TimetablePatchType.removeDay.l10n().text(),
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
              ...switch (mode) {
                TimetableDayLocMode.pos => buildPosTab(),
                TimetableDayLocMode.date => buildDateTab(),
              },
              buildAddAction(),
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

  DateTime generateUnselectedDate(DateTime initial) {
    DateTime result = initial;
    while (date.any((existing) => existing.inTheSameDay(result))) {
      result = DateTime(result.year, result.month, result.day - 1);
    }
    return result;
  }

  Widget buildAddAction() {
    return FilledButton(
      onPressed: () async {
        switch (mode) {
          case TimetableDayLocMode.pos:
            final newPos = await selectDayInTimetable(
              context: context,
              timetable: widget.timetable,
              initialPos: null,
              submitLabel: i18n.select,
            );
            if (newPos == null) return;
            setState(() {
              pos.add(newPos);
            });
            markChanged();
          case TimetableDayLocMode.date:
            final now = DateTime.now();
            final newDate = await showDatePicker(
              context: context,
              initialDate: generateUnselectedDate(ref.read(lastInitialDate)),
              currentDate: now,
              firstDate: DateTime(now.year - 4),
              lastDate: DateTime(now.year + 2),
              selectableDayPredicate: (d) => date.none((existing) => existing.inTheSameDay(d)),
            );
            if (newDate == null) return;
            ref.read(lastInitialDate.notifier).state = newDate;
            setState(() {
              date.add(newDate);
            });
            markChanged();
        }
      },
      child: i18n.add.text(),
    ).padSymmetric(h: 32, v: 16);
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
      ...pos.mapIndexed(
        (i, p) => WithSwipeAction(
          right: SwipeAction.delete(
            icon: context.icons.delete,
            action: () {
              setState(() {
                pos.removeAt(i);
              });
              markChanged();
            },
          ),
          childKey: ValueKey(p),
          child: TimetableDayLocPosSelectionTile(
            title: i18n.patch.removedDay.text(),
            timetable: widget.timetable,
            pos: p,
          ),
        ),
      )
    ];
  }

  List<Widget> buildDateTab() {
    return [
      ...date.mapIndexed(
        (i, d) => WithSwipeAction(
          right: SwipeAction.delete(
            icon: context.icons.delete,
            action: () {
              setState(() {
                date.removeAt(i);
              });
              markChanged();
            },
          ),
          childKey: ValueKey(d),
          child: TimetableDayLocDateSelectionTile(
            title: i18n.patch.removedDay.text(),
            timetable: widget.timetable,
            date: d,
          ),
        ),
      ),
    ];
  }

  Future<void> onPreview() async {
    await previewTimetable(context, timetable: buildTimetable());
  }

  void onSave() {
    context.pop(buildPatch());
  }

  SitTimetable buildTimetable() {
    final patch = buildPatch();
    final newPatches = List.of(widget.timetable.patches);
    if (patch != null) {
      newPatches.add(patch);
    }
    return widget.timetable.copyWith(
      patches: newPatches,
    );
  }

  TimetableRemoveDayPatch? buildPatch() {
    final pos = this.pos;
    final date = this.date;
    final loc = switch (mode) {
      TimetableDayLocMode.pos => pos.map((p) => TimetableDayLoc.pos(p)),
      TimetableDayLocMode.date => date.map((d) => TimetableDayLoc.date(d)),
    }
        .toList();
    return loc.isNotEmpty ? TimetableRemoveDayPatch(all: loc) : null;
  }
}
