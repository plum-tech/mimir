import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/game/entity/game_status.dart';
import 'package:mimir/game/widget/party_popper.dart';
import '../entity/state.dart';
import '../event_bus.dart';
import '../manager/logic.dart';
import '../widget/validation.dart';
import '../widget/display.dart';
import '../widget/guide.dart';

final stateWordle = StateNotifierProvider.autoDispose<GameLogic, GameStateWordle>((ref) {
  return GameLogic();
});

class GameWordle extends ConsumerStatefulWidget {
  const GameWordle({
    super.key,
    required this.database,
  });

  final List<String> database;

  @override
  ConsumerState<GameWordle> createState() => _GameWordleState();
}

class _GameWordleState extends ConsumerState<GameWordle> with TickerProviderStateMixin {
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
    final gameStatus = ref.watch(stateWordle.select((state) => state.status));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordle'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_outlined),
            onPressed: () {
              showGuideDialog(context: context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              wordleEventBus.fire(const WordleNewGameEvent());
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ValidationProvider(
            database: widget.database,
            child: const WordleDisplayWidget(),
          ),
          VictoryPartyPopper(
            pop: gameStatus == GameStatus.victory,
          ),
        ],
      ),
    );
  }
}
