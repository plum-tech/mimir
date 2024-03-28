import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/credentials/widgets/oa_scope.dart';
import 'package:sit/design/widgets/app.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/life/event.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/life/expense_records/init.dart';
import 'package:sit/utils/async_event.dart';
import 'aggregated.dart';
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
  final $lastUpdateTime = ExpenseRecordsInit.storage.listenLastUpdateTime();
  late final EventSubscription $refreshEvent;

  @override
  void initState() {
    $lastTransaction.addListener(onLatestChanged);
    $lastUpdateTime.addListener(onLatestChanged);
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
    $lastUpdateTime.removeListener(onLatestChanged);
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
      await ExpenseAggregated.fetchAndSaveTransactionUntilNow(
        studentId: oaCredential.account,
      );
    } catch (error) {
      if (active) {
        if (!mounted) return;
        context.showSnackBar(content: i18n.refreshFailedTip.text());
      }
      return;
    }
    if (active) {
      if (!mounted) return;
      context.showSnackBar(content: i18n.refreshSuccessTip.text());
    }
  }

  @override
  Widget build(BuildContext context) {
    final lastTransaction = ExpenseRecordsInit.storage.latestTransaction;
    final lastUpdateTime = ExpenseRecordsInit.storage.lastUpdateTime;
    return AppCard(
      view: lastTransaction == null
          ? const SizedBox()
          : [
              BalanceCard(
                balance: lastTransaction.balanceAfter,
              ).expanded(),
              TransactionCard(
                transaction: lastTransaction,
              ).expanded(),
            ].row().sized(h: 140),
      title: i18n.title.text(),
      subtitle: lastUpdateTime != null ? i18n.lastUpdateTime(context.formatMdhmNum(lastUpdateTime)).text() : null,
      leftActions: [
        FilledButton.icon(
          icon: const Icon(Icons.assignment),
          onPressed: () async {
            context.push("/expense-records");
          },
          label: i18n.list.text(),
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
