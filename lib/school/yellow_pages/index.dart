import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:mimir/r.dart';
import 'package:mimir/school/yellow_pages/init.dart';
import 'package:mimir/school/yellow_pages/widgets/contact.dart';
import 'package:rettulf/rettulf.dart';

import 'entity/contact.dart';
import 'i18n.dart';

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
          duration: const Duration(milliseconds: 500),
          child: buildHistory(history),
        ).inCard(elevation: 4),
        ListTile(
          titleTextStyle: context.textTheme.titleLarge,
          title: i18n.title.text(),
        ),
        OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            [
              FilledButton.icon(
                onPressed: () async {},
                label: i18n.search.text(),
                icon: const Icon(Icons.search),
              ),
              OutlinedButton(
                onPressed: () {},
                child: "See All".text(),
              )
            ].wrap(spacing: 12),
            IconButton(onPressed: () {}, icon: const Icon(Icons.clear))
          ],
        ).padOnly(l: 16, b: 8, r: 16),
      ].column(),
    );
  }

  List<Widget> buildDepartmentChips() {
    return R.yellowPages.keys
        .map((department) => ActionChip(
              label: department.text(),
              onPressed: () {},
            ))
        .toList();
  }

  Widget buildHistory(List<SchoolContact> history) {
    if (history.isEmpty) return const SizedBox();
    final contacts = history.sublist(0, min(_historyLength, history.length));
    return contacts.map((contact) => ContactTile(contact)).toList().row(mas: MainAxisSize.min);
  }
}
