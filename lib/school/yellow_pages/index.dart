import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/card.dart';
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
        SizedBox(height: 120),
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
                child: "All".text(),
              )
            ].wrap(spacing: 12)
          ],
        ).padOnly(l: 16, b: 12),
      ].column(),
    );
  }
}
