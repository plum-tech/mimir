import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/app.dart';
import 'package:rettulf/rettulf.dart';

import "i18n.dart";

class ExamArrangeAppCard extends StatefulWidget {
  const ExamArrangeAppCard({super.key});

  @override
  State<ExamArrangeAppCard> createState() => _ExamArrangeAppCardState();
}

class _ExamArrangeAppCardState extends State<ExamArrangeAppCard> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: i18n.title.text(),
    );
  }
}
