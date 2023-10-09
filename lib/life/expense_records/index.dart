import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/credential/widgets/oa_scope.dart';
import 'package:sit/design/widgets/app.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/life/event.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/life/expense_records/entity/local.dart';
import 'package:sit/life/expense_records/init.dart';
import 'package:sit/utils/async_event.dart';
import 'utils.dart';
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
  final $lastTransaction = ExpenseRecordsInit.storage.listenLastTransaction();
  late final EventSubscription $refreshEvent;

  @override
  void initState() {
    $lastTransaction.addListener(onLatestChanged);
    $refreshEvent = lifeEventBus.addListener(() async {
      await refresh(active: true);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Settings.life.expense.autoRefresh) {
      refresh(active: false);
    }
  }

  @override
  void dispose() {
    $lastTransaction.removeListener(onLatestChanged);
    $refreshEvent.cancel();
    super.dispose();
  }

  void onLatestChanged() {
    setState(() {});
  }

  Future<void> refresh({required bool active}) async {
    final oaCredential = context.auth.credentials;
    if (oaCredential == null) return;
    try {
      await fetchAndSaveTransactionUntilNow(
        studentId: oaCredential.account,
      );
    } catch (error) {
      if (active) {
        if (!mounted) return;
        context.showSnackBar(i18n.refreshFailedTip.text());
      }
      return;
    }
    if (active) {
      if (!mounted) return;
      context.showSnackBar(i18n.refreshSuccessTip.text());
    }
  }

  @override
  Widget build(BuildContext context) {
    final lastTransaction = ExpenseRecordsInit.storage.latestTransaction;
    return AppCard(
      view: lastTransaction == null ? const SizedBox() : TransactionCardPanel(lastTransaction),
      title: i18n.title.text(),
      leftActions: [
        FilledButton.icon(
          icon: const Icon(Icons.assignment),
          onPressed: () async {
            context.push("/expense-records");
          },
          label: i18n.check.text(),
        ),
        OutlinedButton(
          onPressed: lastTransaction == null
              ? null
              : () async {
                  context.push("/expense-records/statistics");
                },
          child: i18n.statistics.text(),
        ),
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
