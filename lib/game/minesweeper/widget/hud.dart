import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/game/entity/game_state.dart';
import '../entity/cell.dart';
import '../entity/mode.dart';
import '../manager/timer.dart';
import '../i18n.dart';
import '../theme.dart';
import '../page/game.dart';

class GameHud extends ConsumerWidget {
  final GameTimer timer;
  final GameMode mode;

  const GameHud({
    super.key,
    required this.mode,
    required this.timer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.read(minesweeperState);
    final textTheme = context.textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(Icons.videogame_asset_outlined),
              board.state == GameState.running
                  ? MinesAndFlags(
                      flags: ref.read(minesweeperState).board.countAllByState(state: CellState.flag),
                      mines: ref.read(minesweeperState).board.mines,
                    )
                  : buildGameModeButton(context, ref),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: context.colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(Icons.alarm),
              Text(
                timer.getTimeCost(),
                style: textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildGameModeButton(BuildContext context, WidgetRef ref) {
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
