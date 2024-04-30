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
    final detailsColor = context.colorScheme.onSurfaceVariant;
    final detailsStyle = context.textTheme.bodyMedium?.copyWith(color: detailsColor);
    return Card.outlined(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        isThreeLine: true,
        title: patchSet.name.text(style: context.textTheme.titleLarge),
        onTap: onAdd,
        subtitle: [
          ...patchSet.patches.mapIndexed(
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
            ),
          ),
        ].column(caa: CrossAxisAlignment.start),
      ),
    );
  }
}
