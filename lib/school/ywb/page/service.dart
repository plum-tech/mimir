import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/utils/error.dart';

import '../entity/service.dart';
import '../init.dart';
import '../widgets/service.dart';
import '../i18n.dart';

class YwbServiceListPage extends StatefulWidget {
  const YwbServiceListPage({super.key});

  @override
  State<YwbServiceListPage> createState() => _YwbServiceListPageState();
}

class _YwbServiceListPageState extends State<YwbServiceListPage> {
  /// in descending order
  List<YwbService>? metaList;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refresh();
  }

  Future<void> refresh() async {
    if (!mounted) return;
    setState(() {
      metaList = YwbInit.serviceStorage.serviceList;
      isLoading = true;
    });
    try {
      final metaList = await YwbInit.serviceService.getServices();
      metaList.sortBy<num>((e) => -e.count);
      YwbInit.serviceStorage.serviceList = metaList;
      if (!mounted) return;
      setState(() {
        this.metaList = metaList;
        isLoading = false;
      });
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final metaList = this.metaList;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
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
          if (metaList != null)
            if (metaList.isEmpty)
              SliverFillRemaining(
                child: LeavingBlank(
                  icon: Icons.inbox_outlined,
                  desc: i18n.noServicesTip,
                ),
              )
            else
              SliverList.builder(
                itemCount: metaList.length,
                itemBuilder: (ctx, i) => YwbServiceTile(meta: metaList[i], isHot: i < 3),
              ),
        ],
      ),
    );
  }
}
