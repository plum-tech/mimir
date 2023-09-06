import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:mimir/mini_app.dart';
import 'package:rettulf/rettulf.dart';

import 'electricity/index.dart';

class LifePage extends StatefulWidget {
  const LifePage({super.key});

  @override
  State<LifePage> createState() => _LifePageState();
}

class _LifePageState extends State<LifePage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          snap: false,
          floating: false,
        ),
        SliverToBoxAdapter(
          child: ExpenseTrackerAppCard(),
        ),
        SliverToBoxAdapter(
          child: ElectricityBalanceAppCard(),
        ),
      ],
    );
  }
}

class ExpenseTrackerAppCard extends StatefulWidget {
  const ExpenseTrackerAppCard({super.key});

  @override
  State<ExpenseTrackerAppCard> createState() => _ExpenseTrackerAppCardState();
}

class _ExpenseTrackerAppCardState extends State<ExpenseTrackerAppCard> {
  @override
  Widget build(BuildContext context) {
    return FilledCard(
      child: [
        SizedBox(height: 120),
        ListTile(
          titleTextStyle: context.textTheme.titleLarge,
          title: MiniApp.expense.l10nName().text(),
        ),
        OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            FilledButton(onPressed: () {}, child: "Check".text()),
          ],
        ).padOnly(l: 5, b: 5),
      ].column(),
    );
  }
}
