import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../event_bus.dart';
import '../widget/validation_provider.dart';
import '../widget/display.dart';
import '../widget/instruction.dart';

class GameWordle extends StatefulWidget {
  const GameWordle({
    super.key,
    required this.database,
    required this.wordLen,
    required this.maxChances,
    required this.gameMode,
  });

  final Map<String, List<String>> database;
  final int wordLen;
  final int maxChances;
  final int gameMode;

  @override
  State<GameWordle> createState() => _GameWordleState();
}

class _GameWordleState extends State<GameWordle> with TickerProviderStateMixin {
  late AnimationController _controller;
  late final StreamSubscription $validationEnd;

  void _onGameEnd(WordleValidationEndEvent event) {
    var result = event.value;
    if (result == true) {
      _controller.forward().then((v) {
        _controller.reset();
        wordleEventBus.fire(WordleResultEvent(result));
      });
    } else {
      wordleEventBus.fire(WordleResultEvent(result));
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    $validationEnd =  wordleEventBus.on<WordleValidationEndEvent>().listen(_onGameEnd);
  }

  @override
  void dispose() {
    $validationEnd.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mode = Theme.of(context).brightness;
    return Stack(
      children: [
        Positioned.fill(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[850] : Colors.white,
              elevation: 0.0,
              shadowColor: Colors.transparent,
              toolbarHeight: 80.0,
              titleTextStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[100] : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              title: const Text('WORDLE'),
              centerTitle: true,
              //iconTheme: const IconThemeData(color: Colors.black),
              actions: [
                AnimatedSwitcher(
                  duration: Durations.short3,
                  reverseDuration: Durations.short3,
                  switchInCurve: Curves.bounceOut,
                  switchOutCurve: Curves.bounceIn,
                  transitionBuilder: (child, animation) {
                    var rotateAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(animation);
                    var opacAnimation = Tween<double>(begin: 0, end: 1).animate(animation);
                    return AnimatedBuilder(
                      animation: rotateAnimation,
                      builder: (context, child) {
                        return Transform(
                          transform: Matrix4.rotationZ(rotateAnimation.status == AnimationStatus.reverse
                              ? 2 * pi - rotateAnimation.value
                              : rotateAnimation.value),
                          alignment: Alignment.center,
                          child: Opacity(
                            opacity: opacAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: child,
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.help_outline_outlined),
                  //color: Colors.black,
                  onPressed: () {
                    showInstructionDialog(context: context);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  //color: Colors.black,
                  onPressed: () {
                    wordleEventBus.fire(const WordleNewGameEvent());
                  },
                ),
              ],
            ),
            body: Container(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[850] : Colors.white,
              child: ValidationProvider(
                database: widget.database,
                wordLen: widget.wordLen,
                maxChances: widget.maxChances,
                gameMode: widget.gameMode,
                child: WordleDisplayWidget(wordLen: widget.wordLen, maxChances: widget.maxChances),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
