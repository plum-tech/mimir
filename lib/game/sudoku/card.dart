import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/game/sudoku/pref.dart';
import 'entity/mode.dart';
import 'save.dart';
import 'package:sit/game/widget/card.dart';

import 'i18n.dart';
import 'settings.dart';

class GameAppCardSudoku extends StatefulWidget {
  const GameAppCardSudoku({super.key});

  @override
  State<GameAppCardSudoku> createState() => _GameAppCardSudokuState();
}

class _GameAppCardSudokuState extends State<GameAppCardSudoku> {
  @override
  Widget build(BuildContext context) {
    return OfflineGameAppCard(
      name: i18n.title,
      baseRoute: "/sudoku",
      storage: SaveSudoku.storage,
      view: GameModeCard().align(at: Alignment.centerLeft),
    );
  }
}

class GameModeCard extends ConsumerWidget {
  const GameModeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: [
        ListTile(
          leading: const Icon(Icons.videogame_asset),
          title: "Game mode".text(),
        ),
        buildSelector(context, ref),
      ]
          .column(maa: MainAxisAlignment.spaceEvenly, mas: MainAxisSize.min, caa: CrossAxisAlignment.start)
          .padSymmetric(v: 8, h: 16),
    ).sized(w: 240);
  }

  Widget buildSelector(BuildContext context, WidgetRef ref) {
    final pref = ref.watch(SettingsSudoku.$.$pref);
    final gameMode = pref.mode;

    return GameModeSudoku.all
        .map((mode) => ChoiceChip(
              showCheckmark: false,
              label: mode.l10n().text(),
              selected: mode == gameMode,
              onSelected: (v) async {
                if (SaveSudoku.storage.exists()) {
                  final confirm = await context.showActionRequest(
                    desc: "Changing game mode will also delete your save",
                    action: "Change to ${mode.l10n()}",
                    cancel: "Cancel",
                  );
                  if (confirm != true) return;
                }
                ref.read(SettingsSudoku.$.$pref.notifier).set(pref.copyWith(
                      mode: mode,
                    ));
                SaveSudoku.storage.delete();
              },
            ))
        .toList()
        .wrap(spacing: 8);
  }
}
