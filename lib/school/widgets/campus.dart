import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sit/entity/campus.dart';
import 'package:sit/settings/settings.dart';
import 'package:rettulf/rettulf.dart';

class CampusSelector extends StatelessWidget {
  const CampusSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (ctx, setState) => SegmentedButton<Campus>(
        segments: Campus.values
            .map((e) => ButtonSegment<Campus>(
                  icon: const Icon(Icons.place_outlined),
                  value: e,
                  label: e.l10nName().text(),
                ))
            .toList(),
        selected: <Campus>{Settings.campus},
        onSelectionChanged: (newSelection) async {
          setState(() {
            Settings.campus = newSelection.first;
          });
          await HapticFeedback.mediumImpact();
        },
      ),
    );
  }
}
