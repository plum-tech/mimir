import 'package:flutter/material.dart';
import 'package:mimir/r.dart';
import 'package:rettulf/rettulf.dart';

import 'list.dart';
import 'search.dart';
import '../i18n.dart';

class YellowPagesListPage extends StatefulWidget {
  const YellowPagesListPage({super.key});

  @override
  State<YellowPagesListPage> createState() => _YellowPagesListPageState();
}

class _YellowPagesListPageState extends State<YellowPagesListPage> {
  @override
  Widget build(BuildContext context) {
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
      body: GroupedContactList(R.yellowPages),
    );
  }
}
