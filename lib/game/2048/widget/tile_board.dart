import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/game/2048/widget/tile.dart';

import '../page/game.dart';
import '../theme.dart';

import 'animated_tile.dart';

class TileBoardWidget extends ConsumerWidget {
  final CurvedAnimation moveAnimation;
  final CurvedAnimation scaleAnimation;

  const TileBoardWidget({
    super.key,
    required this.moveAnimation,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(state2048);

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
        ],
      ),
    );
  }
}
