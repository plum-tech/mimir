import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/adaptive/menu.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/school/i18n.dart' as $school;
import 'package:sit/life/i18n.dart' as $life;
import 'package:sit/game/i18n.dart' as $game;
import 'package:sit/me/i18n.dart' as $me;
import 'package:sit/settings/dev.dart';

List<PullDownEntry> buildFocusPopupActions(BuildContext context) {
  return [
    const PullDownDivider(),
      PullDownItem(
        icon: context.icons.person,
        title: $me.i18n.navigation,
        onTap: () async {
          await context.push("/me");
        },
      ),
    PullDownItem(
      icon: Icons.school_outlined,
      title: $school.i18n.navigation,
      onTap: () async {
        await context.push("/school");
      },
    ),
    PullDownItem(
      icon: Icons.spa_outlined,
      title: $life.i18n.navigation,
      onTap: () async {
        await context.push("/life");
      },
    ),
    if (Dev.on)
      PullDownItem(
        icon: Icons.videogame_asset_outlined,
        title: $game.i18n.navigation,
        onTap: () async {
          await context.push("/game");
        },
      ),
  ];
}
