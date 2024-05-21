import 'dart:async';

import 'package:flutter/material.dart';
import '../entity/letter.dart';
import '../entity/status.dart';
import '../widget/validation_provider.dart';
import 'input.dart';
import '../event_bus.dart';
import 'dart:math' as math;

class WordleDisplayWidget extends StatefulWidget {
  const WordleDisplayWidget({
    super.key,
  });

  @override
  State<WordleDisplayWidget> createState() => _WordleDisplayWidgetState();
}

class _WordleDisplayWidgetState extends State<WordleDisplayWidget> with TickerProviderStateMixin {
  late final StreamSubscription $attempt;
  late final StreamSubscription $newGame;
  int r = 0;
  int c = 0;
  bool onAnimation = false;
  bool acceptInput = true;
  late final List<List<WordleLetterLegacy>> inputs;

  void _validationAnimation(List<LetterStatus> validation) async {
    onAnimation = true;
    bool result = true;
    for (int i = 0; i < maxLetters && onAnimation; i++) {
      setState(() {
        inputs[r][i].status = validation[i];
      });
      if (validation[i] != 1) {
        result = false;
      }
      await Future.delayed(const Duration(milliseconds: 240));
    }
    if (!onAnimation) {
      return;
    }
    wordleEventBus.fire(const WordleAnimationStopEvent());
    onAnimation = false;
    r++;
    c = 0;
    if (r == maxAttempts || result == true) {
      wordleEventBus.fire(const WordleAnimationStopEvent());
      acceptInput = false;
    }
  }

  void _onValidation(WordleAttemptEvent event) {
    List<LetterStatus> validation = event.validation;
    _validationAnimation(validation);
  }

  void _onNewGame(WordleNewGameEvent event) {
    setState(() {
      r = 0;
      c = 0;
      onAnimation = false;
      acceptInput = true;
      for (int i = 0; i < maxAttempts; i++) {
        for (int j = 0; j < maxLetters; j++) {
          inputs[i][j].letter = "";
          inputs[i][j].status = LetterStatus.neutral;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    inputs = [
      for (int i = 0; i < maxAttempts; i++)
        [
          for (int j = 0; j < maxLetters; j++)
            WordleLetterLegacy()
              ..animation = AnimationController(
                duration: const Duration(milliseconds: 50),
                reverseDuration: const Duration(milliseconds: 100),
                vsync: this,
              )
        ]
    ];
    $attempt = wordleEventBus.on<WordleAttemptEvent>().listen(_onValidation);
    $newGame = wordleEventBus.on<WordleNewGameEvent>().listen(_onNewGame);
  }

  @override
  void dispose() {
    $attempt.cancel();
    $newGame.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<InputNotification>(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildDisplayBoard(),
          const Padding(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 30.0),
            child: WordleKeyboard(),
          ),
        ],
      ),
      onNotification: (noti) {
        if (noti.type == InputType.singleCharacter) {
          if (r < maxAttempts && c < maxLetters && !onAnimation && acceptInput) {
            setState(() {
              inputs[r][c].letter = noti.msg;
              inputs[r][c].status = LetterStatus.neutral;
              var controller = inputs[r][c].animation;
              controller.forward().then((value) => controller.reverse());
              c++;
            });
          } else if (onAnimation) {
            return true;
          }
        } else if (noti.type == InputType.backSpace) {
          if (c > 0 && !onAnimation) {
            setState(() {
              inputs[r][c - 1].letter = "";
              inputs[r][c - 1].status = LetterStatus.neutral;
              c--;
            });
          }
        }
        return false;
      },
    );
  }

  Widget buildDisplayBoard() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
        child: Align(
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: maxLetters / maxAttempts,
            child: Column(
              //Column(
              children: [
                for (int i = 0; i < maxAttempts; i++)
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int j = 0; j < maxLetters; j++)
                          AnimatedBuilder(
                              animation: inputs[i][j].animation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: Tween<double>(begin: 1, end: 1.1)
                                      .evaluate(inputs[i][j].animation),
                                  child: child,
                                );
                              },
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 700),
                                      switchInCurve: Curves.easeOut,
                                      reverseDuration: const Duration(milliseconds: 0),
                                      transitionBuilder: (child, animation) {
                                        return AnimatedBuilder(
                                            animation: animation,
                                            child: child,
                                            builder: (context, child) {
                                              var _animation =
                                                  Tween<double>(begin: math.pi / 2, end: 0).animate(animation);
                                              // return ConstrainedBox(
                                              //   constraints: BoxConstraints.tightFor(height: constraints.maxHeight * _animation.value),
                                              //   child: child,
                                              // );
                                              return Transform(
                                                transform: Matrix4.rotationX(_animation.value),
                                                alignment: Alignment.center,
                                                child: child,
                                              );
                                            });
                                      },
                                      child: Padding(
                                        key: ValueKey(inputs[i][j].status),
                                        padding: const EdgeInsets.all(5.0),
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: inputs[i][j].status.border,
                                              width: 2.0,
                                            ),
                                            color: inputs[i][j].status.bg,
                                          ),
                                          child: Center(
                                            child: Text(
                                              inputs[i][j].letter,
                                              style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
