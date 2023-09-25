import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/meta.dart';
import '../init.dart';
import '../widgets/application.dart';
import '../i18n.dart';

class YwbApplicationMetaListPage extends StatefulWidget {
  const YwbApplicationMetaListPage({super.key});

  @override
  State<YwbApplicationMetaListPage> createState() => _YwbApplicationMetaListPageState();
}

class _YwbApplicationMetaListPageState extends State<YwbApplicationMetaListPage> {
  /// in descending order
  List<YwbApplicationMeta>? metaList;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refresh();
  }

  Future<void> refresh() async {
    if (!mounted) return;
    setState(() {
      metaList = YwbInit.metaStorage.metaList;
      isLoading = true;
    });
    try {
      final metaList = await YwbInit.metaService.getApplicationMetas();
      metaList.sortBy<num>((e) => -e.count);
      YwbInit.metaStorage.metaList = metaList;
      if (!mounted) return;
      setState(() {
        this.metaList = metaList;
        isLoading = false;
      });
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final metas = this.metaList;
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
          bottom: isLoading
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(4),
                  child: LinearProgressIndicator(),
                )
              : null,
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
