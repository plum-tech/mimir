import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/list.dart';
import '../init.dart';
import '../widgets/activity.dart';
import '../widgets/search.dart';
import '../i18n.dart';

class ActivityListPage extends StatefulWidget {
  const ActivityListPage({super.key});

  @override
  State<StatefulWidget> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage> with SingleTickerProviderStateMixin {
  static const categories = [
    Class2ndActivityCat.lecture,
    Class2ndActivityCat.creation,
    Class2ndActivityCat.thematicEdu,
    Class2ndActivityCat.schoolCulture,
    Class2ndActivityCat.practice,
    Class2ndActivityCat.voluntary,
  ];

  final loadingStates = categories.map((cat) => false).toList();

  bool get isAnyLoading => loadingStates.any((state) => state == true);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: buildBody(),
    );
  }

  Widget buildBody() {
    return Scaffold(
      bottomNavigationBar: !isAnyLoading ? null : const PreferredSize(
        preferredSize: Size.fromHeight(4),
        child: LinearProgressIndicator(),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            SliverOverlapAbsorber(
              // This widget takes the overlapping behavior of the SliverAppBar,
              // and redirects it to the SliverOverlapInjector below. If it is
              // missing, then it is possible for the nested "inner" scroll view
              // below to end up under the SliverAppBar even when the inner
              // scroll view thinks it has not been scrolled.
              // This is not necessary if the "headerSliverBuilder" only builds
              // widgets that do not overlap the next sliver.
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                pinned: true,
                title: i18n.title.text(),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => showSearch(context: context, delegate: ActivitySearchDelegate()),
                  ),
                ],
                // The "forceElevated" property causes the SliverAppBar to show
                // a shadow. The "innerBoxIsScrolled" parameter is true when the
                // inner scroll view is scrolled beyond its "zero" point, i.e.
                // when it appears to be scrolled below the SliverAppBar.
                // Without this, there are cases where the shadow would appear
                // or not appear inappropriately, because the SliverAppBar is
                // not actually aware of the precise position of the inner
                // scroll views.
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  isScrollable: true,
                  tabs: categories
                      .mapIndexed((i, e) => Tab(
                            child: e.name.text(),
                          ))
                      .toList(),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          // These are the contents of the tab views, below the tabs.
          children: categories.mapIndexed((i, cat) {
            return ActivityList(
              cat: cat,
              onLoadingChanged: (state) {
                setState(() {
                  loadingStates[i] = state;
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Thanks to the cache, don't worry about that switching tab will re-fetch the activity list.
class ActivityList extends StatefulWidget {
  final Class2ndActivityCat cat;
  final ValueChanged<bool> onLoadingChanged;

  const ActivityList({
    super.key,
    required this.cat,
    required this.onLoadingChanged,
  });

  @override
  State<StatefulWidget> createState() => _ActivityListState();
}

/// Note: Changing orientation will cause a rebuild.
/// The solution is to use any state manager framework, such as `provider`.
class _ActivityListState extends State<ActivityList> {
  int lastPage = 1;
  List<Class2ndActivity> activities = [];
  bool loading = true;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        loadMoreActivities();
      }
    });
    loadMoreActivities();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        key: PageStorageKey(widget.cat),
        slivers: <Widget>[
          SliverOverlapInjector(
            // This is the flip side of the SliverOverlapAbsorber above.
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, index) {
                final activity = activities[index];
                return ActivityCard(activity).hero(activity.id);
              },
              childCount: activities.length,
            ),
          ),
        ],
      ),
    );
  }

  void loadMoreActivities() async {
    setLoading(true);
    final lastActivities = await Class2ndInit.activityListService.getActivityList(widget.cat, lastPage);
    if (lastActivities != null) {
      if (!mounted) return;
      setState(() {
        setLoading(false);
        lastPage++;
        activities.addAll(lastActivities);
        // The incoming activities may be the same as before, so distinct is necessary.
        activities.distinctBy((a) => a.id);
      });
    }
  }

  void setLoading(bool loading) {
    widget.onLoadingChanged(loading);
    setState(() {
      this.loading = loading;
    });
  }
}

extension DistinctEx<E> on List<E> {
  List<E> distinct({bool inplace = true}) {
    final ids = <E>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(x));
    return list;
  }

  List<E> distinctBy<Id>(Id Function(E element) id, {bool inplace = true}) {
    final ids = <Id>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id(x)));
    return list;
  }
}
