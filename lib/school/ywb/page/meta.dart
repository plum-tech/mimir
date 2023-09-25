import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/meta.dart';
import '../init.dart';
import '../widgets/application.dart';
import "package:mimir/credential/widgets/oa_scope.dart";
import '../i18n.dart';

class YwbApplicationMetaListPage extends StatefulWidget {
  const YwbApplicationMetaListPage({super.key});

  @override
  State<YwbApplicationMetaListPage> createState() => _YwbApplicationMetaListPageState();
}

class _YwbApplicationMetaListPageState extends State<YwbApplicationMetaListPage> {
  /// in descending order
  List<YwbApplicationMeta>? metas;

  @override
  void didChangeDependencies() {
    fetchMetaList().then((value) {
      if (!mounted) return;
      setState(() {
        metas = value;
      });
    });
    super.didChangeDependencies();
  }

  Future<List<YwbApplicationMeta>?> fetchMetaList() async {
    final oaCredential = context.auth.credentials;
    if (oaCredential == null) return null;
    // TODO: login here is so weired
    if (!YwbInit.session.isLogin) {
      await YwbInit.session.login(
        username: oaCredential.account,
        password: oaCredential.password,
      );
    }
    final metas = await YwbInit.metaService.getApplicationMetas();
    metas.sortBy<num>((e) => -e.count);
    return metas;
  }

  @override
  Widget build(BuildContext context) {
    final metas = this.metas;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: i18n.title.text(),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () async {
                await context.showTip(
                  title: i18n.title,
                  desc: i18n.info,
                  ok: i18n.close,
                );
              },
            ),
          ],
          bottom: metas != null
              ? null
              : const PreferredSize(
                  preferredSize: Size.fromHeight(4),
                  child: LinearProgressIndicator(),
                ),
        ),
        if (metas != null)
          if (metas.isEmpty)
            SliverFillRemaining(
              child: LeavingBlank(
                icon: Icons.inbox_outlined,
                desc: i18n.noMetaTip,
              ),
            )
          else
            SliverList.builder(
              itemCount: metas.length,
              itemBuilder: (ctx, i) => ApplicationTile(meta: metas[i], isHot: i < 3),
            ),
      ],
    );
  }
}
