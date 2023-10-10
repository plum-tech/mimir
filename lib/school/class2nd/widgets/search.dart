import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/list.dart';
import '../init.dart';
import 'activity.dart';

class ActivitySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
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
    final result = await Class2ndInit.activityListService.query(widget.query);
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
          SliverList.builder(
            itemCount: activityList.length,
            itemBuilder: (ctx, i) {
              final activity = activityList[i];
              return ActivityCard(activity).hero(activity.id);
            },
          ),
      ],
    );
  }
}
