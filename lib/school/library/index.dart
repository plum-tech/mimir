import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/app.dart';

import './i18n.dart';
import 'page/search_delegate.dart';

class LibraryAppCard extends StatefulWidget {
  const LibraryAppCard({super.key});

  @override
  State<LibraryAppCard> createState() => _LibraryAppCardState();
}

class _LibraryAppCardState extends State<LibraryAppCard> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: i18n.title.text(),
      leftActions: [
        FilledButton.icon(
          onPressed: () async {
            await showSearch(context: context, delegate: LibrarySearchDelegate());
          },
          icon: const Icon(Icons.search),
          label: i18n.search.text(),
        ),
        OutlinedButton(
          onPressed: () {},
          child: i18n.seeAll.text(),
        )
      ],
    );
  }
}
