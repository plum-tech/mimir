import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/game/2048/widget/tile.dart';

import '../theme.dart';
import '../i18n.dart';
import '../manager/board.dart';

import 'animated_tile.dart';
import 'button.dart';

class TileBoardWidget extends ConsumerWidget {
  const TileBoardWidget({super.key, required this.moveAnimation, required this.scaleAnimation});

  final CurvedAnimation moveAnimation;
  final CurvedAnimation scaleAnimation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(boardManager);

    //Decides the maximum size the Board can be based on the shortest size of the screen.
    final size = max(290.0, min((MediaQuery.of(context).size.shortestSide * 0.90).floorToDouble(), 460.0));

    //Decide the size of the tile based on the size of the board minus the space between each tile.
    final sizePerTile = (size / 4).floorToDouble();
    final tileSize = sizePerTile - 12.0 - (12.0 / 4);
    final boardSize = sizePerTile * 4;
    return SizedBox(
      width: boardSize,
      height: boardSize,
      child: Stack(
        children: [
          ...List.generate(
            board.tiles.length,
            (i) {
              var tile = board.tiles[i];

              return AnimatedTile(
                key: ValueKey(tile.id),
                tile: tile,
                moveAnimation: moveAnimation,
                scaleAnimation: scaleAnimation,
                size: tileSize,
                //In order to optimize performances and prevent unneeded re-rendering the actual tile is passed as child to the AnimatedTile
                //as the tile won't change for the duration of the movement (apart from it's position)
                child: BoardTile(
                  size: tileSize,
                  color: tileColors[tile.value] ?? defaultTileColor,
                  child: AutoSizeText(
                    '${tile.value}',
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: context.textTheme.headlineLarge?.fontSize,
                      color: tile.value < 8 ? textColor : textColorWhite,
                    ),
                  ).center().padH(4),
                ),
              );
            },
          ),
          if (board.over)
            Positioned.fill(
                child: Container(
              color: overlayColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    board.won ? i18n.youWin : i18n.gameOver,
                    style: const TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 64.0),
                  ),
                  ButtonWidget(
                    text: board.won ? i18n.newGame : i18n.tryAgain,
                    onPressed: () {
                      ref.read(boardManager.notifier).newGame();
                    },
                  )
                ],
              ),
            ))
        ],
      ),
    );
  }
}
