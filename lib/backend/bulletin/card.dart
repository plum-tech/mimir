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

class BulletinLatestSummaryCard extends StatelessWidget {
  final MimirBulletin bulletin;

  const BulletinLatestSummaryCard(
    this.bulletin, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var title = bulletin.short;
    var subtitle = bulletin.text;
    if (title.isEmpty && bulletin.text.isNotEmpty) {
      title = bulletin.text;
    }
    if (title == subtitle) {
      subtitle = "";
    }

    return ListTile(
      leading: const Icon(Icons.announcement),
      title: TextScroll(title),
      subtitle: subtitle.isNotEmpty
          ? subtitle.text(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      onTap: () async {
        context.showSheet(
          (ctx) => const BulletinListPage(),
        );
      },
    ).inCard(clip: Clip.hardEdge);
  }
}
