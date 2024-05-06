import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/entity/campus.dart';
import 'package:sit/settings/settings.dart';
import 'package:rettulf/rettulf.dart';

class CampusSelector extends ConsumerWidget {
  const CampusSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SegmentedButton<Campus>(
      segments: Campus.values
          .map((e) => ButtonSegment<Campus>(
                icon: Icon(context.icons.location),
                value: e,
                label: e.l10nName().text(),
              ))
          .toList(),
      selected: <Campus>{ref.watch(Settings.$campus) ?? Campus.fengxian},
      onSelectionChanged: (newSelection) async {
        ref.read(Settings.$campus.notifier).set(newSelection.first);
        await HapticFeedback.mediumImpact();
      },
    );
  }
}
