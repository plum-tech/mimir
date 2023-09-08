import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/widgets/app.dart';
import 'package:mimir/life/expense_records/entity/local.dart';
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
      view: lastTransaction == null ? const SizedBox() : TransactionCardPanel(lastTransaction),
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

class TransactionCardPanel extends StatefulWidget {
  final Transaction transaction;

  const TransactionCardPanel(this.transaction, {super.key});

  @override
  State<TransactionCardPanel> createState() => _TransactionCardPanelState();
}

class _TransactionCardPanelState extends State<TransactionCardPanel> {
  final balanceCardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final box = balanceCardKey.currentContext?.findRenderObject() as RenderBox?;
    return [
      BalanceCard(
        key: balanceCardKey,
        balance: widget.transaction.balanceAfter,
      ).expanded(flex: 6),
      TransactionCard(
        transaction: widget.transaction,
      ).expanded(flex: 5),
    ].row().sized(h: box?.size.height);
  }
}
