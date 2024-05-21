import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/game/wordle/entity/status.dart';
import '../entity/keyboard.dart';
import '../event_bus.dart';

class WordleKeyboard extends StatefulWidget {
  const WordleKeyboard({
    super.key,
  });

  @override
  State<WordleKeyboard> createState() => _WordleKeyboardState();
}

class _WordleKeyboardState extends State<WordleKeyboard> {
  late final StreamSubscription $animationStop;
  late final StreamSubscription $newGame;
  late final StreamSubscription $validation;
  final _keyState = <String, LetterStatus>{};
  final List<List<String>> _keyPos = List<List<String>>.unmodifiable([
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['Z', 'X', 'C', 'V', 'B', 'N', 'M']
  ]);
  Map<String, LetterStatus> _cache = {};

  void _onLetterValidation(WordleValidationEvent event) {
    _cache = event.value;
  }

  void _onAnimationStops(WordleAnimationStopEvent event) {
    setState(() {
      _cache.forEach((key, value) {
        if (_keyState[key] != LetterStatus.correct) {
          _keyState[key] = value;
        }
      });
    });
  }

  void _onNewGame(WordleNewGameEvent event) {
    setState(() {
      var aCode = 'A'.codeUnitAt(0);
      var zCode = 'Z'.codeUnitAt(0);
      var alphabet = List<String>.generate(
        zCode - aCode + 1,
        (index) => String.fromCharCode(aCode + index),
      );
      for (String c in alphabet) {
        _keyState[c] ??= LetterStatus.neutral;
        _keyState[c] = LetterStatus.neutral;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    var aCode = 'A'.codeUnitAt(0);
    var zCode = 'Z'.codeUnitAt(0);
    var alphabet = List<String>.generate(
      zCode - aCode + 1,
      (index) => String.fromCharCode(aCode + index),
    );
    for (String c in alphabet) {
      _keyState[c] ??= LetterStatus.neutral;
      _keyState[c] = LetterStatus.neutral;
    }
    $animationStop = wordleEventBus.on<WordleAnimationStopEvent>().listen(_onAnimationStops);
    $newGame = wordleEventBus.on<WordleNewGameEvent>().listen(_onNewGame);
    $validation = wordleEventBus.on<WordleValidationEvent>().listen(_onLetterValidation);
  }

  @override
  void dispose() {
    $animationStop.cancel();
    $newGame.cancel();
    $validation.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(
              flex: 1,
            ),
            for (int i = 0; i < 10; i++)
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 5.0),
                  child: WordleLetterKey(
                    letter: _keyPos[0][i],
                    status: _keyState[_keyPos[0][i]] ?? LetterStatus.neutral,
                  ),
                ),
              ),
            const Spacer(
              flex: 1,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            for (int i = 0; i < 9; i++)
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 5.0),
                  child: WordleLetterKey(
                    letter: _keyPos[1][i],
                    status: _keyState[_keyPos[1][i]] ?? LetterStatus.neutral,
                  ),
                ),
              ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                child: WordleBackspaceKey(),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Spacer(
              flex: 1,
            ),
            for (int i = 0; i < 7; i++)
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 5.0),
                  child: WordleLetterKey(
                    letter: _keyPos[2][i],
                    status: _keyState[_keyPos[2][i]] ?? LetterStatus.neutral,
                  ),
                ),
              ),
            const Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                child: WordleEnterKey(),
              ),
            ),
            const Spacer(
              flex: 1,
            ),
          ],
        ),
      ],
    );
  }
}

class WordleEnterKey extends StatelessWidget {
  const WordleEnterKey({super.key});

  @override
  Widget build(BuildContext context) {
    return WordleKey(
      background: Colors.green[600],
      onTap: () {
        const InputNotification.enter().dispatch(context);
      },
      child: const Icon(
        Icons.keyboard_return_rounded,
        color: Colors.white,
      ),
    );
  }
}

class WordleBackspaceKey extends StatelessWidget {
  const WordleBackspaceKey({super.key});

  @override
  Widget build(BuildContext context) {
    return WordleKey(
      background: Colors.grey[700],
      onTap: () {
        const InputNotification.backspace().dispatch(context);
      },
      child: const Icon(
        Icons.keyboard_backspace_rounded,
        color: Colors.white,
      ),
    );
  }
}

class WordleLetterKey extends StatelessWidget {
  final String letter;
  final LetterStatus status;

  const WordleLetterKey({
    super.key,
    required this.letter,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return WordleKey(
      background: status.bg,
      onTap: () {
        InputNotification.letter(letter).dispatch(context);
      },
      child: Text(
        letter,
        style: context.textTheme.titleMedium?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class WordleKey extends StatelessWidget {
  final Color? background;
  final VoidCallback onTap;
  final Widget child;

  const WordleKey({
    super.key,
    this.background,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(height: 50.0),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<OutlinedBorder?>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
          backgroundColor: WidgetStateProperty.all<Color?>(background),
          padding: WidgetStateProperty.all<EdgeInsets?>(const EdgeInsets.all(0)),
        ),
        child: Center(
          child: child,
        ),
        onPressed: onTap,
      ),
    );
  }
}
