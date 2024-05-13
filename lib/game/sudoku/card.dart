import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/game/sudoku/pref.dart';
import 'package:sit/game/widget/mode.dart';
import 'entity/mode.dart';
import 'save.dart';
import 'package:sit/game/widget/card.dart';

import 'i18n.dart';
import 'settings.dart';

class GameAppCardSudoku extends ConsumerStatefulWidget {
  const GameAppCardSudoku({super.key});

  @override
  ConsumerState<GameAppCardSudoku> createState() => _GameAppCardSudokuState();
}

class _GameAppCardSudokuState extends ConsumerState<GameAppCardSudoku> {
  @override
  Widget build(BuildContext context) {
    return OfflineGameAppCard(
      name: i18n.title,
      baseRoute: "/sudoku",
      storage: SaveSudoku.storage,
      view: buildGameModeCard().align(at: Alignment.centerLeft),
    );
  }

  Widget buildGameModeCard() {
    final pref = ref.watch(SettingsSudoku.$.$pref);
    return GameModeSelectorCard(
      all: GameModeSudoku.all,
      current: pref.mode,
      onChanged: (newMode) async {
        if (SaveSudoku.storage.exists()) {
          final confirm = await context.showActionRequest(
            desc: "Changing game mode will also delete your save",
            action: "Change to ${newMode.l10n()}",
            cancel: "Cancel",
          );
          if (confirm != true) return;
        }
        ref.read(SettingsSudoku.$.$pref.notifier).set(pref.copyWith(
              mode: newMode,
            ));
        SaveSudoku.storage.delete();
      },
    ).sized(w: 240);
  }
}
