import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sit/game/widget/card.dart';

import 'i18n.dart';
import 'storage.dart';

class GameAppCardWordle extends ConsumerStatefulWidget {
  const GameAppCardWordle({super.key});

  @override
  ConsumerState<GameAppCardWordle> createState() => _GameAppCardWordleState();
}

class _GameAppCardWordleState extends ConsumerState<GameAppCardWordle> {
  @override
  Widget build(BuildContext context) {
    return OfflineGameAppCard(
      name: i18n.title,
      baseRoute: "/wordle",
      save: StorageWordle.save,
      // supportRecords: true,
      // view: buildGameModeCard().align(at: Alignment.centerLeft),
    );
  }
}
