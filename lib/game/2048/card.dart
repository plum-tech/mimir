import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/animation/number.dart';
import 'package:sit/game/2048/storage.dart';
import 'package:sit/game/widget/card.dart';

import 'i18n.dart';

class GameAppCard2048 extends StatefulWidget {
  const GameAppCard2048({
    super.key,
  });

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
      view: const BestScore2048Card(),
    );
  }
}

class BestScore2048Card extends ConsumerWidget {
  const BestScore2048Card({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final best = ref.watch(Storage2048.record.$bestScore);
    final maxNumber = ref.watch(Storage2048.record.$maxNumber);
    return [
      Card(
        child: ListTile(
          leading: const Icon(Icons.score),
          title: i18n.best.text(maxLines: 1),
          subtitle: AnimatedNumber(
            value: best,
            builder: (ctx,v) => "${v.toInt()}".text(),
          ),
        ),
      ).expanded(),
      Card(
        child: ListTile(
          leading: const Icon(Icons.numbers),
          title: i18n.max.text(maxLines: 1),
          subtitle: AnimatedNumber(
            value: maxNumber,
            builder: (ctx,v) => "${v.toInt()}".text(),
          ),
        ),
      ).expanded(),
    ].row(maa: MainAxisAlignment.spaceEvenly, mas: MainAxisSize.min, caa: CrossAxisAlignment.start);
  }
}
