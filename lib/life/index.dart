import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:mimir/life/expense_records/index.dart';
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
