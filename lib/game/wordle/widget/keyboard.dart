import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/game/wordle/entity/status.dart';
import '../entity/keyboard.dart';
import '../event_bus.dart';

class WordleKeyboardWidget extends StatefulWidget {
  const WordleKeyboardWidget({
    super.key,
  });

  @override
  State<WordleKeyboardWidget> createState() => _WordleKeyboardWidgetState();
}

class _WordleKeyboardWidgetState extends State<WordleKeyboardWidget> {
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
    return [
      [
        const Spacer(flex: 1),
        for (int i = 0; i < _keyPos[0].length; i++)
          WordleLetterKeyWidget(
            letter: _keyPos[0][i],
            status: _keyState[_keyPos[0][i]] ?? LetterStatus.neutral,
          ).padSymmetric(h: 3, v: 5).expanded(flex: 2),
        const Spacer(flex: 1),
      ].row(maa: MainAxisAlignment.center),
      [
        for (int i = 0; i < _keyPos[1].length; i++)
          WordleLetterKeyWidget(
            letter: _keyPos[1][i],
            status: _keyState[_keyPos[1][i]] ?? LetterStatus.neutral,
          ).padSymmetric(h: 3, v: 5).expanded(flex: 1),
        const WordleBackspaceKeyWidget().padSymmetric(h: 5, v: 5).expanded(flex: 2),
      ].row(maa: MainAxisAlignment.center),
      [
        const Spacer(flex: 1),
        for (int i = 0; i < _keyPos[2].length; i++)
          WordleLetterKeyWidget(
            letter: _keyPos[2][i],
            status: _keyState[_keyPos[2][i]] ?? LetterStatus.neutral,
          ).padSymmetric(h: 3, v: 5).expanded(flex: 2),
        const WordleEnterKeyWidget().padSymmetric(h: 5, v: 5).expanded(flex: 6),
        const Spacer(flex: 1),
      ].row(maa: MainAxisAlignment.center),
    ].column(maa: MainAxisAlignment.center);
  }
}

class WordleEnterKeyWidget extends StatelessWidget {
  const WordleEnterKeyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WordleKeyWidget(
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

class WordleBackspaceKeyWidget extends StatelessWidget {
  const WordleBackspaceKeyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WordleKeyWidget(
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

class WordleLetterKeyWidget extends StatelessWidget {
  final String letter;
  final LetterStatus status;

  const WordleLetterKeyWidget({
    super.key,
    required this.letter,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return WordleKeyWidget(
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

class WordleKeyWidget extends StatelessWidget {
  final Color? background;
  final VoidCallback onTap;
  final Widget child;

  const WordleKeyWidget({
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
