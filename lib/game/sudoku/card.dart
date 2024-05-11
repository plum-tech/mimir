import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
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
    final pref = ref.watch(SettingsSudoku.$.$pref);
    final gameMode = pref.mode;
    return AspectRatio(
      aspectRatio: 1.0,
      child: Card(
        child: [
          ListTile(
            title: "Game mode".text(),
          ),
          DropdownMenu<GameMode>(
            initialSelection: gameMode,
            onSelected: (GameMode? newSelection) {
              if (newSelection == null) return;
              ref.read(SettingsSudoku.$.$pref.notifier).set(pref.copyWith(
                    mode: newSelection,
                  ));
            },
            dropdownMenuEntries: GameMode.all
                .map((mode) => DropdownMenuEntry<GameMode>(
                      value: mode,
                      label: mode.l10n(),
                    ))
                .toList(),
          ),
        ].column(maa: MainAxisAlignment.spaceEvenly, mas: MainAxisSize.min).padSymmetric(v: 8, h: 16),
      ),
    ).sized(w: 180);
  }
}
