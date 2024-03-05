import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/school/i18n.dart' as $school;
import 'package:sit/life/i18n.dart' as $life;
import 'package:sit/game/i18n.dart' as $game;

List<PopupMenuEntry> buildFocusPopupActions(BuildContext context) {
  return [
    const PopupMenuDivider(),
    PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.school_outlined),
        title: $school.i18n.navigation.text(),
      ),
      onTap: () async {
        await context.push("/school");
      },
    ),
    PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.spa_outlined),
        title: $life.i18n.navigation.text(),
      ),
      onTap: () async {
        await context.push("/life");
      },
    ),
    PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.videogame_asset_outlined),
        title: $game.i18n.navigation.text(),
      ),
      onTap: () async {
        await context.push("/game");
      },
    ),
  ];
}
