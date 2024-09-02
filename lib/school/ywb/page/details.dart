import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mimir/utils/error.dart';
import 'package:mimir/utils/guard_launch.dart';
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

import '../entity/service.dart';
import '../init.dart';
import '../page/form.dart';
import '../widgets/detail.dart';
import "../i18n.dart";

class YwbServiceDetailsPage extends StatefulWidget {
  final YwbService meta;

  const YwbServiceDetailsPage({
    super.key,
    required this.meta,
  });

  @override
  State<YwbServiceDetailsPage> createState() => _YwbServiceDetailsPageState();
}

class _YwbServiceDetailsPageState extends State<YwbServiceDetailsPage> {
  String get id => widget.meta.id;

  String get name => widget.meta.name;
  late YwbServiceDetails? details = YwbInit.serviceStorage.getServiceDetails(id);
  final controller = ScrollController();
  bool fetching = false;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    if (!mounted) return;
    setState(() {
      fetching = true;
    });
    try {
      final meta = await YwbInit.serviceService.getServiceDetails(id);
      YwbInit.serviceStorage.setMetaDetails(id, meta);
      if (!mounted) return;
      setState(() {
        fetching = false;
        details = meta;
      });
    } catch (error, stackTrace) {
      handleRequestError(error, stackTrace);
      if (!mounted) return;
      setState(() {
        fetching = false;
      });
    }
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
            SliverAppBar.medium(
              title: name.text(),
              actions: [
                PlatformTextButton(
                  onPressed: openInApp,
                  child: i18n.details.apply.text(),
                )
              ],
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
      floatingActionButton: !fetching ? null : const CircularProgressIndicator.adaptive(),
    );
  }

  void openInApp() {
    if (kIsWeb || UniversalPlatform.isDesktop) {
      guardLaunchUrlString(context, "http://ywb.sit.edu.cn/v1/#/");
    } else {
      // 跳转到申请页面
      final String applyUrl =
          'http://ywb.sit.edu.cn/v1/#/flow?src=http://ywb.sit.edu.cn/unifri-flow/WF/MyFlow.htm?FK_Flow=$id&title=${widget.meta.name}';
      context.navigator.push(MaterialPageRoute(
        builder: (_) => YwbInAppViewPage(
          title: name,
          url: "http://ywb.sit.edu.cn/v1/#/app?appID=${widget.meta.id}&appName=${widget.meta.name}",
        ),
      ));
    }
  }
}
