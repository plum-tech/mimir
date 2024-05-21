import 'package:flutter/widgets.dart';

enum InputType {
  letter,
  backspace,
  enter;
}

class InputNotification extends Notification {
  const InputNotification.backspace()
      : type = InputType.backspace,
        letter = "";

  const InputNotification.enter()
      : type = InputType.enter,
        letter = "";

  const InputNotification.letter(this.letter) : type = InputType.letter;

  final InputType type;
  final String letter;
}
