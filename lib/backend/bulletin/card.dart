import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/backend/bulletin/page/list.dart';
import 'package:mimir/design/adaptive/foundation.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/widgets/app.dart';
import 'package:text_scroll/text_scroll.dart';

import 'entity/bulletin.dart';

class BulletinAppCard extends ConsumerStatefulWidget {
  const BulletinAppCard({super.key});

  @override
  ConsumerState<BulletinAppCard> createState() => _BulletinAppCardState();
}

class _BulletinAppCardState extends ConsumerState<BulletinAppCard> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: "Bulletin".text(),
    );
  }
}

class BulletinCardInAppCard extends StatelessWidget {
  final MimirBulletin bulletin;

  const BulletinCardInAppCard(
    this.bulletin, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var title = bulletin.short;
    var subtitle = bulletin.content;
    if (title.isEmpty && bulletin.content.isNotEmpty) {
      title = bulletin.content;
    }
    if (title == subtitle) {
      subtitle = "";
    }

    return ListTile(
      isThreeLine: subtitle.isNotEmpty,
      leading: const Icon(Icons.announcement),
      title: TextScroll(title),
      subtitle: subtitle.isNotEmpty ? subtitle.text(maxLines: 3) : null,
      onTap: () async {
        context.showSheet(
          useRootNavigator: true,
          (ctx) => const BulletinListPage(),
        );
      },
    ).inCard();
  }
}
