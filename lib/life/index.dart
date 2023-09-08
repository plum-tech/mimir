import 'package:flutter/material.dart';
import 'package:mimir/life/electricity/index.dart';
import 'package:mimir/life/expense_records/index.dart';
import 'package:rettulf/rettulf.dart';

import 'i18n.dart';

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
          title: i18n.navigation.text(),
        ),
        const SliverToBoxAdapter(
          child: ExpenseRecordsAppCard(),
        ),
        const SliverToBoxAdapter(
          child: ElectricityBalanceAppCard(),
        ),
      ],
    );
  }
}
