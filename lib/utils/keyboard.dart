import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

extension KeyEventX on KeyEvent {
  int? tryGetNumber() {
    final represent = character;
    if (represent == null) return null;
    final number = int.tryParse(represent);
    return number;
  }

  AxisDirection? tryGetArrowKey() {
    return switch (logicalKey) {
      LogicalKeyboardKey.arrowRight => AxisDirection.right,
      LogicalKeyboardKey.arrowDown => AxisDirection.down,
      LogicalKeyboardKey.arrowLeft => AxisDirection.left,
      LogicalKeyboardKey.arrowUp => AxisDirection.up,
      _ => null,
    };
  }
}
