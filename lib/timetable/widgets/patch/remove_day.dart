import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/timetable/entity/loc.dart';
import 'package:sit/timetable/utils.dart';
import 'package:sit/utils/save.dart';

import '../../entity/patch.dart';
import '../../entity/timetable.dart';
import '../../page/preview.dart';
import '../../i18n.dart';

class TimetableRemoveDayPatchWidget extends StatelessWidget {
  final TimetableRemoveDayPatch patch;

  const TimetableRemoveDayPatchWidget({
    super.key,
    required this.patch,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: ListTile(
        title: "Remove day".text(),
        subtitle: patch.loc.toString().text(),
      ),
    );
  }
}

class TimetableRemoveDayPatchSheet extends StatefulWidget {
  final SitTimetable timetable;
  final TimetableRemoveDayPatch? patch;

  const TimetableRemoveDayPatchSheet({
    super.key,
    required this.timetable,
    required this.patch,
  });

  @override
  State<TimetableRemoveDayPatchSheet> createState() => _TimetableRemoveDayPatchSheetState();
}

class _TimetableRemoveDayPatchSheetState extends State<TimetableRemoveDayPatchSheet> {
  TimetableDayLoc? get initialLoc => widget.patch?.loc;
  late var mode = initialLoc?.mode ?? TimetableDayLocMode.pos;
  late var pos = initialLoc?.mode == TimetableDayLocMode.pos ? initialLoc?.pos : null;
  late var date = initialLoc?.mode == TimetableDayLocMode.date ? initialLoc?.date : null;
  var anyChanged = false;

  void markChanged() => anyChanged |= true;

  @override
  Widget build(BuildContext context) {
    return PromptSaveBeforeQuitScope(
      canSave: anyChanged,
      onSave: onSave,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              title: "Remove day".text(),
              actions: [
                PlatformTextButton(
                  onPressed: onPreview,
                  child: i18n.preview.text(),
                ),
                PlatformTextButton(
                  onPressed: onSave,
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
            ]),
          ],
        ),
      ),
    );
  }

  Widget buildMode() {
    return SegmentedButton<TimetableDayLocMode>(
      segments: TimetableDayLocMode.values
          .map((e) => ButtonSegment<TimetableDayLocMode>(
                value: e,
                label: e.l10n().text(),
              ))
          .toList(),
      selected: <TimetableDayLocMode>{mode},
      onSelectionChanged: (newSelection) async {
        setState(() {
          mode = newSelection.first;
        });
      },
    );
  }

  List<Widget> buildPosTab() {
    final pos = this.pos;
    return [
      ListTile(
        leading: const Icon(Icons.alarm),
        title: "Position to remove".text(),
        subtitle: pos == null ? "Not set".text() : pos.l10n().text(),
        trailing: FilledButton(
          child: i18n.select.text(),
          onPressed: () async {
            final newPos = await selectDayInTimetable(
              context: context,
              timetable: widget.timetable,
              initialPos: pos,
              submitLabel: i18n.select,
            );
            if (newPos == null) return;
            setState(() {
              this.pos = newPos;
            });
          },
        ),
      )
    ];
  }

  List<Widget> buildDateTab() {
    final date = this.date;
    return [
      ListTile(
        leading: const Icon(Icons.alarm),
        title: "Date to remove".text(),
        subtitle: date == null ? "Not set".text() : context.formatYmdText(date).text(),
        trailing: FilledButton(
          child: i18n.select.text(),
          onPressed: () async {
            final now = DateTime.now();
            final newDate = await showDatePicker(
              context: context,
              initialDate: date ?? now,
              currentDate: now,
              firstDate: DateTime(now.year - 4),
              lastDate: DateTime(now.year + 2),
            );
            if (newDate != null) {
              setState(() {
                this.date = newDate;
              });
            }
          },
        ),
      )
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
      TimetableDayLocMode.pos => pos != null ? TimetableDayLoc.pos(pos) : null,
      TimetableDayLocMode.date => date != null ? TimetableDayLoc.date(date) : null,
    };
    return loc != null ? TimetableRemoveDayPatch(loc: loc) : null;
  }
}
