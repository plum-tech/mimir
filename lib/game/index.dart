import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/game/2048/card.dart';
import 'package:sit/game/minesweeper/card.dart';

import "i18n.dart";

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  @override
  Widget build(BuildContext context) {
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
