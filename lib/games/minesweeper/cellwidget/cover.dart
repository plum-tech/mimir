import 'package:flutter/material.dart';
import '../management/gamelogic.dart';
import '../theme/colors.dart';

class CellCover extends StatelessWidget{
  CellCover({super.key, required this.visible});
  final duration = Durations.medium2;
  final curve = Curves.ease;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      curve: curve,
      duration: duration,
      child: Container(
        width: cellWidth, height: cellWidth,
        decoration: BoxDecoration(
          color: cellColor,
          border: Border.all(
            width: 1,
            color: cellRoundColor,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(cellRadius),
          ),
        ),
      ),
    );
  }
}
