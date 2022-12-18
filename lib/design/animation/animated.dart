import 'package:flutter/widgets.dart';

extension AnimatedEx on Widget {
  Widget animatedSwitched({
    Duration d = const Duration(milliseconds: 500),
    Curve? switchInCurve,
    Curve? switchOutCurve,
  }) =>
      AnimatedSwitcher(
        switchInCurve: switchInCurve ?? Curves.linear,
        switchOutCurve: switchOutCurve ?? Curves.linear,
        duration: d,
        child: this,
      );

  Widget animatedSized({
    Duration d = const Duration(milliseconds: 500),
    Alignment align = Alignment.center,
    Curve? curve,
  }) =>
      AnimatedSize(
        curve: curve ?? Curves.linear,
        duration: d,
        alignment: align,
        child: this,
      );
}
