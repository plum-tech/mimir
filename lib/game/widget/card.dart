import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/widgets/app.dart';

import '../storage/save.dart';
import '../i18n.dart';

class OfflineGameAppCard extends ConsumerWidget {
  final String name;
  final String baseRoute;
  final Widget? view;
  final bool supportRecords;
  final bool supportLeaderboard;
  final GameSaveStorage? save;

  const OfflineGameAppCard({
    super.key,
    this.view,
    required this.baseRoute,
    required this.name,
    this.supportRecords = false,
    this.supportLeaderboard = false,
    this.save,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final save = this.save;
    var hasSave = false;
    if (save != null) {
      hasSave |= ref.watch(save.$saveExistsOf(0));
    }
    return AppCard(
      title: name.text(),
      view: view,
      leftActions: [
        if (hasSave != true)
          FilledButton(
            onPressed: () {
              context.push("/game$baseRoute");
            },
            child: i18n.newGame.text(),
          )
        else ...[
          FilledButton(
            onPressed: () {
              context.push("/game$baseRoute?continue");
            },
            child: i18n.continueGame.text(),
          ),
          OutlinedButton(
            onPressed: () {
              context.push("/game$baseRoute");
            },
            child: i18n.newGame.text(),
          )
        ],
      ],
      rightActions: [
        if (supportRecords)
          PlatformIconButton(
            onPressed: () {
              context.push("/game$baseRoute/records");
            },
            icon: const Icon(Icons.history),
          ),
        if (supportLeaderboard)
          PlatformIconButton(
            onPressed: () {
              context.push("/game$baseRoute/leaderboard");
            },
            icon: const Icon(Icons.leaderboard),
          ),
      ],
    );
  }
}
