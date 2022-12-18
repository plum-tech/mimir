import 'package:auto_animated/auto_animated.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/list.dart';
import '../init.dart';
import '../user_widgets/card.dart';
import '../using.dart';

class ActivityListPage extends StatefulWidget {
  const ActivityListPage({super.key});

  @override
  State<StatefulWidget> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin, AdaptivePageProtocol {
  static const categories = [
    ActivityType.lecture,
    ActivityType.creation,
    ActivityType.thematicEdu,
    ActivityType.schoolCulture,
    ActivityType.practice,
    ActivityType.voluntary,
  ];

  late TabController _tabController;

  final $page = ValueNotifier(0);
  bool init = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: categories.length,
      vsync: this,
    );
    _tabController.addListener(() => $page.value = _tabController.index);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  TabBar _buildBarHeader(BuildContext ctx) {
    return TabBar(
      isScrollable: true,
      controller: _tabController,
      tabs: categories
          .mapIndexed((i, e) =>
              $page <<
              (ctx, page, child) {
                return Tab(
                    child: e.name
                        .text(style: page == i ? TextStyle(color: ctx.textColor) : ctx.theme.textTheme.bodyLarge));
              })
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
        length: categories.length, child: context.isPortrait ? buildPortrait(context) : buildLandscape(context));
  }

  Widget buildLandscape(BuildContext ctx) {
    return AdaptiveNavigation(
      child: buildBody(ctx),
    );
  }

  Widget buildPortrait(BuildContext ctx) {
    return buildBody(ctx);
  }

  Widget buildBody(BuildContext ctx) {
    return Scaffold(
      appBar: _buildBarHeader(context),
      body: TabBarView(
        controller: _tabController,
        children: categories.map((selectedActivityType) {
          return ValueListenableBuilder(
            valueListenable: $page,
            builder: (context, index, child) {
              return ActivityList(selectedActivityType);
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

///
/// Thanks to the cache, don't worry about that switching tab will re-fetch the activity list.
class ActivityList extends StatefulWidget {
  final ActivityType type;

  const ActivityList(this.type, {super.key});

  @override
  State<StatefulWidget> createState() => _ActivityListState();
}

/// Note: Changing orientation will cause a rebuild.
/// The solution is to use any state manager framework, such as `provider`.
class _ActivityListState extends State<ActivityList> {
  int _lastPage = 1;
  bool _atEnd = false;
  List<Activity> _activityList = [];

  bool loading = true;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!_atEnd) {
          loadMoreActivities();
        }
      } else {
        setState(() {
          _atEnd = false;
        });
      }
    });
    loadInitialActivities();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Placeholders.loading();
    } else {
      return buildActivityResult(_activityList);
    }
  }

  void loadInitialActivities() async {
    if (!mounted) return;
    setState(() {
      _lastPage = 1;
    });
    final activities = await ScInit.scActivityListService.getActivityList(widget.type, 1);
    if (activities != null) {
      if (!mounted) return;
      setState(() {
        // The incoming activities may be the same as before, so distinct is necessary.
        activities.distinctBy((a) => a.id);
        _activityList = activities;
        _lastPage++;
        loading = false;
      });
    }
  }

  void loadMoreActivities() async {
    if (_atEnd) return;

    final lastActivities = await ScInit.scActivityListService.getActivityList(widget.type, _lastPage);

    if (!mounted) return;
    if (lastActivities != null) {
      if (lastActivities.isEmpty) {
        setState(() => _atEnd = true);
      } else {
        setState(() {
          _lastPage++;
          _activityList.addAll(lastActivities);
          // The incoming activities may be the same as before, so distinct is necessary.
          _activityList.distinctBy((a) => a.id);
        });
      }
    }
  }

  Widget buildActivityResult(List<Activity> activities) {
    return LiveGrid.options(
      controller: _scrollController,
      itemCount: activities.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        mainAxisExtent: 200,
      ),
      options: kiteLiveOptions,
      itemBuilder: (ctx, index, animation) => ActivityCard(activities[index]).aliveWith(animation),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
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
