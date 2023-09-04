import 'package:flutter/material.dart';
import 'package:mimir/mini_apps/expense/entity/local.dart';
import 'package:mimir/mini_apps/expense/init.dart';

import 'package:mimir/mini_apps/expense/i18n.dart';
import '../../../mini_app.dart';
import '../widgets/brick.dart';

class ExpenseBrick extends StatefulWidget {
  final String route;
  final IconBuilder icon;

  const ExpenseBrick({
    super.key,
    required this.route,
    required this.icon,
  });

  @override
  State<StatefulWidget> createState() => _ExpenseBrickState();
}

class _ExpenseBrickState extends State<ExpenseBrick> {
  Transaction? lastExpense;
  String? content;

  @override
  void initState() {
    super.initState();
    refreshTracker();
    ExpenseTrackerInit.storage.$transactionTsList.addListener(refreshTracker);
  }

  @override
  void dispose() {
    ExpenseTrackerInit.storage.$transactionTsList.removeListener(refreshTracker);
    super.dispose();
  }

  void refreshTracker() {
    final tsl = ExpenseTrackerInit.storage.transactionTsList;
    if (tsl.isNotEmpty) {
      if (!mounted) return;
      setState(() {
        lastExpense = ExpenseTrackerInit.storage.getTransactionByTs(tsl.last);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final last = lastExpense;
    if (last != null) {
      content = i18n.lastTransaction(last.deltaAmount.toStringAsFixed(2), last.note);
    }
    return Brick(
      route: widget.route,
      icon: widget.icon,
      title: MiniApp.expense.l10nName(),
      subtitle: content ?? MiniApp.expense.l10nDesc(),
    );
  }
}
