import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/game/2048/card.dart';
import 'package:mimir/game/minesweeper/card.dart';
import 'package:mimir/game/sudoku/card.dart';
import 'package:mimir/game/wordle/card.dart';
import 'package:mimir/settings/dev.dart';

import "i18n.dart";
import 'widget/card.dart';

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key});

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  @override
  Widget build(BuildContext context) {
    final devMode = ref.watch(Dev.$on);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                title: i18n.navigation.text(),
                forceElevated: innerBoxIsScrolled,
              ),
            ),
          ];
        },
        body: CustomScrollView(
          slivers: [
            SliverList.list(
              children: [
                const GameAppCard2048(),
                const GameAppCardMinesweeper(),
                const GameAppCardSudoku(),
                if (devMode) const GameAppCardWordle(),
                if (devMode)
                  const OfflineGameAppCard(
                    name: "SIT Suika",
                    baseRoute: "/suika",
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
