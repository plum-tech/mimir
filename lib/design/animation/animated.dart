import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

extension AnimatedEx on Widget {
  Widget animatedSwitched({
    Duration duration = Durations.medium2,
    Curve? switchInCurve,
    Curve? switchOutCurve,
  }) =>
      AnimatedSwitcher(
        switchInCurve: switchInCurve ?? Curves.linear,
        switchOutCurve: switchOutCurve ?? Curves.linear,
        duration: duration,
        child: this,
      );

  Widget animatedSized({
    Duration duration = Durations.medium2,
    Alignment align = Alignment.center,
    Curve curve = Curves.fastEaseInToSlowEaseOut,
  }) =>
      AnimatedSize(
        curve: curve,
        duration: duration,
        alignment: align,
        child: this,
      );
}
