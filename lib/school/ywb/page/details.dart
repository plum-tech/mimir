import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/fab.dart';
import 'package:mimir/utils/guard_launch.dart';
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

import '../entity/meta.dart';
import '../init.dart';
import '../page/form.dart';
import '../widgets/detail.dart';
import "../i18n.dart";

class YwbApplicationDetailsPage extends StatefulWidget {
  final YwbApplicationMeta meta;

  const YwbApplicationDetailsPage({super.key, required this.meta});

  @override
  State<YwbApplicationDetailsPage> createState() => _YwbApplicationDetailsPageState();
}

class _YwbApplicationDetailsPageState extends State<YwbApplicationDetailsPage> {
  YwbApplicationMeta get meta => widget.meta;
  YwbApplicationMetaDetails? details;
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    YwbInit.metaService.getApplicationDetails(meta.id).then((value) {
      if (!mounted) return;
      setState(() {
        details = value;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final details = this.details;
    return Scaffold(
      body: CustomScrollView(
        controller: controller,
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(meta.name).hero(meta.id),
            bottom: details != null
                ? null
                : const PreferredSize(
                    preferredSize: Size.fromHeight(4),
                    child: LinearProgressIndicator(),
                  ),
          ),
          if (details != null)
            SliverList.separated(
              itemCount: details.sections.length,
              itemBuilder: (ctx, i) => YwbApplicationDetailSectionBlock(details.sections[i]),
              separatorBuilder: (ctx, i) => const Divider(),
            ),
        ],
      ),
      floatingActionButton: AutoHideFAB.extended(
        controller: controller,
        onPressed: () => openInApp(),
        icon: const Icon(Icons.east),
        label: i18n.apply.text(),
      ),
    );
  }

  void openInApp() {
    if (UniversalPlatform.isDesktopOrWeb) {
      guardLaunchUrlString(context, "http://ywb.sit.edu.cn/v1/#/");
    } else {
      // 跳转到申请页面
      final String applyUrl =
          'http://ywb.sit.edu.cn/v1/#/flow?src=http://ywb.sit.edu.cn/unifri-flow/WF/MyFlow.htm?FK_Flow=${meta.id}';
      context.navigator.push(MaterialPageRoute(builder: (_) => YwbInAppViewPage(title: meta.name, url: applyUrl)));
    }
  }
}
