import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../../entity/patch.dart';

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
  const TimetableRemoveDayPatchSheet({super.key});

  @override
  State<TimetableRemoveDayPatchSheet> createState() => _TimetableRemoveDayPatchSheetState();
}

class _TimetableRemoveDayPatchSheetState extends State<TimetableRemoveDayPatchSheet> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

