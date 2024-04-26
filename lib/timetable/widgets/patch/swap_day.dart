import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/timetable/entity/loc.dart';
import 'package:sit/utils/save.dart';

import '../../entity/patch.dart';
import '../../entity/timetable.dart';
import '../../page/preview.dart';
import '../../i18n.dart';
import 'shared.dart';

class TimetableSwapDayPatchWidget extends StatelessWidget {
  final TimetableSwapDayPatch patch;
  final SitTimetable timetable;
  final ValueChanged<TimetableSwapDayPatch> onChanged;

  const TimetableSwapDayPatchWidget({
    super.key,
    required this.patch,
    required this.timetable,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: "Swap day".text(),
      subtitle: "Exchange ${patch.a.l10n()} with ${patch.b.l10n()}".text(),
      trailing: Icon(context.icons.edit),
      onTap: () async {
        final newPath = await context.show$Sheet$(
          (ctx) => TimetableSwapDayPatchSheet(
            timetable: timetable,
            patch: patch,
          ),
        );
        onChanged(newPath);
      },
    );
  }
}

class TimetableSwapDayPatchSheet extends StatefulWidget {
  final SitTimetable timetable;
  final TimetableSwapDayPatch? patch;

  const TimetableSwapDayPatchSheet({
    super.key,
    required this.timetable,
    required this.patch,
  });

  @override
  State<TimetableSwapDayPatchSheet> createState() => _TimetableSwapDayPatchSheetState();
}

class _TimetableSwapDayPatchSheetState extends State<TimetableSwapDayPatchSheet> {
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
    return PromptSaveBeforeQuitScope(
      canSave: anyChanged,
      onSave: onSave,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              title: "Swap day".text(),
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
        leading: Icon(Icons.output),
        title: "A position".text(),
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
        leading: Icon(Icons.input),
        title: "B position".text(),
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
        leading: Icon(Icons.output),
        title: "A date".text(),
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
        leading: Icon(Icons.input),
        title: "B date".text(),
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

  TimetableSwapDayPatch? buildPatch() {
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
    return a != null && b != null ? TimetableSwapDayPatch(a: a, b: b) : null;
  }
}
