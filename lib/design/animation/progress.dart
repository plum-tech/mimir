import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatelessWidget {
  final double value;

  const AnimatedProgressBar({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      tween: Tween<double>(
        begin: 0,
        end: value,
      ),
      builder: (context, value, _) => LinearProgressIndicator(value: value),
    );
  }
}
