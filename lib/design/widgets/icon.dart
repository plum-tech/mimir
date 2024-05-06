import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rettulf/rettulf.dart';

class DualIcon extends StatelessWidget {
  final IconData primary;
  final IconData? secondary;
  final double size;

  const DualIcon({
    super.key,
    required this.primary,
    this.secondary,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final secondary = this.secondary;
    final primarySize = size;
    final secondarySize = size * 0.25;
    return [
      Icon(
        primary,
        size: primarySize,
      ).sizedAll(size),
      if (secondary != null)
        Card.filled(
          child: Icon(
            secondary,
            size: secondarySize,
          ).sizedAll(secondarySize).padAll(secondarySize * 0.1),
        ).align(at: Alignment.bottomRight),
    ].stack().sizedAll(size);
  }
}
