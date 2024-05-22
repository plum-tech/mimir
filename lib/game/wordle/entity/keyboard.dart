import 'package:flutter/widgets.dart';

enum WordleKeyType {
  letter,
  backspace,
  enter;
}

class WordleKey {
  final WordleKeyType type;
  final String letter;

  const WordleKey.backspace()
      : type = WordleKeyType.backspace,
        letter = "";

  const WordleKey.enter()
      : type = WordleKeyType.enter,
        letter = "";

  const WordleKey.letter(this.letter) : type = WordleKeyType.letter;
}

class InputNotification extends Notification {
  final WordleKey key;

  const InputNotification.backspace() : key = const WordleKey.backspace();

  const InputNotification.enter() : key = const WordleKey.enter();

  InputNotification.letter(String letter) : key = WordleKey.letter(letter);

  WordleKeyType get type => key.type;

  String get letter => key.letter;
}
