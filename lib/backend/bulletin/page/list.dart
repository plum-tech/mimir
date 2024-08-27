import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/backend/bulletin/x.dart';
import 'package:mimir/backend/init.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';
import 'package:text_scroll/text_scroll.dart';

import '../entity/bulletin.dart';

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
      setState(() {
        fetching = false;
      });
    }
  }

  List<MimirBulletin>? watchList(){
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: "Bulletin List".text(),
            bottom: !fetching
                ? null
                : const PreferredSize(
                    preferredSize: Size.fromHeight(4),
                    child: LinearProgressIndicator(),
                  ),
          ),
          if (list != null)
            SliverList.builder(
              itemCount: list.length,
              itemBuilder: (ctx, i) {
                return BulletinCard(list[i]);
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
    var title = bulletin.short;
    var subtitle = bulletin.content;
    if (title.isEmpty && bulletin.content.isNotEmpty) {
      title = bulletin.content;
    }
    if (title == subtitle) {
      subtitle = "";
    }

    return ListTile(
      title: TextScroll(title),
      subtitle: [
        if (subtitle.isNotEmpty) subtitle.text(maxLines: 3),
        context.formatYmdhmNum(bulletin.createdAt).text(textAlign: TextAlign.end).padOnly(t: 4),
      ].column(caa: CrossAxisAlignment.stretch),
    ).inFilledCard();
  }
}
