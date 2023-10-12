import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sit/design/animation/progress.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/school/ywb/storage/application.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/application.dart';
import '../init.dart';
import '../widgets/application.dart';
import '../i18n.dart';

class YwbMyApplicationListPage extends StatefulWidget {
  const YwbMyApplicationListPage({super.key});

  @override
  State<YwbMyApplicationListPage> createState() => _YwbMyApplicationListPageState();
}

class _YwbMyApplicationListPageState extends State<YwbMyApplicationListPage> {
  MyYwbApplications? allApplications;
  final $loadingProgress = ValueNotifier(0.0);
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    if (!mounted) return;
    setState(() {
      allApplications = YwbInit.applicationStorage.myApplications;
      isFetching = true;
    });
    try {
      final myApplications = await YwbInit.applicationService.getMyApplications(onProgress: (p) {
        $loadingProgress.value = p;
      });
      YwbInit.applicationStorage.myApplications = myApplications;
      if (!mounted) return;
      setState(() {
        allApplications = myApplications;
        isFetching = false;
      });
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      setState(() {
        isFetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final allApplications = this.allApplications;
    return Scaffold(
      bottomNavigationBar: PreferredSize(
        preferredSize: const Size.fromHeight(4),
        child: isFetching ? $loadingProgress >> (ctx, value) => AnimatedProgressBar(value: value) : const SizedBox(),
      ),
      body: DefaultTabController(
        length: YwbApplicationType.values.length,
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            // These are the slivers that show up in the "outer" scroll view.
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  floating: true,
                  title: i18n.mine.title.text(),
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: YwbApplicationType.values
                        .mapIndexed(
                          (i, e) => Tab(
                            child: e.l10nName().text(),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ];
          },
          body: allApplications == null
              ? const SizedBox()
              : TabBarView(
                  // These are the contents of the tab views, below the tabs.
                  children: YwbApplicationType.values.map((type) {
                    return YwbMailList(allApplications.resolve(type));
                  }).toList(),
                ),
        ),
      ),
    );
  }
}

class YwbMailList extends StatelessWidget {
  final List<YwbApplication> applications;

  const YwbMailList(
    this.applications, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          // This is the flip side of the SliverOverlapAbsorber above.
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        if (applications.isEmpty)
          SliverFillRemaining(
            child: LeavingBlank(
              icon: Icons.inbox_outlined,
              desc: i18n.mine.noApplicationsTip,
            ),
          )
        else
          SliverList.builder(
            itemCount: applications.length,
            itemBuilder: (ctx, i) => YwbApplicationTile(applications[i]),
          )
      ],
    );
  }
}
