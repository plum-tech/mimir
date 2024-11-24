import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mimir/timetable/patch/page/patch_set.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/adaptive/menu.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import '../../entity/timetable.dart';
import '../../i18n.dart';
import '../../page/preview.dart';
import '../entity/patch.dart';
import 'shared.dart';

class TimetablePatchSetWidget extends StatelessWidget {
  final TimetablePatchSet patchSet;
  final bool selected;
  final Timetable? timetable;
  final VoidCallback? onDeleted;
  final VoidCallback? onUnpacked;
  final VoidCallback? onEdit;
  final bool enableQrCode;
  final bool optimizedForTouch;

  const TimetablePatchSetWidget({
    super.key,
    required this.patchSet,
    this.timetable,
    this.onDeleted,
    this.selected = false,
    this.optimizedForTouch = false,
    this.onUnpacked,
    this.enableQrCode = true,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      isThreeLine: true,
      leading: PatchIcon(
        icon: Icons.dashboard_customize,
        optimizedForTouch: optimizedForTouch,
      ),
      title: patchSet.name.text(),
      subtitle: TimetablePatchSetPatchesPreview(patchSet),
      trailing: buildMoreActions(),
      onTap: onEdit,
    );
  }

  Widget buildMoreActions() {
    final timetable = this.timetable;
    return PullDownMenuButton(
      itemBuilder: (context) {
        return [
          PullDownItem(
            icon: context.icons.preview,
            title: i18n.preview,
            onTap: () async {
              await previewTimetable(context, timetable: timetable);
            },
          ),
          if (onUnpacked != null)
            PullDownItem(
              icon: Icons.outbox,
              title: i18n.patch.unpack,
              onTap: onUnpacked,
            ),
        ];
      },
    );
  }
}
