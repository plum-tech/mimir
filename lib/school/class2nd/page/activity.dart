import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/utils/collection.dart';

import '../entity/list.dart';
import '../init.dart';
import '../utils.dart';
import '../widgets/activity.dart';
import '../widgets/search.dart';
import '../i18n.dart';

class ActivityListPage extends StatefulWidget {
  const ActivityListPage({super.key});

  @override
  State<StatefulWidget> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage> with SingleTickerProviderStateMixin {
  final loadingStates = ValueNotifier(commonClass2ndCategories.map((cat) => false).toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: PreferredSize(
        preferredSize: const Size.fromHeight(4),
        child: loadingStates >>
            (ctx, states) {
              return !states.any((state) => state == true) ? const SizedBox() : const LinearProgressIndicator();
            },
      ),
      body: DefaultTabController(
        length: commonClass2ndCategories.length,
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            // These are the slivers that show up in the "outer" scroll view.
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  floating: true,
                  title: i18n.title.text(),
                  forceElevated: innerBoxIsScrolled,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => showSearch(context: context, delegate: ActivitySearchDelegate()),
                    ),
                  ],
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: commonClass2ndCategories
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
          body: TabBarView(
            // These are the contents of the tab views, below the tabs.
            children: commonClass2ndCategories.mapIndexed((i, cat) {
              return ActivityLoadingList(
                cat: cat,
                onLoadingChanged: (state) {
                  final newStates = List.of(loadingStates.value);
                  newStates[i] = state;
                  loadingStates.value = newStates;
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// Thanks to the cache, don't worry about that switching tab will re-fetch the activity list.
class ActivityLoadingList extends StatefulWidget {
  final Class2ndActivityCat cat;
  final ValueChanged<bool> onLoadingChanged;

  const ActivityLoadingList({
    super.key,
    required this.cat,
    required this.onLoadingChanged,
  });

  @override
  State<StatefulWidget> createState() => _ActivityLoadingListState();
}

class _ActivityLoadingListState extends State<ActivityLoadingList> with AutomaticKeepAliveClientMixin {
  int lastPage = 1;
  bool isFetching = false;
  late List<Class2ndActivity> activities =
      Class2ndInit.activityStorage.getActivities(widget.cat) ?? <Class2ndActivity>[];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      await loadMore();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationListener<ScrollNotification>(
      onNotification: (event) {
        if (event.metrics.pixels >= event.metrics.maxScrollExtent) {
          loadMore();
        }
        return true;
      },
      child: CustomScrollView(
        // CAN'T USE ScrollController, and I don't know why
        // controller: scrollController,
        slivers: <Widget>[
          SliverOverlapInjector(
            // This is the flip side of the SliverOverlapAbsorber above.
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverList.builder(
            itemCount: activities.length,
            itemBuilder: (ctx, index) {
              final activity = activities[index];
              return ActivityCard(
                activity,
                onTap: () async {
                  await context.push(
                    "/class2nd/activity-details/${activity.id}?title=${activity.title}&time=${activity.time}&enable-apply=true",
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> loadMore() async {
    if (isFetching) return;
    if (!mounted) return;
    setState(() {
      isFetching = true;
    });
    widget.onLoadingChanged(true);
    try {
      final lastActivities = await Class2ndInit.activityService.getActivityList(widget.cat, lastPage);
      activities.addAll(lastActivities);
      // The incoming activities may be the same as before, so distinct is necessary.
      activities.distinctBy((a) => a.id);
      activities.sort((a,b)=>b.time.compareTo(a.time));
      await Class2ndInit.activityStorage.setActivities(widget.cat, List.of(activities));
      if (!mounted) return;
      setState(() {
        lastPage++;
        isFetching = false;
      });
      widget.onLoadingChanged(false);
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      setState(() {
        isFetching = false;
      });
      widget.onLoadingChanged(false);
    }
  }
}

