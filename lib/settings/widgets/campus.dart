import 'package:flutter/material.dart';
import 'package:mimir/entity/campus.dart';
import 'package:mimir/settings/settings.dart';
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
        onSelectionChanged: (newSelection) {
          setState(() {
            Settings.campus = newSelection.first;
          });
        },
      ),
    );
  }
}
