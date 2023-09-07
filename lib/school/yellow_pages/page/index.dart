import 'package:flutter/material.dart';
import 'package:mimir/r.dart';
import 'package:rettulf/rettulf.dart';

import 'list.dart';
import 'search.dart';
import '../i18n.dart';

class YellowPagesPage extends StatefulWidget {
  const YellowPagesPage({super.key});

  @override
  State<YellowPagesPage> createState() => _YellowPagesPageState();
}

class _YellowPagesPageState extends State<YellowPagesPage> {
  final _contacts = R.yellowPages;

  @override
  Widget build(BuildContext context) {
    final contacts = _contacts;
    return Scaffold(
      appBar: AppBar(
        title: i18n.title.text(),
        actions: [
          // IconButton(
          //   onPressed: () => showSearch(context: context, delegate: Search(contacts)),
          //   icon: const Icon(Icons.search),
          // ),
        ],
      ),
      // body: context.isPortrait ? GroupedContactList(R.yellowPages) : NavigationContactList(R.yellowPages),
    );
  }
}
