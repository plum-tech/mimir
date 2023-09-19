import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/widgets.dart';

extension LiveListAnimationEx on Widget {
  Widget aliveWith(
    Animation<double> animation,
  ) =>
      // For example wrap with fade transition
      FadeTransition(
        opacity: CurveTween(
          curve: Curves.fastEaseInToSlowEaseOut,
        ).animate(animation),
        // And slide transition
        child: SlideTransition(
          position: CurveOffset(
            begin: const Offset(0, 0.5),
            end: Offset.zero,
            curve: Curves.fastEaseInToSlowEaseOut,
          ).animate(animation),
          // Paste you Widget
          child: this,
        ),
      );
}

const commonLiveOptions = LiveOptions(
  showItemInterval: Duration(milliseconds: 40), // the interval between two items
  showItemDuration: Duration(milliseconds: 250), // How long it animated to appear
);

class CurveOffset extends Animatable<Offset> {
  final Offset begin;
  final Offset end;

  /// Creates a curve tween.
  ///
  /// The [curve] argument must not be null.
  CurveOffset({required this.begin, required this.end, required this.curve});

  /// The curve to use when transforming the value of the animation.
  final Curve curve;

  @override
  Offset transform(double t) {
    return Offset(
      curve.transform(t) * (end.dx - begin.dx) + begin.dx,
      curve.transform(t) * (end.dy - begin.dy) + begin.dy,
    );
  }

  @override
  String toString() => 'CurveTweenOffset(curve: $curve)';
}
