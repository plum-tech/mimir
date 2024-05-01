import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/adaptive/menu.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/expansion_tile.dart';
import 'package:sit/timetable/entity/patch.dart';
import 'package:sit/timetable/page/patch/patch_set.dart';
import '../../entity/timetable.dart';
import '../../i18n.dart';
import '../../page/preview.dart';
import 'shared.dart';

class TimetablePatchSetCard extends StatelessWidget {
  final TimetablePatchSet patchSet;
  final bool selected;
  final SitTimetable? timetable;
  final VoidCallback? onDeleted;
  final VoidCallback? onUnpacked;
  final ValueChanged<TimetablePatchSet>? onChanged;
  final bool enableQrCode;
  final bool optimizedForTouch;

  const TimetablePatchSetCard({
    super.key,
    required this.patchSet,
    this.timetable,
    this.onDeleted,
    this.selected = false,
    this.optimizedForTouch = false,
    this.onUnpacked,
    this.onChanged,
    this.enableQrCode = true,
  });

  @override
  Widget build(BuildContext context) {
    final detailsColor = selected ? context.colorScheme.primary : context.colorScheme.onSurfaceVariant;
    final detailsStyle = context.textTheme.bodyMedium?.copyWith(
      color: detailsColor,
    );
    return Card.outlined(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      child: AnimatedExpansionTile(
        selected: selected,
        leading: PatchIcon(
          icon: Icons.dashboard_customize,
          optimizedForTouch: optimizedForTouch,
          inCard: false,
        ),
        title: patchSet.name.text(),
        trailing: buildMoreActions(),
        rotateTrailing: false,
        children: patchSet.patches
            .mapIndexed(
              (i, p) => RichText(
                text: TextSpan(
                  style: detailsStyle,
                  children: [
                    WidgetSpan(
                      child: Icon(
                        p.type.icon,
                        color: detailsColor,
                        size: 16,
                      ),
                    ),
                    TextSpan(text: p.l10n()),
                  ],
                ),
              ).padSymmetric(h: 16),
            )
            .toList(),
      ),
    );
  }

  Widget buildMoreActions() {
    final onChanged = this.onChanged;
    final timetable = this.timetable;
    return PullDownMenuButton(
      itemBuilder: (context) {
        return [
          if (timetable != null)
            PullDownItem(
              icon: context.icons.edit,
              title: i18n.edit,
              onTap: onChanged == null
                  ? null
                  : () async {
                      final newPatchSet = await context.showSheet<TimetablePatchSet>(
                        (ctx) => TimetablePatchSetEditorPage(
                          timetable: timetable,
                          patchSet: patchSet,
                        ),
                      );
                      if (newPatchSet == null) return;
                      onChanged(newPatchSet);
                    },
            ),
          PullDownItem(
            icon: context.icons.preview,
            title: i18n.preview,
            onTap: () async {
              await previewTimetable(context, timetable: timetable);
            },
          ),
          if (!kIsWeb && enableQrCode)
            PullDownItem(
              icon: context.icons.qrcode,
              title: i18n.shareQrCode,
              onTap: () async {
                shareTimetablePatchQrCode(context, patchSet);
              },
            ),
          if (onUnpacked != null)
            PullDownItem(
              icon: Icons.outbox,
              title: i18n.patch.unpack,
              onTap: onUnpacked,
            ),
          if (onDeleted != null)
            PullDownItem.delete(
              icon: context.icons.delete,
              title: i18n.delete,
              onTap: onDeleted,
            ),
        ];
      },
    );
  }
}
