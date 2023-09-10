import 'package:flutter/material.dart';
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
    );
  }
}
