import 'dart:async';

import 'package:flutter/material.dart';
import '../widget/validation_provider.dart';
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
  final _keyState = <String, int>{};
  final List<List<String>> _keyPos = List<List<String>>.unmodifiable([
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['Z', 'X', 'C', 'V', 'B', 'N', 'M']
  ]);
  Map<String, int> _cache = {};

  void _onLetterValidation(dynamic args) {
    _cache = args as Map<String, int>;
  }

  void _onAnimationStops(WordleAnimationStopEvent event) {
    setState(() {
      _cache.forEach((key, value) {
        if (_keyState[key] != 1) {
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
        _keyState[c] ??= 0;
        _keyState[c] = 0;
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
      _keyState[c] ??= 0;
      _keyState[c] = 0;
    }
    mainBus.on(event: "Validation", onEvent: _onLetterValidation);

    $animationStop = wordleEventBus.on<WordleAnimationStopEvent>().listen(_onAnimationStops);
    $newGame = wordleEventBus.on<WordleNewGameEvent>().listen(_onNewGame);
  }

  @override
  void dispose() {
    $animationStop.cancel();
    $newGame.cancel();
    mainBus.off(event: "Validation", callBack: _onLetterValidation);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Spacer(
                  flex: 1,
                ),
                for (int i = 0; i < 10; i++)
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 5.0),
                      child: ConstrainedBox(
                          constraints: const BoxConstraints.expand(height: 50.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all<OutlinedBorder?>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                              backgroundColor: WidgetStateProperty.all<Color?>(_keyState[_keyPos[0][i]]! == 0
                                  ? Colors.grey[400]
                                  : _keyState[_keyPos[0][i]]! == 1
                                      ? Colors.green[600]
                                      : _keyState[_keyPos[0][i]]! == 2
                                          ? Colors.yellow[800]
                                          : Colors.grey[700]),
                              padding: WidgetStateProperty.all<EdgeInsets?>(const EdgeInsets.all(0)),
                            ),
                            child: Center(
                              child: Text(
                                _keyPos[0][i],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _keyState[_keyPos[0][i]]! == 0 ? Colors.grey[850] : Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              InputNotification(type: InputType.singleCharacter, msg: _keyPos[0][i]).dispatch(context);
                            },
                          )),
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
                      child: ConstrainedBox(
                          constraints: const BoxConstraints.expand(height: 50.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all<OutlinedBorder?>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                              backgroundColor: WidgetStateProperty.all<Color?>(_keyState[_keyPos[1][i]]! == 0
                                  ? Colors.grey[400]
                                  : _keyState[_keyPos[1][i]]! == 1
                                      ? Colors.green[600]
                                      : _keyState[_keyPos[1][i]]! == 2
                                          ? Colors.yellow[800]
                                          : Colors.grey[700]),
                              padding: WidgetStateProperty.all<EdgeInsets?>(const EdgeInsets.all(0)),
                            ),
                            child: Center(
                              child: Text(
                                _keyPos[1][i],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _keyState[_keyPos[1][i]]! == 0 ? Colors.grey[850] : Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              InputNotification(type: InputType.singleCharacter, msg: _keyPos[1][i]).dispatch(context);
                            },
                          )),
                    ),
                  ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints.expand(height: 50.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all<OutlinedBorder?>(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                          backgroundColor: WidgetStateProperty.all<Color?>(Colors.grey[700]),
                          padding: WidgetStateProperty.all<EdgeInsets?>(const EdgeInsets.all(0)),
                        ),
                        child: const Icon(
                          Icons.keyboard_backspace_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          const InputNotification(type: InputType.backSpace, msg: "").dispatch(context);
                        },
                      ),
                    ),
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
                      child: ConstrainedBox(
                          constraints: const BoxConstraints.expand(height: 50.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all<OutlinedBorder?>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                              backgroundColor: WidgetStateProperty.all<Color?>(_keyState[_keyPos[2][i]]! == 0
                                  ? Colors.grey[400]
                                  : _keyState[_keyPos[2][i]]! == 1
                                      ? Colors.green[600]
                                      : _keyState[_keyPos[2][i]]! == 2
                                          ? Colors.yellow[800]
                                          : Colors.grey[700]),
                              padding: WidgetStateProperty.all<EdgeInsets?>(const EdgeInsets.all(0)),
                            ),
                            child: Center(
                              child: Text(
                                _keyPos[2][i],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _keyState[_keyPos[2][i]]! == 0 ? Colors.grey[850] : Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              InputNotification(type: InputType.singleCharacter, msg: _keyPos[2][i]).dispatch(context);
                            },
                          )),
                    ),
                  ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints.expand(height: 50.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all<OutlinedBorder?>(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                          backgroundColor: WidgetStateProperty.all<Color?>(Colors.green[600]),
                          padding: WidgetStateProperty.all<EdgeInsets?>(const EdgeInsets.all(0)),
                        ),
                        child: const Icon(
                          Icons.keyboard_return_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          const InputNotification(type: InputType.inputConfirmation, msg: "").dispatch(context);
                        },
                      ),
                    ),
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
