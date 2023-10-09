import 'package:flutter/material.dart';
import 'package:sit/widgets/placeholder_future_builder.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/list.dart';
import '../init.dart';
import 'activity.dart';

class ActivitySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  Widget buildEventResult(List<Class2ndActivity> activities) {
    return CustomScrollView(
      slivers: [
        SliverList.builder(
          itemCount: activities.length,
          itemBuilder: (ctx, i) {
            final activity = activities[i];
            return ActivityCard(activity).hero(activity.id);
          },
        ),
      ],
    );
  }

  Widget _buildSearch() {
    // TODO: Don't use placeholder future builder
    return PlaceholderFutureBuilder<List<Class2ndActivity>?>(
      future: Class2ndInit.activityListService.query(query),
      builder: (context, data, state) {
        if (data == null) {
          return const CircularProgressIndicator();
        } else {
          return buildEventResult(data);
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearch();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
