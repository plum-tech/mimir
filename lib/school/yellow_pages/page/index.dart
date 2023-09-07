import 'package:flutter/material.dart';
import 'package:mimir/r.dart';
import 'package:mimir/school/yellow_pages/init.dart';
import 'package:mimir/school/yellow_pages/storage/contact.dart';
import 'package:rettulf/rettulf.dart';

import '../widgets/list.dart';
import '../widgets/search.dart';
import '../i18n.dart';

const _defaultRevealedDepartmentLength = 3;

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
          IconButton(
            onPressed: () async {
              final result = await showSearch(context: context, delegate: YellowPageSearchDelegate(R.yellowPages));
              if (result == null) return;
              YellowPagesInit.storage.addInteractHistory(result);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SchoolContactList(
        R.yellowPages,
        isInitialExpanded: (i, length) => i < _defaultRevealedDepartmentLength,
      ),
    );
  }
}
