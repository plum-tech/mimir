import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/r.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/game/2048/card.dart';
import 'package:mimir/game/minesweeper/card.dart';
import 'package:mimir/game/sudoku/card.dart';

import "i18n.dart";

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key});

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
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
                floating: true,
                snap: true,
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
                if (context.locale == R.zhHansLocale)
                  const Opacity(
                    opacity: 0.75,
                    child: CnBureauAdvice4Game(),
                  ).padSymmetric(h: 8, v: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CnBureauAdvice4Game extends StatelessWidget {
  const CnBureauAdvice4Game({super.key});

  @override
  Widget build(BuildContext context) {
    Widget title(String text) => text.text(textAlign: TextAlign.center);
    Widget sub(String text) => text.text(style: context.textTheme.labelMedium, textAlign: TextAlign.center);
    return [
      title("健康游戏忠告"),
      sub("抵制不良游戏，拒绝盗版游戏。"),
      sub("注意自我保护，谨防受骗上当。"),
      sub("适度游戏益脑，沉迷游戏伤身。"),
      sub("合理安排时间，享受健康生活。"),
    ].column();
  }
}
