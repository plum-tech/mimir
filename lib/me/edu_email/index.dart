import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/app.dart';
import 'package:rettulf/rettulf.dart';

import "i18n.dart";

class EduEmailAppCard extends StatefulWidget {
  const EduEmailAppCard({super.key});

  @override
  State<EduEmailAppCard> createState() => _EduEmailAppCardState();
}

class _EduEmailAppCardState extends State<EduEmailAppCard> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: i18n.title.text(),
      leftActions: [
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.email_outlined),
          label: "Mailbox".text(),
        )
      ],
    );
  }
}
