import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/timetable/entity/patch.dart';

class TimetablePatchSetCard extends StatelessWidget {
  final TimetablePatchSet patchSet;
  final VoidCallback onAdd;

  const TimetablePatchSetCard({
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
        title: patchSet.name.text(),
        trailing: PlatformIconButton(
          icon: Icon(context.icons.add),
          onPressed: onAdd,
        ),
        subtitle: [
          ...patchSet.patches.mapIndexed((i, p) => "${i + 1}. ${p.l10n()}".text()),
        ].column(maa: MainAxisAlignment.start),
      ),
    );
  }
}
