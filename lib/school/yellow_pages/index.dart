import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:mimir/r.dart';
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
  @override
  void initState() {
    YellowPagesInit.storage.$history.addListener(refresh);
    super.initState();
  }

  @override
  void dispose() {
    YellowPagesInit.storage.$history.removeListener(refresh);
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final history = YellowPagesInit.storage.history ?? const [];
    return FilledCard(
      child: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: buildHistory(history),
        ),
        ListTile(
          titleTextStyle: context.textTheme.titleLarge,
          title: i18n.title.text(),
        ),
        OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            [
              FilledButton.icon(
                onPressed: () async {
                  final result = await showSearch(context: context, delegate: YellowPageSearchDelegate(R.yellowPages));
                  if (result == null) return;
                  YellowPagesInit.storage.addHistory(result);
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
            ].wrap(spacing: 12),
            IconButton(
                onPressed: YellowPagesInit.storage.history?.isNotEmpty != true
                    ? null
                    : () {
                        YellowPagesInit.storage.history = null;
                      },
                icon: const Icon(Icons.delete_outlined))
          ],
        ).padOnly(l: 16, b: 8, r: 16),
      ].column(),
    );
  }

  Widget buildHistory(List<SchoolContact> history) {
    if (history.isEmpty) return const SizedBox();
    final contacts = history.sublist(0, min(_historyLength, history.length));
    return contacts
        .map(
          (contact) {
            return ContactTile(contact).inCard();
          },
        )
        .toList()
        .column(mas: MainAxisSize.min);
  }
}
