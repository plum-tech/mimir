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
      ),
    );
  }
}
