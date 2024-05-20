import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import '../event_bus.dart';
import '../widget/validation_provider.dart';
import '../widget/display.dart';
import '../widget/guide.dart';

class GameWordle extends StatefulWidget {
  const GameWordle({
    super.key,
    required this.database,
    required this.maxChances,
    required this.gameMode,
  });

  final Map<String, List<String>> database;
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
    $validationEnd = wordleEventBus.on<WordleValidationEndEvent>().listen(_onGameEnd);
  }

  @override
  void dispose() {
    $validationEnd.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              toolbarHeight: 80.0,
              title: const Text('Wordle'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.help_outline_outlined),
                  //color: Colors.black,
                  onPressed: () {
                    showGuideDialog(context: context);
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
            body: ValidationProvider(
              database: widget.database,
              maxChances: widget.maxChances,
              gameMode: widget.gameMode,
              child: WordleDisplayWidget( maxChances: widget.maxChances),
            ),
          ),
        ),
      ],
    );
  }
}
