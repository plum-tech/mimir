import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/credentials/entity/login_status.dart';
import 'package:sit/credentials/widgets/oa_scope.dart';
import 'package:sit/settings/settings.dart';
import "package:sit/game/2048/i18n.dart" as i18n_2048;
import "package:sit/game/minesweeper/i18n.dart" as i18n_minesweeper;

import "i18n.dart";
import 'widget/card.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  LoginStatus? loginStatus;
  final $campus = Settings.listenCampus();

  @override
  void initState() {
    $campus.addListener(refresh);
    super.initState();
  }

  @override
  void dispose() {
    $campus.removeListener(refresh);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final newLoginStatus = context.auth.loginStatus;
    if (loginStatus != newLoginStatus) {
      setState(() {
        loginStatus = newLoginStatus;
      });
    }
    super.didChangeDependencies();
  }

  void refresh() {
    setState(() {});
  }

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
                GameAppCard(
                  name: i18n_2048.i18n.title,
                  baseRoute: "/2048",
                ),
                GameAppCard(
                  name: i18n_minesweeper.i18n.title,
                  baseRoute: "/minesweeper",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
