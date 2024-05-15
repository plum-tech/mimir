import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

class CellCover extends StatelessWidget {
  final bool visible;

  const CellCover({
    super.key,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      curve: Curves.ease,
      duration: Durations.long1,
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHighest,
          border: Border.all(
            width: 1,
            color: context.colorScheme.surface,
          ),
        ),
      ),
    );
  }
}
