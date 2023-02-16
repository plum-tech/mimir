import 'package:flutter/material.dart';

import '../using.dart';
import 'list.dart';
import 'mine.dart';
import 'search.dart';

class ActivityIndexPage extends StatefulWidget {
  const ActivityIndexPage({super.key});

  @override
  State<StatefulWidget> createState() => _ActivityIndexPageState();
}

class _ActivityIndexPageState extends State<ActivityIndexPage> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveNavi(
      title: FType.activity.l10nName(),
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
