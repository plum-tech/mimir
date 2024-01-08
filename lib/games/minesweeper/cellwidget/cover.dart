import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import '../management/gamelogic.dart';

class CellCover extends StatelessWidget {
  const CellCover({
    super.key,
    required this.visible,
  });

  final duration = Durations.medium4;
  final curve = Curves.ease;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      curve: curve,
      duration: duration,
      child: Container(
        width: cellWidth,
        height: cellWidth,
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceVariant,
          border: Border.all(
            width: 1,
            color: context.colorScheme.surface,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
    );
  }
}
