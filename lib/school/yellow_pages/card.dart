import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/widget/app.dart';
import 'package:mimir/r.dart';
import 'init.dart';
import 'storage/contact.dart';
import 'widget/contact.dart';
import 'package:rettulf/rettulf.dart';

import 'entity/contact.dart';
import 'i18n.dart';
import 'widget/search.dart';

const _historyLength = 2;

class YellowPagesAppCard extends ConsumerStatefulWidget {
  const YellowPagesAppCard({super.key});

  @override
  ConsumerState<YellowPagesAppCard> createState() => _YellowPagesAppCardState();
}

class _YellowPagesAppCardState extends ConsumerState<YellowPagesAppCard> {
  @override
  Widget build(BuildContext context) {
    final history = ref.watch(YellowPagesInit.storage.$interactHistory) ?? const [];
    return AppCard(
      view: buildHistory(history),
      title: i18n.title.text(),
      leftActions: [
        FilledButton.icon(
          onPressed: () async {
            final result = await showSearch(
              useRootNavigator: true,
              context: context,
              delegate: YellowPageSearchDelegate(R.yellowPages),
            );
            if (result == null) return;
            YellowPagesInit.storage.addInteractHistory(result);
          },
          label: i18n.search.text(),
          icon: const Icon(Icons.search),
        ),
        FilledButton.tonal(
          onPressed: () {
            context.push("/yellow-pages");
          },
          child: i18n.seeAll.text(),
        )
      ],
    );
  }

  Widget buildHistory(List<SchoolContact> history) {
    if (history.isEmpty) return const SizedBox.shrink();
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
            child: SchoolContactTile(
              contact: contact,
              descMaxLines: 2,
            ).inCard(clip: Clip.hardEdge),
          );
        })
        .toList()
        .column(mas: MainAxisSize.min);
  }
}
