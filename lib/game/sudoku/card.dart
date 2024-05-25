import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/game/sudoku/entity/pref.dart';
import 'package:sit/game/sudoku/storage.dart';
import 'package:sit/game/widget/mode.dart';
import 'entity/mode.dart';
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
      save: StorageSudoku.save,
      supportRecords: true,
      view: buildGameModeCard().align(at: Alignment.centerLeft),
    );
  }

  Widget buildGameModeCard() {
    final pref = ref.watch(SettingsSudoku.$.$pref);
    return GameModeSelectorCard(
      all: GameModeSudoku.values,
      current: pref.mode,
      onChanged: (newMode) async {
        if (StorageSudoku.save.exists()) {
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
        StorageSudoku.save.delete();
      },
    );
  }
}
