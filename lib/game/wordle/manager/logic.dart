import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/game/entity/game_result.dart';
import 'package:mimir/game/entity/game_status.dart';
import 'package:mimir/game/utils.dart';
import 'package:mimir/game/wordle/entity/letter.dart';

import '../entity/keyboard.dart';
import '../entity/state.dart';
import '../entity/vocabulary.dart';
import '../entity/record.dart';
import '../entity/save.dart';
import '../storage.dart';

class GameLogic extends StateNotifier<GameStateWordle> {
  GameLogic([GameStateWordle? initial]) : super(initial ?? const GameStateWordle.byDefault());

  void initGame({required WordleVocabulary vocabulary}) {
    state = GameStateWordle.newGame(
      vocabulary: vocabulary,
      word: "APPLE",
    );
  }

  void startGame() {
    state = state.copyWith(status: GameStatus.running);
  }

  void fromSave(SaveWordle save) {
    state = GameStateWordle.fromSave(save);
  }

  Duration get playtime => state.playtime;

  set playtime(Duration playtime) => state = state.copyWith(
        playtime: playtime,
      );

  bool get acceptInput => state.attempts.length < maxAttempts && state.input.length < maxLetters;

  bool get canBackspace => state.input.isNotEmpty;

  void onKey(WordleKey key) {
    switch (key.type) {
      case WordleKeyType.letter:
        if (!acceptInput) return;
        state = state.copyWith(
          input: state.input + key.letter,
        );
        break;
      case WordleKeyType.backspace:
        if (!canBackspace) return;
        state = state.copyWith(
          input: state.input.substring(0, state.input.length - 1),
        );
        break;
      case WordleKeyType.enter:
        break;
    }
  }

  Future<void> save() async {
    if (state.status.shouldSave) {
      await StorageWordle.save.save(state.toSave());
    } else {
      await StorageWordle.save.delete();
    }
  }

  void onVictory() {
    state = state.copyWith(
      status: GameStatus.victory,
    );
    StorageWordle.record.add(RecordWordle.createFrom(
      playtime: state.playtime,
      vocabulary: state.vocabulary,
      attempts: state.attempts,
      result: GameResult.victory,
    ));
  }

  void onGameOver() {
    state = state.copyWith(
      status: GameStatus.gameOver,
    );
    StorageWordle.record.add(RecordWordle.createFrom(
      playtime: state.playtime,
      vocabulary: state.vocabulary,
      attempts: state.attempts,
      result: GameResult.gameOver,
    ));
    applyGameHapticFeedback(HapticFeedbackIntensity.heavy);
  }
}
