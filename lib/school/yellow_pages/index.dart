import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:mimir/r.dart';
import 'package:rettulf/rettulf.dart';

import 'i18n.dart';

class YellowPagesAppCard extends StatefulWidget {
  const YellowPagesAppCard({super.key});

  @override
  State<YellowPagesAppCard> createState() => _YellowPagesAppCardState();
}

class _YellowPagesAppCardState extends State<YellowPagesAppCard> {
  @override
  Widget build(BuildContext context) {
    return FilledCard(
      child: [
        ListTile(
          title: "Liplum".text(),
          subtitle: "Li_plum@outlook.com".text(),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.phone),
                onPressed: () {
                },
              ),
              IconButton(
                icon: const Icon(Icons.content_copy),
                onPressed: () {
                },
              ),
            ],
          ),
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
            IconButton(onPressed: (){}, icon: Icon(Icons.clear))
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
}
