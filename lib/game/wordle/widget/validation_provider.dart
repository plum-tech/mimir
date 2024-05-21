import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import '../entity/keyboard.dart';
import '../entity/letter.dart';
import '../entity/status.dart';
import '../event_bus.dart';
import '../generator.dart';


class ValidationProvider extends StatefulWidget {
  static Set<String> validationDatabase = <String>{};

  final Widget child;
  final List<String> database;

  const ValidationProvider({
    super.key,
    required this.child,
    required this.database,
  });

  @override
  State<ValidationProvider> createState() => _ValidationProviderState();
}

class _ValidationProviderState extends State<ValidationProvider> {
  String answer = "";
  Map<String, int> letterMap = {};
  String curAttempt = "";
  int curAttemptCount = 0;
  bool acceptInput = true;
  late final StreamSubscription $newGame;
  late final StreamSubscription $result;

  void _onNewGame(dynamic args) {
    _newGame();
  }

  void _newGame() {
    curAttempt = "";
    curAttemptCount = 0;
    acceptInput = true;
    answer = getNextWord(widget.database);
    if (!ValidationProvider.validationDatabase.contains(answer)) {
      ValidationProvider.validationDatabase.add(answer);
    }
    letterMap = {};
    answer.split('').forEach((c) {
      letterMap[c] ??= 0;
      letterMap[c] = letterMap[c]! + 1;
    });
    letterMap = Map.unmodifiable(letterMap);
  }

  void _onGameEnd(WordleResultEvent event) {
    event.value ? _onGameWin() : _onGameLoose();
  }

  void _onGameWin() {
    acceptInput = false;
    _showResult(true);
  }

  void _onGameLoose() {
    acceptInput = false;
    _showResult(false);
  }

  void _showResult(bool result) async {
    var startNew = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Result'),
            content: Text(result ? "Won" : "Lost, answer is ${answer.toLowerCase()}"),
            actions: [
              TextButton(
                child: const Text('Back'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('New Game'),
                onPressed: () => Navigator.of(context).pop(true),
              )
            ],
          );
        });
    if (startNew == true) {
      wordleEventBus.fire(const WordleNewGameEvent());
    }
  }

  @override
  void initState() {
    super.initState();
    _newGame();
    $newGame = wordleEventBus.on<WordleNewGameEvent>().listen(_onNewGame);
    $result = wordleEventBus.on<WordleResultEvent>().listen(_onGameEnd);
  }

  @override
  void dispose() {
    $newGame.cancel();
    $result.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<InputNotification>(
      child: widget.child,
      onNotification: (noti) {
        if (noti.type == InputType.enter) {
          if (curAttempt.length < maxLetters) {
            //Not enough
            return true;
          } else {
            //Check validation
            if (ValidationProvider.validationDatabase.lookup(curAttempt) != null) {
              //Generate map
              Map<String, int> leftWordMap = Map.from(letterMap);
              var positionValRes = List.filled(maxLetters, LetterStatus.neutral);
              var letterValRes = <String, LetterStatus>{};
              for (int i = 0; i < maxLetters; i++) {
                if (curAttempt[i] == answer[i]) {
                  positionValRes[i] = LetterStatus.correct;
                  leftWordMap[curAttempt[i]] = leftWordMap[curAttempt[i]]! - 1;
                  letterValRes[curAttempt[i]] = LetterStatus.correct;
                }
              }
              for (int i = 0; i < maxLetters; i++) {
                if (curAttempt[i] != answer[i] &&
                    leftWordMap[curAttempt[i]] != null &&
                    leftWordMap[curAttempt[i]]! > 0) {
                  positionValRes[i] = LetterStatus.dislocated;
                  leftWordMap[curAttempt[i]] = leftWordMap[curAttempt[i]]! - 1;
                  letterValRes[curAttempt[i]] = letterValRes[curAttempt[i]] == LetterStatus.correct
                      ? LetterStatus.correct
                      : LetterStatus.dislocated;
                } else if (curAttempt[i] != answer[i]) {
                  positionValRes[i] = LetterStatus.wrong;
                  letterValRes[curAttempt[i]] ??= LetterStatus.wrong;
                }
              }
              //emit current attempt
              wordleEventBus.fire(
                WordleAttemptEvent(positionValRes),
              );
              wordleEventBus.fire(
                WordleValidationEvent(letterValRes),
              );
              curAttempt = "";
              curAttemptCount++;
            } else {
              onNotWord(context: context, attempt: "AAA");
            }
          }
        } else if (noti.type == InputType.backspace) {
          if (curAttempt.isNotEmpty) {
            curAttempt = curAttempt.substring(0, curAttempt.length - 1);
          }
        } else {
          if (acceptInput && curAttempt.length < maxLetters) {
            curAttempt += noti.letter;
          }
        }
        return true;
      },
    );
  }

  Future<void> onNotWord({
    required BuildContext context,
    required String attempt,
  }) async {
    context.showSnackBar(content: "Not a word.".text());
  }
}
