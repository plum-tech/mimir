import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/widgets/app.dart';
import 'widget/balance.dart';
import 'package:rettulf/rettulf.dart';

import "i18n.dart";

class ExpenseTrackerAppCard extends StatefulWidget {
  const ExpenseTrackerAppCard({super.key});

  @override
  State<ExpenseTrackerAppCard> createState() => _ExpenseTrackerAppCardState();
}

class _ExpenseTrackerAppCardState extends State<ExpenseTrackerAppCard> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      view: [
        BalanceCard(
          balance: 0,
          elevation: 4,
        ).expanded(flex: 3),
        const SizedBox().expanded(flex: 4),
      ].row(),
      title: i18n.title.text(),
      leftActions: [
        FilledButton.icon(
          icon: Icon(Icons.assignment_outlined),
          onPressed: () async {
            context.push("/expense-records");
          },
          label: i18n.check.text(),
        ),
        OutlinedButton(
          onPressed: () async {
            context.push("/expense-records/statistics");
          },
          child:  i18n.statistics.text(),
        ),
      ],
      rightActions: [
        IconButton(
          onPressed: () async {},
          icon: const Icon(Icons.refresh),
        )
      ],
    );
  }
}
