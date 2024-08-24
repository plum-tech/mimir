import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/backend/bulletin/entity/bulletin.dart';
import 'package:sit/backend/init.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/app.dart';
import 'package:sit/l10n/extension.dart';
import 'package:text_scroll/text_scroll.dart';

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
      this.bulletin = bulletin;
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
    return AppCard(
      title: "小应社区".text(),
      view: bulletin == null ? null : buildBulletin(bulletin),
      leftActions: [
        FilledButton.icon(
          onPressed: () async {
            await context.push("/forum");
          },
          label: "进入".text(),
          icon: Icon(context.icons.home),
        ),
      ],
    );
  }

  Widget buildBulletin(MimirBulletin bulletin) {
    return ListTile(
      leading: const Icon(Icons.announcement),
      title: TextScroll(bulletin.content.trim()),
      subtitle: context.formatYmdhmNum(bulletin.createdAt).text(),
    ).inCard();
  }
}
