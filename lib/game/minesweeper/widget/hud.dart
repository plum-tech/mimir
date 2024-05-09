import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/game/entity/game_state.dart';
import '../entity/cell.dart';
import '../entity/mode.dart';
import '../i18n.dart';
import '../theme.dart';
import '../page/game.dart';

class GameHud extends ConsumerWidget {
  const GameHud({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(minesweeperState);
    final textTheme = context.textTheme;
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
      child: [
        Container(
          decoration: BoxDecoration(
            color: context.colorScheme.secondaryContainer,
          ),
          child: [
            const Icon(Icons.videogame_asset_outlined),
            state.state == GameState.running
                ? MinesAndFlags(
                    flags: state.board.countAllByState(state: CellState.flag),
                    mines: state.board.mines,
                  )
                : buildGameModeButton(context, ref, state.mode),
          ].row(maa: MainAxisAlignment.spaceAround),
        ).expanded(),
        Container(
          decoration: BoxDecoration(
            color: context.colorScheme.tertiaryContainer,
          ),
          child: [
            const Icon(Icons.alarm),
            Text(
              state.playtime.getTimeCost(),
              style: textTheme.bodyLarge,
            ),
          ].row(maa: MainAxisAlignment.spaceAround),
        ).expanded(),
      ].row(maa: MainAxisAlignment.center, caa: CrossAxisAlignment.stretch).sized(h: 50),
    );
  }

  Widget buildGameModeButton(BuildContext context, WidgetRef ref, GameMode mode) {
    return OutlinedButton.icon(
      icon: const Icon(Icons.mode),
      onPressed: () async {
        final controller = FixedExtentScrollController(
          initialItem: GameMode.all.indexOf(mode),
        );
        await context.showPicker(
          count: GameMode.all.length,
          controller: controller,
          make: (ctx, index) => GameMode.all[index].l10n().text(),
        );
        controller.dispose();
        final newMode = GameMode.all[controller.selectedItem];
        if (newMode != mode) {
          ref.read(minesweeperState.notifier).initGame(gameMode: newMode);
        }
      },
      label: Text(
        mode.l10n(),
        style: context.textTheme.bodyLarge,
      ),
    );
  }
}

class GameModeButton extends StatefulWidget {
  const GameModeButton({super.key});

  @override
  State<GameModeButton> createState() => _GameModeButtonState();
}

class _GameModeButtonState extends State<GameModeButton> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MinesAndFlags extends StatelessWidget {
  final int flags;
  final int mines;

  const MinesAndFlags({
    super.key,
    required this.flags,
    required this.mines,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Row(
      children: [
        Text(
          " $flags ",
          style: textTheme.bodyLarge,
        ),
        const Icon(
          Icons.flag_outlined,
          color: flagColor,
        ),
        Text(
          "/ $mines ",
          style: textTheme.bodyLarge,
        ),
        const Icon(
          Icons.gps_fixed,
          color: mineColor,
        ),
      ],
    );
  }
}