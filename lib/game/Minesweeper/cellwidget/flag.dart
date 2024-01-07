import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CellFlag extends StatelessWidget{
  const CellFlag({super.key, required this.visible});
  final duration = Durations.medium4;
  final curve = Curves.ease;
  final bool visible;

  @override
  Widget build(BuildContext context) {
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
              size: 40,
              color: flagColor,
            ),
          )
      ),
    );
  }
}
