import 'package:flutter/material.dart';

class BoardTile extends StatelessWidget {
  final Color? color;
  final double size;
  final Widget? child;

  const BoardTile({
    super.key,
    this.color,
    required this.size,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: child,
    );
  }
}
