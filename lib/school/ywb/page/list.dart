import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/application.dart';
import '../init.dart';
import '../widgets/application.dart';
import "package:mimir/credential/widgets/oa_scope.dart";
import '../i18n.dart';

// 本科生常用功能列表
const _commonUsed = <String>{'121', '011', '047', '123', '124', '024', '125', '165', '075', '202', '023', '067', '059'};

class YwbApplicationListPage extends StatefulWidget {
  const YwbApplicationListPage({super.key});

  @override
  State<YwbApplicationListPage> createState() => _YwbApplicationListPageState();
}

class _YwbApplicationListPageState extends State<YwbApplicationListPage> {
  var enableFilter = false;

  /// in descending order
  List<ApplicationMeta>? metas;

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

  Future<List<ApplicationMeta>?> fetchMetaList() async {
    final oaCredential = context.auth.credentials;
    if (oaCredential == null) return null;
    // TODO: login here is so weired
    if (!YwbInit.session.isLogin) {
      await YwbInit.session.login(
        username: oaCredential.account,
        password: oaCredential.password,
      );
    }
    final metas = await YwbInit.applicationService.getApplicationMetas();
    if (metas == null) return null;
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
                  desc: i18n.desc,
                  ok: i18n.close,
                );
              },
            ),
            IconButton(
              icon: enableFilter ? const Icon(Icons.filter_alt_outlined) : const Icon(Icons.filter_alt_off_outlined),
              tooltip: i18n.filerInfrequentlyUsed,
              onPressed: () {
                setState(() {
                  enableFilter = !enableFilter;
                });
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
                desc: i18n.noApplicationsTip,
              ),
            )
          else
            buildApplicationList(metas),
      ],
    );
  }

  /// [list] is in descending order
  Widget buildApplicationList(List<ApplicationMeta> list) {
    list = enableFilter ? list.where((meta) => _commonUsed.contains(meta.id)).toList() : list;
    return SliverList.builder(
      itemCount: list.length,
      itemBuilder: (ctx, i) => ApplicationTile(meta: list[i], isHot: i < 3),
    );
  }
}
