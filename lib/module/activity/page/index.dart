import 'package:flutter/material.dart';

import '../using.dart';
import 'list.dart';
import 'mine.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/list.dart';
import '../init.dart';
import '../widgets/card.dart';

class ActivityIndexPage extends StatefulWidget {
  const ActivityIndexPage({super.key});

  @override
  State<StatefulWidget> createState() => _ActivityIndexPageState();
}

class _ActivityIndexPageState extends State<ActivityIndexPage> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveNavi(
      title: MiniApp.activity.l10nName(),
      defaultIndex: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => showSearch(context: context, delegate: SearchBar()),
        ),
      ],
      pages: [
        // Activity List page
        AdaptivePage(
          label: i18n.navigation.all,
          unselectedIcon: const Icon(Icons.check_box_outline_blank),
          selectedIcon: const Icon(Icons.list_alt_rounded),
          builder: (ctx, key) {
            return ActivityListPage(key: key);
          },
        ),
        // Mine page
        AdaptivePage(
          label: i18n.navigation.mine,
          unselectedIcon: const Icon(Icons.person_outline_rounded),
          selectedIcon: const Icon(Icons.person_rounded),
          builder: (ctx, key) {
            return MyActivityPage(key: key);
          },
        ),
      ],
    );
  }
}

class SearchBar extends SearchDelegate<String> {
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
          return Placeholders.loading();
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
