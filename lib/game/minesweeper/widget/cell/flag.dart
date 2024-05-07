import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import '../../theme.dart';

class CellFlag extends ConsumerWidget {
  const CellFlag({super.key, required this.visible});

  final duration = Durations.medium4;
  final curve = Curves.ease;
  final bool visible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedPositioned(
      left: 0,
      top: visible ? 0 : -40,
      duration: duration,
      curve: curve,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: duration,
        curve: curve,
        child: AnimatedScale(
          scale: visible ? 1 : 0.2,
          duration: duration,
          curve: curve,
          child: const Icon(
            Icons.flag,
            size: flagSize,
            color: flagColor,
          ),
        ),
      ).center(),
    );
  }
}
