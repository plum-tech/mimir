import 'package:flutter/widgets.dart';

extension AnimatedEx on Widget {
  Widget animatedSwitched({
    Duration duration = const Duration(milliseconds: 500),
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
    Duration duration = const Duration(milliseconds: 500),
    Alignment align = Alignment.center,
    Curve? curve,
  }) =>
      AnimatedSize(
        curve: curve ?? Curves.linear,
        duration: duration,
        alignment: align,
        child: this,
      );
}
