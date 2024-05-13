import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/game/minesweeper/pref.dart';
import 'package:sit/game/minesweeper/settings.dart';
import 'package:sit/game/widget/mode.dart';
import 'entity/mode.dart';
import 'save.dart';
import 'package:sit/game/widget/card.dart';

import 'i18n.dart';

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
      storage: SaveMinesweeper.storage,
      view: buildGameModeCard().align(at: Alignment.centerLeft),
    );
  }

  Widget buildGameModeCard() {
    final pref = ref.watch(SettingsMinesweeper.$.$pref);
    return GameModeSelectorCard(
      all: GameModeMinesweeper.all,
      current: pref.mode,
      onChanged: (newMode) async {
        if (SaveMinesweeper.storage.exists()) {
          final confirm = await context.showActionRequest(
            desc: "Changing game mode will also delete your save",
            action: "Change to ${newMode.l10n()}",
            cancel: "Cancel",
          );
          if (confirm != true) return;
        }
        ref.read(SettingsMinesweeper.$.$pref.notifier).set(pref.copyWith(
              mode: newMode,
            ));
        SaveMinesweeper.storage.delete();
      },
    ).sized(w: 280);
  }
}
