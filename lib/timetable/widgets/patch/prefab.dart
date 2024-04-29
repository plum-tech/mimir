import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/timetable/entity/patch.dart';

class TimetablePatchSetGalleryCard extends StatelessWidget {
  final TimetablePatchSet patchSet;
  final VoidCallback onAdd;

  const TimetablePatchSetGalleryCard({
    super.key,
    required this.patchSet,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        isThreeLine: true,
        title: patchSet.name.text(style: context.textTheme.titleLarge?.copyWith(color: context.colorScheme.onSurface)),
        onTap: onAdd,
        subtitle: [
          ...patchSet.patches.mapIndexed((i, p) => "${i + 1}. ${p.l10n()}".text()),
        ].column(caa: CrossAxisAlignment.start),
      ),
    );
  }
}
