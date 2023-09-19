import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/app.dart';
import 'package:rettulf/rettulf.dart';

import "i18n.dart";

class YwbAppCard extends StatefulWidget {
  const YwbAppCard({super.key});

  @override
  State<YwbAppCard> createState() => _YwbAppCardState();
}

class _YwbAppCardState extends State<YwbAppCard> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: i18n.title.text(),
      leftActions: [
        FilledButton.icon(
          onPressed: () {

          },
          icon: const Icon(Icons.list_alt_outlined),
          label: "See all".text(),
        ),
        OutlinedButton.icon(
          onPressed: () {

          },
          label: "Mailbox".text(),
          icon: const Icon(Icons.mail_outlined),
        )
      ],
    );
  }
}
