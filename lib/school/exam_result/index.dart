import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/widgets/app.dart';
import 'package:rettulf/rettulf.dart';

import "i18n.dart";

class ExamResultAppCard extends StatefulWidget {
  const ExamResultAppCard({super.key});

  @override
  State<ExamResultAppCard> createState() => _ExamResultAppCardState();
}

class _ExamResultAppCardState extends State<ExamResultAppCard> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: i18n.title.text(),
      leftActions: [
        FilledButton.icon(
          onPressed: () {
            context.push("/exam-result");
          },
          icon: const Icon(Icons.score_outlined),
          label: "Check".text(),
        ),
      ],
      rightActions: [
        IconButton(
          onPressed: () async {},
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}
