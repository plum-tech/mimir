import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/game/sudoku/pref.dart';
import 'package:sit/game/widget/mode.dart';
import 'entity/mode.dart';
import 'entity/save.dart';
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
      save: SaveSudoku.storage,
      supportRecords: true,
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
            desc: i18n.changeGameModeRequest,
            action: i18n.changeGameModeAction(newMode.l10n()),
            cancel: i18n.cancel,
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
