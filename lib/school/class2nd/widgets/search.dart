
import 'package:flutter/material.dart';
import 'package:mimir/widgets/placeholder_future_builder.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/list.dart';
import '../init.dart';
import 'card.dart';

class ActivitySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  Widget buildEventResult(List<Activity> activities) {
    return ListView.builder(
        itemCount: activities.length,
        itemBuilder: (ctx, i) {
          return ActivityCard(activities[i]).sized(w: 400, h: 200);
        });
  }

  Widget _buildSearch() {
    return PlaceholderFutureBuilder<List<Activity>?>(
      future: ScInit.scActivityListService.query(query),
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
