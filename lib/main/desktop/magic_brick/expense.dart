import 'package:flutter/material.dart';
import 'package:mimir/events/symbol.dart';
import 'package:mimir/module/expense/entity/local.dart';
import 'package:mimir/module/expense/init.dart';
import 'package:mimir/route.dart';

import 'package:mimir/module/expense/i18n.dart';
import '../entity/miniApp.dart';
import '../widgets/brick.dart';

class ExpenseItem extends StatefulWidget {
  const ExpenseItem({super.key});

  @override
  State<StatefulWidget> createState() => _ExpenseItemState();
}

class _ExpenseItemState extends State<ExpenseItem> {
  Transaction? lastExpense;
  String? content;

  @override
  void initState() {
    super.initState();
    On.home<HomeRefreshEvent>((event) {
      refreshTracker();
    });
    On.expenseTracker<ExpenseTackerRefreshEvent>((event) {
      refreshTracker();
    });
    refreshTracker();
  }

  void refreshTracker() {
    final tsl = ExpenseTrackerInit.local.transactionTsList;
    if (tsl.isNotEmpty) {
      if (!mounted) return;
      setState(() {
        lastExpense = ExpenseTrackerInit.local.getTransactionByTs(tsl.last);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final last = lastExpense;
    if (last != null) {
      content = i18n.lastBalance(last.deltaAmount.toStringAsFixed(2), last.note);
    }
    return Brick(
      route: Routes.expense,
      icon: SvgAssetIcon('assets/home/icon_expense.svg'),
      title: MiniApp.expense.l10nName(),
      subtitle: content ?? MiniApp.expense.l10nDesc(),
    );
  }
}
