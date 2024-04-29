import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/menu.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/expansion_tile.dart';
import 'package:sit/timetable/entity/patch.dart';
import '../../entity/timetable.dart';
import '../../i18n.dart';
import '../../page/preview.dart';

class TimetablePatchSetCard extends StatelessWidget {
  final TimetablePatchSet patchSet;
  final SitTimetable timetable;
  final VoidCallback? onDeleted;

  const TimetablePatchSetCard({
    super.key,
    required this.patchSet,
    required this.timetable,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      clipBehavior: Clip.hardEdge,
      child: AnimatedExpansionTile(
        leading: const Icon(Icons.dashboard_customize),
        title: patchSet.name.text(),
        trailing: buildMoreActions(),
        rotateTrailing: false,
        children: patchSet.patches
            .mapIndexed((i, p) => "${i + 1}. ${p.l10n()}"
                .text(style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant))
                .padH(16))
            .toList(),
      ),
    );
  }

  Widget buildMoreActions() {
    return PullDownMenuButton(
      itemBuilder: (context) {
        return [
          PullDownItem(
            icon: context.icons.edit,
            title: i18n.edit,
          ),
          PullDownItem(
            icon: context.icons.preview,
            title: i18n.preview,
            onTap: () async {
              await previewTimetable(context, timetable: timetable);
            },
          ),
          if (onDeleted != null)
            PullDownItem.delete(
              title: i18n.delete,
              onTap: onDeleted,
            ),
        ];
      },
    );
  }
}
