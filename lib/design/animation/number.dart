import 'package:flutter/widgets.dart';

class AnimatedNumber extends StatelessWidget {
  final Duration duration;
  final double value;
  final Widget Function(BuildContext context, double value) builder;

  const AnimatedNumber({
    super.key,
    required this.value,
    required this.builder,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween(begin: value, end: value),
      duration: duration,
      builder: (ctx, value, _) => builder(ctx, value),
    );
  }
}
