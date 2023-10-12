import 'package:flutter/material.dart';

class ProgressWatcher {
  double _progress;
  final void Function(double progress)? callback;

  ProgressWatcher({
    double initial = 0.0,
    this.callback,
  }) : _progress = initial;

  double get value => _progress;

  set value(double newV) {
    _progress = newV;
    callback?.call(newV);
  }
}

class AnimatedProgressBar extends StatelessWidget {
  final double value;
  final Duration duration;

  const AnimatedProgressBar({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 250),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: Curves.easeInOut,
      tween: Tween<double>(
        begin: 0,
        end: value,
      ),
      builder: (context, value, _) => LinearProgressIndicator(value: value),
    );
  }
}
