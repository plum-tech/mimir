import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/common.dart';

import '../entity/activity.dart';
import '../init.dart';
import '../i18n.dart';
import '../page/details.dart';
import 'activity.dart';

class ActivitySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      PlatformIconButton(
        onPressed: () => query = '',
        icon: Icon(context.icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return _ActivityAsyncSearchList(
      query: query,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

class _ActivityAsyncSearchList extends StatefulWidget {
  final String query;

  const _ActivityAsyncSearchList({
    super.key,
    required this.query,
  });

  @override
  State<_ActivityAsyncSearchList> createState() => _ActivityAsyncSearchListState();
}

class _ActivityAsyncSearchListState extends State<_ActivityAsyncSearchList> {
  List<Class2ndActivity>? activityList;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final result = await Class2ndInit.activityService.query(widget.query);
    setState(() {
      activityList = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activityList = this.activityList;
    return CustomScrollView(
      slivers: [
        if (activityList != null)
          if (activityList.isNotEmpty)
            SliverList.builder(
              itemCount: activityList.length,
              itemBuilder: (ctx, i) {
                final activity = activityList[i];
                return ActivityCard(
                  activity,
                  onTap: () async {
                    await context.show$Sheet$((ctx) => Class2ndActivityDetailsPage(
                          activityId: activity.id,
                          title: activity.title,
                          time: activity.time,
                          enableApply: true,
                        ));
                  },
                );
              },
            )
          else
            SliverFillRemaining(
              child: LeavingBlank(
                icon: Icons.inbox_outlined,
                desc: i18n.noActivities,
              ),
            ),
      ],
    );
  }
}
