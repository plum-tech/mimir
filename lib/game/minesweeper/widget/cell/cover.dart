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
      duration: visible ? Duration.zero : Durations.long1,
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: context.colorScheme.surfaceContainerHighest,
        ),
      ),
    );
  }
}
