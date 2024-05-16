import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/game/minesweeper/pref.dart';
import 'package:sit/game/minesweeper/settings.dart';
import 'package:sit/game/widget/mode.dart';
import 'entity/mode.dart';
import 'package:sit/game/widget/card.dart';

import 'i18n.dart';
import 'storage.dart';

class GameAppCardMinesweeper extends ConsumerStatefulWidget {
  const GameAppCardMinesweeper({super.key});

  @override
  ConsumerState<GameAppCardMinesweeper> createState() => _GameAppCardMinesweeperState();
}

class _GameAppCardMinesweeperState extends ConsumerState<GameAppCardMinesweeper> {
  @override
  Widget build(BuildContext context) {
    return OfflineGameAppCard(
      name: i18n.title,
      baseRoute: "/minesweeper",
      save: StorageMinesweeper.save,
      supportRecords: true,
      view: buildGameModeCard().align(at: Alignment.centerLeft),
    );
  }

  Widget buildGameModeCard() {
    final pref = ref.watch(SettingsMinesweeper.$.$pref);
    return GameModeSelectorCard(
      all: GameModeMinesweeper.all,
      current: pref.mode,
      onChanged: (newMode) async {
        if (StorageMinesweeper.save.exists()) {
          final confirm = await context.showActionRequest(
            desc: i18n.changeGameModeRequest,
            action: i18n.changeGameModeAction(newMode.l10n()),
            cancel: i18n.cancel,
          );
          if (confirm != true) return;
        }
        ref.read(SettingsMinesweeper.$.$pref.notifier).set(pref.copyWith(
              mode: newMode,
            ));
        StorageMinesweeper.save.delete();
      },
    ).sized(w: 280);
  }
}
