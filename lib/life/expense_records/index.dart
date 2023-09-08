import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/widgets/app.dart';
import 'package:mimir/life/expense_records/init.dart';
import 'widget/balance.dart';
import 'package:rettulf/rettulf.dart';

import "i18n.dart";
import 'widget/transaction.dart';

class ExpenseRecordsAppCard extends StatefulWidget {
  const ExpenseRecordsAppCard({super.key});

  @override
  State<ExpenseRecordsAppCard> createState() => _ExpenseRecordsAppCardState();
}

class _ExpenseRecordsAppCardState extends State<ExpenseRecordsAppCard> {
  @override
  void initState() {
    ExpenseRecordsInit.storage.$lastTransaction.addListener(refresh);
    super.initState();
  }

  @override
  void dispose() {
    ExpenseRecordsInit.storage.$lastTransaction.removeListener(refresh);
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final lastTransaction = ExpenseRecordsInit.storage.lastTransaction;
    return AppCard(
      view: lastTransaction == null
          ? const SizedBox()
          : [
              BalanceCard(
                balance: lastTransaction.balanceAfter,
              ).expanded(flex: 3),
              TransactionCard(
                transaction: lastTransaction,
              ).expanded(flex: 4),
            ].row(),
      title: i18n.title.text(),
      leftActions: [
        FilledButton.icon(
          icon: const Icon(Icons.assignment_outlined),
          onPressed: () async {
            context.push("/expense-records");
          },
          label: i18n.check.text(),
        ),
        OutlinedButton(
          onPressed: () async {
            context.push("/expense-records/statistics");
          },
          child: i18n.statistics.text(),
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
