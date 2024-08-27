import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/backend/bulletin/card.dart';
import 'package:mimir/backend/bulletin/x.dart';
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

class ForumAppCard extends ConsumerStatefulWidget {
  const ForumAppCard({super.key});

  @override
  ConsumerState<ForumAppCard> createState() => _ForumAppCardState();
}

class _ForumAppCardState extends ConsumerState<ForumAppCard> {
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
    final bulletin = ref.watch(BackendInit.bulletinStorage.$latest);
    final dev = ref.watch(Dev.$on);
    return AppCard(
      title: "小应社区".text(),
      view: bulletin == null ? null : BulletinCard(bulletin),
      leftActions: [
        FilledButton.icon(
          onPressed: !dev
              ? null
              : () async {
                  if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
                    await context.push("/forum");
                  } else {
                    await guardLaunchUrl(context, R.forumUri);
                  }
                },
          label: !dev ? "敬请期待".text() : "进入".text(),
          icon: Icon(context.icons.home),
        ),
      ],
    );
  }
}
