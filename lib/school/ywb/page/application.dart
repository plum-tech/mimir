import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/utils/error.dart';

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
  late final $loadingStates = ValueNotifier(YwbApplicationType.values.map((type) => false).toList());

  @override
  void dispose() {
    $loadingStates.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: PreferredSize(
        preferredSize: const Size.fromHeight(4),
        child: $loadingStates >>
            (ctx, states) {
              return !states.any((state) => state == true) ? const SizedBox.shrink() : const LinearProgressIndicator();
            },
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
                        .map((type) => Tab(
                              child: type.l10nName().text(),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            // These are the contents of the tab views, below the tabs.
            children: YwbApplicationType.values.mapIndexed((i, type) {
              return YwbApplicationLoadingList(
                type: type,
                onLoadingChanged: (bool value) {
                  final newStates = List.of($loadingStates.value);
                  newStates[i] = value;
                  $loadingStates.value = newStates;
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class YwbApplicationLoadingList extends StatefulWidget {
  final YwbApplicationType type;
  final ValueChanged<bool> onLoadingChanged;

  const YwbApplicationLoadingList({
    super.key,
    required this.type,
    required this.onLoadingChanged,
  });

  @override
  State<YwbApplicationLoadingList> createState() => _YwbApplicationLoadingListState();
}

class _YwbApplicationLoadingListState extends State<YwbApplicationLoadingList> with AutomaticKeepAliveClientMixin {
  bool isFetching = false;
  late var applications = YwbInit.applicationStorage.getApplicationListOf(widget.type);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      await fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final applications = this.applications;
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          // This is the flip side of the SliverOverlapAbsorber above.
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        if (applications != null)
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
              itemBuilder: (ctx, index) {
                return YwbApplicationTile(applications[index]);
              },
            ),
      ],
    );
  }

  Future<void> fetch() async {
    if (isFetching) return;
    if (!mounted) return;
    setState(() {
      isFetching = true;
    });
    widget.onLoadingChanged(true);
    final type = widget.type;
    try {
      final applications = await YwbInit.applicationService.getApplicationsOf(type);
      await YwbInit.applicationStorage.setApplicationListOf(type, applications);
      if (!mounted) return;
      setState(() {
        this.applications = applications;
        isFetching = false;
      });
      widget.onLoadingChanged(false);
    } catch (error, stackTrace) {
      handleRequestError(error, stackTrace);
      if (!mounted) return;
      setState(() {
        isFetching = false;
      });
      widget.onLoadingChanged(false);
    }
  }
}
