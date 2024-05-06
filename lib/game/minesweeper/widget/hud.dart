import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import '../entity/cell.dart';
import '../entity/mode.dart';
import '../manager/logic.dart';
import '../manager/timer.dart';
import '../i18n.dart';
import '../theme.dart';

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
    final screen = ref.read(boardManager).screen;
    final boardRadius = screen.getBoardRadius();
    final textTheme = context.textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: screen.getBoardSize().width / 2,
          height: screen.getInfoHeight(),
          decoration: BoxDecoration(
            color: context.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(boardRadius),
              bottomLeft: Radius.circular(boardRadius),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(Icons.videogame_asset_outlined),
              ref.read(boardManager).board.started
                  ? MinesAndFlags(
                      flags: ref.read(boardManager).board.countAllByState(state: CellState.flag),
                      mines: ref.read(boardManager).board.mines,
                    )
                  : OutlinedButton.icon(
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
                          ref.read(boardManager.notifier).initGame(gameMode: newMode);
                        }
                      },
                      label: Text(
                        mode.l10n(),
                        style: textTheme.bodyLarge,
                      ),
                    ),
            ],
          ),
        ),
        Container(
          width: screen.getBoardSize().width / 2,
          height: screen.getInfoHeight(),
          decoration: BoxDecoration(
            color: context.colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(boardRadius),
              bottomRight: Radius.circular(boardRadius),
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
