import 'package:flutter/material.dart';
import 'package:mimir/life/electricity/index.dart';
import 'package:mimir/life/expense_records/index.dart';
import 'package:mimir/storage/settings.dart';
import 'package:rettulf/rettulf.dart';

import 'i18n.dart';

class LifePage extends StatefulWidget {
  const LifePage({super.key});

  @override
  State<LifePage> createState() => _LifePageState();
}

class _LifePageState extends State<LifePage> {
  final $campus = Settings.$campus;
  @override
  void initState() {
    $campus.addListener(refresh);
    super.initState();
  }

  @override
  void dispose() {
    $campus.removeListener(refresh);
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final campus = Settings.campus;
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
        if (campus.capability.enableElectricity)
          const SliverToBoxAdapter(
            child: ElectricityBalanceAppCard(),
          ),
      ],
    );
  }
}
