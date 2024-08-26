import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/backend/bulletin/entity/bulletin.dart';
import 'package:sit/backend/init.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/app.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/settings/dev.dart';
import 'package:sit/utils/guard_launch.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:universal_platform/universal_platform.dart';

class ForumAppCard extends ConsumerStatefulWidget {
  const ForumAppCard({super.key});

  @override
  ConsumerState<ForumAppCard> createState() => _ForumAppCardState();
}

class _ForumAppCardState extends ConsumerState<ForumAppCard> {
  MimirBulletin? bulletin;

  Future<void> updateBulletin() async {
    final bulletin = await BackendInit.bulletin.getLatest();
    setState(() {
      if (bulletin == null) {
        this.bulletin = null;
      } else {
        this.bulletin = bulletin.isEmpty ? null : bulletin;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    updateBulletin();
  }

  @override
  Widget build(BuildContext context) {
    final bulletin = this.bulletin;
    final dev = ref.watch(Dev.$on);
    return AppCard(
      title: "小应社区".text(),
      view: bulletin == null ? null : buildBulletin(bulletin),
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
          label: !dev
              ? "敬请期待".text()
              : "进入".text(),
          icon: Icon(context.icons.home),
        ),
      ],
    );
  }

  Widget buildBulletin(MimirBulletin bulletin) {
    var title = bulletin.short;
    var subtitle = bulletin.content;
    if (title.isEmpty && bulletin.content.isNotEmpty) {
      title = bulletin.content;
    }
    if (title == subtitle) {
      subtitle = "";
    }

    return ListTile(
      leading: const Icon(Icons.announcement),
      title: TextScroll(title),
      subtitle: subtitle.isNotEmpty ? TextScroll(subtitle) : null,
      // subtitle: context.formatYmdhmNum(bulletin.createdAt).text(),
    ).inCard();
  }
}
