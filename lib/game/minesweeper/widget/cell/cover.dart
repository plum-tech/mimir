import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';

class CellCover extends ConsumerWidget {
  const CellCover({
    super.key,
    required this.visible,
  });

  final duration = Durations.medium4;
  final curve = Curves.ease;
  final bool visible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      curve: curve,
      duration: duration,
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
