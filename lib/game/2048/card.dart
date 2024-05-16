import 'package:flutter/material.dart';
import 'package:sit/game/2048/storage.dart';
import 'package:sit/game/2048/entity/save.dart';
import 'package:sit/game/widget/card.dart';

import 'i18n.dart';

class GameAppCard2048 extends StatefulWidget {
  const GameAppCard2048({super.key});

  @override
  State<GameAppCard2048> createState() => _GameAppCard2048State();
}

class _GameAppCard2048State extends State<GameAppCard2048> {
  @override
  Widget build(BuildContext context) {
    return OfflineGameAppCard(
      name: i18n.title,
      baseRoute: "/2048",
      save: Storage2048.save,
      supportRecords: true,
    );
  }
}
