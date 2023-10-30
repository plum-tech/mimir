import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/widgets/app.dart';
import 'package:sit/r.dart';
import 'init.dart';
import 'storage/contact.dart';
import 'widgets/contact.dart';
import 'package:rettulf/rettulf.dart';

import 'entity/contact.dart';
import 'i18n.dart';
import 'widgets/search.dart';

const _historyLength = 2;

class YellowPagesAppCard extends StatefulWidget {
  const YellowPagesAppCard({super.key});

  @override
  State<YellowPagesAppCard> createState() => _YellowPagesAppCardState();
}

class _YellowPagesAppCardState extends State<YellowPagesAppCard> {
  final $history = YellowPagesInit.storage.listenHistory();

  @override
  void initState() {
    $history.addListener(refresh);
    super.initState();
  }

  @override
  void dispose() {
    $history.removeListener(refresh);
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final history = YellowPagesInit.storage.interactHistory ?? const [];
    return AppCard(
      view: buildHistory(history),
      title: i18n.title.text(),
      leftActions: [
        FilledButton.icon(
          onPressed: () async {
            final result = await showSearch(context: context, delegate: YellowPageSearchDelegate(R.yellowPages));
            if (result == null) return;
            YellowPagesInit.storage.addInteractHistory(result);
          },
          label: i18n.search.text(),
          icon: const Icon(Icons.search),
        ),
        OutlinedButton(
          onPressed: () {
            context.push("/yellow-pages");
          },
          child: i18n.seeAll.text(),
        )
      ],
    );
  }

  Widget buildHistory(List<SchoolContact> history) {
    if (history.isEmpty) return const SizedBox();
    final contacts = history.sublist(0, min(_historyLength, history.length));
    return contacts
        .map((contact) {
          return Dismissible(
            direction: DismissDirection.endToStart,
            key: ValueKey("${contact.name}+${contact.phone}"),
            onDismissed: (dir) async {
              await HapticFeedback.heavyImpact();
              history.remove(contact);
              YellowPagesInit.storage.interactHistory = history;
            },
            child: ContactTile(contact).inCard(),
          );
        })
        .toList()
        .column(mas: MainAxisSize.min);
  }
}
