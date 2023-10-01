import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import 'page/search_delegate.dart';
import '../i18n.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.title.text(),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchBarDelegate());
            },
            icon: const Icon(
              Icons.search,
            ),
          )
        ],
      ),
      // TODO: new body
      body: null,
    );
  }
}
