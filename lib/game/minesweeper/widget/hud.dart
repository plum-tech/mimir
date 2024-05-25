import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/game/entity/game_status.dart';
import '../entity/cell.dart';
import '../theme.dart';
import '../page/game.dart';
import '../i18n.dart';

class GameHud extends ConsumerWidget {
  const GameHud({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stateMinesweeper);
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
            state.status == GameStatus.running
                ? MinesAndFlags(
                    flags: state.board.countAllByState(state: CellState.flag),
                    mines: state.board.mines,
                  )
                : Text(
                    state.mode.l10n(),
                    style: context.textTheme.bodyLarge,
                  ),
          ].row(maa: MainAxisAlignment.spaceAround),
        ).expanded(),
        Container(
          decoration: BoxDecoration(
            color: context.colorScheme.tertiaryContainer,
          ),
          child: [
            const Icon(Icons.alarm),
            Text(
              i18n.formatPlaytime(state.playtime),
              style: textTheme.bodyLarge,
            ),
          ].row(maa: MainAxisAlignment.spaceAround),
        ).expanded(),
      ].row(maa: MainAxisAlignment.center, caa: CrossAxisAlignment.stretch).sized(h: 50),
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
