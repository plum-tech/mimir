import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/animation/progress.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/design/widget/common.dart';
import 'package:mimir/utils/collection.dart';
import 'package:mimir/utils/error.dart';

import '../entity/activity.dart';
import '../init.dart';
import '../utils.dart';
import '../widget/activity.dart';
import '../widget/search.dart';
import '../i18n.dart';

class ActivityListPage extends StatefulWidget {
  const ActivityListPage({super.key});

  @override
  State<StatefulWidget> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: commonClass2ndCategories.length,
      child: Scaffold(
        appBar: AppBar(
          title: i18n.title.text(),
          actions: [
            PlatformIconButton(
              icon: Icon(context.icons.search),
              onPressed: () => showSearch(
                useRootNavigator: true,
                context: context,
                delegate: ActivitySearchDelegate(),
              ),
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
        body: TabBarView(
          // These are the contents of the tab views, below the tabs.
          children: commonClass2ndCategories.mapIndexed((i, cat) {
            return ActivityLoadingList(cat: cat);
          }).toList(),
        ),
      ),
    );
  }
}

/// Thanks to the cache, don't worry about that switching tab will re-fetch the activity list.
class ActivityLoadingList extends StatefulWidget {
  final Class2ndActivityCat cat;

  const ActivityLoadingList({
    super.key,
    required this.cat,
  });

  @override
  State<StatefulWidget> createState() => _ActivityLoadingListState();
}

class _ActivityLoadingListState extends State<ActivityLoadingList> with AutomaticKeepAliveClientMixin {
  int lastPage = 1;
  bool fetching = false;
  late var activities = Class2ndInit.activityStorage.getActivities(widget.cat);

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
    final activities = this.activities;
    return NotificationListener<ScrollNotification>(
      onNotification: (event) {
        if (event.metrics.pixels >= event.metrics.maxScrollExtent) {
          loadMore();
        }
        return true;
      },
      child: activities == null
          ? const SizedBox()
          : WhenLoading(
              loading: fetching,
              child: buildList(activities),
            ),
    );
  }

  Widget buildList(List<Class2ndActivity> activities) {
    return activities.isEmpty
        ? LeavingBlank(
            icon: Icons.inbox_outlined,
            desc: i18n.noActivities,
          )
        : ListView.builder(
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
          );
  }

  Future<void> loadMore() async {
    final cat = widget.cat;
    if (!cat.canFetchData) return;
    if (fetching) return;
    if (!mounted) return;
    setState(() {
      fetching = true;
    });
    try {
      final lastActivities = await Class2ndInit.activityService.getActivityList(cat, lastPage);
      final activities = this.activities ?? <Class2ndActivity>[];
      activities.addAll(lastActivities);
      activities.distinctBy((a) => a.id);
      // The incoming activities may be the same as before, so distinct is necessary.
      activities.sort((a, b) => b.time.compareTo(a.time));
      await Class2ndInit.activityStorage.setActivities(cat, activities);
      if (!mounted) return;
      setState(() {
        lastPage++;
        this.activities = activities;
        fetching = false;
      });
    } catch (error, stackTrace) {
      handleRequestError(error, stackTrace);
      if (!mounted) return;
      setState(() {
        fetching = false;
      });
    }
  }
}
