import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/backend/bulletin/card.dart';
import 'package:mimir/backend/bulletin/page/list.dart';
import 'package:mimir/backend/bulletin/x.dart';
import 'package:mimir/design/adaptive/foundation.dart';
import 'package:mimir/life/event.dart';
import 'package:mimir/utils/async_event.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/backend/init.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/design/widgets/app.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/settings/dev.dart';
import 'package:mimir/utils/guard_launch.dart';
import 'package:universal_platform/universal_platform.dart';
import "package:mimir/backend/bulletin/i18n.dart" as $bulletin;
import '../i18n.dart';

class ForumAppCard extends ConsumerStatefulWidget {
  const ForumAppCard({super.key});

  @override
  ConsumerState<ForumAppCard> createState() => _ForumAppCardState();
}

class _ForumAppCardState extends ConsumerState<ForumAppCard> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final EventSubscription $refreshEvent;

  @override
  void initState() {
    super.initState();
    $refreshEvent = lifeEventBus.addListener(() async {
      await XBulletin.getLatest();
    });
    XBulletin.getLatest();
  }

  @override
  dispose() {
    $refreshEvent.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bulletin = ref.watch(BackendInit.bulletinStorage.$latest);
    final dev = ref.watch(Dev.$on);
    return AppCard(
      title: i18n.forum.title.text(),
      view: bulletin == null ? null : BulletinLatestSummaryCard(bulletin),
      leftActions: [
        FilledButton.icon(
          onPressed: !dev
              ? null
              : () async {
                  if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
                    await context.push("/mimir/forum");
                  } else {
                    await guardLaunchUrl(context, R.forumUri);
                  }
                },
          label: !dev ? i18n.comingSoon.text() : i18n.enter.text(),
          icon: Icon(context.icons.home),
        ),
        FilledButton.tonalIcon(
          onPressed: () async {
            context.showSheet(
              (ctx) => const BulletinListPage(),
            );
          },
          label: $bulletin.i18n.title.text(),
          icon: const Icon(Icons.list_alt),
        ),
      ],
    );
  }
}
