import 'package:collection/collection.dart';
import 'package:fit_system_screenshot/fit_system_screenshot.dart';
import 'package:flutter/material.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/common.dart';
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
  Dispose? screenShotDispose;
  final scrollAreaKey = GlobalKey();
  final scrollController = ScrollController();

  /// in descending order
  List<YwbService>? metaList;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    screenShotDispose = fitSystemScreenshot.attachToPage(
      scrollAreaKey,
      scrollController,
      scrollController.jumpTo,
    );
  }

  @override
  void dispose() {
    screenShotDispose?.call();
    scrollController.dispose();
    super.dispose();
  }

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
      handleRequestError(context, error, stackTrace);
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
        key: scrollAreaKey,
        controller: scrollController,
        slivers: [
          SliverAppBar(
            floating: true,
            title: i18n.title.text(),
            actions: [
              Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                message: i18n.info,
                child: Icon(context.icons.info).padAll(8),
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
