import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/app.dart';

import '../storage/storage.dart';
import '../i18n.dart';

class OfflineGameAppCard extends ConsumerStatefulWidget {
  final String name;
  final String baseRoute;
  final bool supportHistory;
  final bool supportLeaderboard;
  final GameStorageBox? storage;

  const OfflineGameAppCard({
    super.key,
    required this.baseRoute,
    required this.name,
    this.supportHistory = false,
    this.supportLeaderboard = false,
    this.storage,
  });

  @override
  ConsumerState<OfflineGameAppCard> createState() => _OfflineGameAppCardState();
}

class _OfflineGameAppCardState extends ConsumerState<OfflineGameAppCard> {
  @override
  Widget build(BuildContext context) {
    final storage = widget.storage;
    var hasSave = false;
    if (storage != null) {
      hasSave |= ref.watch(storage.$saveExistsFamily(0));
    }
    return AppCard(
      title: widget.name.text(),
      leftActions: [
        if (hasSave != true)
          FilledButton(
            onPressed: () {
              context.push("/game${widget.baseRoute}");
            },
            child: i18n.newGame.text(),
          )
        else ...[
          FilledButton(
            onPressed: () {
              context.push("/game${widget.baseRoute}?continue");
            },
            child: i18n.continueGame.text(),
          ),
          OutlinedButton(
            onPressed: () {
              context.push("/game${widget.baseRoute}");
            },
            child: i18n.newGame.text(),
          )
        ],
      ],
      rightActions: [
        if (widget.supportHistory)
          PlatformIconButton(
            onPressed: () {
              context.push("/game${widget.baseRoute}/history");
            },
            icon: const Icon(Icons.history),
          ),
        if (widget.supportLeaderboard)
          PlatformIconButton(
            onPressed: () {
              context.push("/game${widget.baseRoute}/leaderboard");
            },
            icon: const Icon(Icons.leaderboard),
          ),
      ],
    );
  }
}
