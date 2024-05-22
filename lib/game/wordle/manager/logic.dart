import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sit/game/entity/game_result.dart';
import 'package:sit/game/entity/game_status.dart';
import 'package:sit/game/utils.dart';
import 'package:sit/game/wordle/entity/letter.dart';

import '../entity/keyboard.dart';
import '../entity/state.dart';
import '../entity/vocabulary.dart';
import '../entity/record.dart';
import '../entity/save.dart';
import '../storage.dart';

class GameLogic extends StateNotifier<GameStateWordle> {
  GameLogic([GameStateWordle? initial]) : super(initial ?? GameStateWordle.byDefault());

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

  void onKey(WordleKey key) {
    switch (key.type) {
      case WordleKeyType.letter:
        if (state.input.length < maxLetters) {
          state = state.copyWith(
            input: state.input + key.letter,
          );
        }
        break;
      case WordleKeyType.backspace:
        if (state.input.isNotEmpty) {
          state = state.copyWith(
            input: state.input.substring(0, state.input.length - 1),
          );
        }
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
      result: GameResult.gameOver,
    ));
    applyGameHapticFeedback(HapticFeedbackIntensity.heavy);
  }
}
