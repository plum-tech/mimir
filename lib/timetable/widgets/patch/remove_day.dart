import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/l10n/time.dart';
import 'package:sit/timetable/entity/loc.dart';
import 'package:sit/timetable/entity/timetable_entity.dart';
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
  late var mode = widget.patch?.loc.mode ?? TimetableDayLocMode.pos;
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
          ],
        ),
      ),
    );
  }

  Future<void> onPreview() async {
    await previewTimetable(context, timetable: buildTimetable());
  }

  void onSave() {
    context.pop(buildPatch());
  }

  SitTimetable buildTimetable() {
    return widget.timetable.copyWith(
      patches: List.of(widget.timetable.patches)..add(buildPatch()),
    );
  }

  TimetableRemoveDayPatch buildPatch() {
    return TimetableRemoveDayPatch(
        loc: switch (mode) {
      TimetableDayLocMode.pos => TimetableDayLoc.pos(weekIndex: 0, weekday: Weekday.monday),
      TimetableDayLocMode.date => TimetableDayLoc.date(date: DateTime.now()),
    });
  }
}
