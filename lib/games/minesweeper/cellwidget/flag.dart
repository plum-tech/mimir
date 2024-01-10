import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sit/games/minesweeper/theme/colors.dart';
import '../management/gamelogic.dart';

class CellFlag extends ConsumerWidget{
  const CellFlag({super.key, required this.visible});
  final duration = Durations.medium4;
  final curve = Curves.ease;
  final bool visible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = ref.read(boardManager).screen;
    final double flagSize = screen.getCellWidth();
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
            child: Icon(
              Icons.flag,
              size: flagSize,
              color: flagColor,
            ),
          )
      ),
    );
  }
}
