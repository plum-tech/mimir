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

class YwbApplicationMetaDetailsPage extends StatefulWidget {
  final YwbApplicationMeta meta;

  const YwbApplicationMetaDetailsPage({super.key, required this.meta});

  @override
  State<YwbApplicationMetaDetailsPage> createState() => _YwbApplicationMetaDetailsPageState();
}

class _YwbApplicationMetaDetailsPageState extends State<YwbApplicationMetaDetailsPage> {
  YwbApplicationMetaDetails? details;
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    // TODO: Cache
    YwbInit.metaService.getApplicationDetails(widget.meta.id).then((value) {
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
      body: SelectionArea(
        child: CustomScrollView(
          controller: controller,
          slivers: [
            SliverAppBar(
              floating: true,
              title: Text(widget.meta.name).hero(widget.meta.id),
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
      ),
      floatingActionButton: AutoHideFAB.extended(
        controller: controller,
        onPressed: () => openInApp(),
        icon: const Icon(Icons.east),
        label: i18n.details.apply.text(),
      ),
    );
  }

  void openInApp() {
    if (UniversalPlatform.isDesktopOrWeb) {
      guardLaunchUrlString(context, "http://ywb.sit.edu.cn/v1/#/");
    } else {
      // 跳转到申请页面
      final String applyUrl =
          'http://ywb.sit.edu.cn/v1/#/flow?src=http://ywb.sit.edu.cn/unifri-flow/WF/MyFlow.htm?FK_Flow=${widget.meta.id}';
      context.navigator
          .push(MaterialPageRoute(builder: (_) => YwbInAppViewPage(title: widget.meta.name, url: applyUrl)));
    }
  }
}
