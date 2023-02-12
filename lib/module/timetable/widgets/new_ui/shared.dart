import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

class ElevatedNumber extends StatelessWidget {
  final int number;
  final Color color;
  final double margin;
  final double elevation;

  const ElevatedNumber({
    super.key,
    required this.number,
    required this.color,
    required this.margin,
    required this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final text = number.toString();
    return Card(
      elevation: elevation,
      color: color,
      shape: const CircleBorder(),
      child: text.text(textAlign: TextAlign.center).padAll(margin),
    );
  }
}

class ElevatedText extends StatelessWidget {
  final Widget child;
  final Color color;
  final double margin;
  final double elevation;

  const ElevatedText({
    super.key,
    required this.color,
    required this.margin,
    required this.elevation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: color,
      child: child.padAll(margin),
    );
  }
}
