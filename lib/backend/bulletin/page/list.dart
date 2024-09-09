import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/backend/bulletin/x.dart';
import 'package:mimir/backend/init.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/widgets/markdown.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/bulletin.dart';
import '../i18n.dart';

class BulletinListPage extends ConsumerStatefulWidget {
  const BulletinListPage({super.key});

  @override
  ConsumerState<BulletinListPage> createState() => _BulletinListPageState();
}

class _BulletinListPageState extends ConsumerState<BulletinListPage> {
  bool fetching = false;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    setState(() {
      fetching = true;
    });
    try {
      await XBulletin.getList();
    } finally {
      if (mounted) {
        setState(() {
          fetching = false;
        });
      }
    }
  }

  List<MimirBulletin>? watchList() {
    var list = ref.watch(BackendInit.bulletinStorage.$list);
    if (list == null) {
      final latest = ref.read(BackendInit.bulletinStorage.$latest);
      if (latest != null) {
        list = [latest];
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var list = watchList();
    return Scaffold(
      floatingActionButton: !fetching ? null : const CircularProgressIndicator.adaptive(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: i18n.title.text(),
          ),
          if (list != null)
            SliverList.builder(
              itemCount: list.length,
              itemBuilder: (ctx, i) {
                return BulletinCard(list[i]).padAll(4);
              },
            )
        ],
      ),
    );
  }
}

class BulletinCard extends StatelessWidget {
  final MimirBulletin bulletin;

  const BulletinCard(
    this.bulletin, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: [
        bulletin.short
            .text(
              style: context.textTheme.titleMedium,
              textAlign: TextAlign.center,
            )
            .padOnly(b: 8),
        FeaturedMarkdownWidget(
          data: bulletin.content,
        ),
        context
            .formatYmdhmNum(bulletin.createdAt)
            .text(
              textAlign: TextAlign.end,
              style: context.textTheme.labelLarge,
            )
            .padOnly(t: 4),
      ].column(caa: CrossAxisAlignment.stretch).padAll(12).inFilledCard(),
    );
  }
}
