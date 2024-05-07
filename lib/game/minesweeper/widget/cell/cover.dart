import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';

class CellCover extends ConsumerWidget {
  final bool visible;

  const CellCover({
    super.key,
    required this.visible,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      curve: Curves.ease,
      duration: Durations.long1,
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceVariant,
          border: Border.all(
            width: 1,
            color: context.colorScheme.surface,
          ),
        ),
      ),
    );
  }
}
