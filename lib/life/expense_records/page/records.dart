import 'package:flutter/material.dart';
import 'package:mimir/credential/widgets/oa_scope.dart';
import 'package:mimir/life/expense_records/storage/local.dart';
import 'package:rettulf/rettulf.dart';

import '../init.dart';
import '../i18n.dart';
import '../utils.dart';
import '../widget/list.dart';

class ExpenseRecordsPage extends StatefulWidget {
  const ExpenseRecordsPage({super.key});

  @override
  State<ExpenseRecordsPage> createState() => _ExpenseRecordsPageState();
}

class _ExpenseRecordsPageState extends State<ExpenseRecordsPage> {
  final $lastTransaction = ExpenseRecordsInit.storage.$lastTransaction;
  var isFetching = false;

  @override
  void initState() {
    super.initState();
    $lastTransaction.addListener(onLatestChanged);
  }

  @override
  void dispose() {
    $lastTransaction.removeListener(onLatestChanged);
    super.dispose();
  }

  void onLatestChanged() {
    setState(() {});
  }

  Future<void> refresh() async {
    final oaCredential = context.auth.credentials;
    if (oaCredential == null) return;
    setState(() => isFetching = true);
    await fetchAndSaveTransactionUntilNow(
      studentId: oaCredential.account,
    );
    setState(() => isFetching = false);
  }

  @override
  Widget build(BuildContext context) {
    final records = ExpenseRecordsInit.storage.getTransactionsByRange();
    final lastTransaction = ExpenseRecordsInit.storage.latestTransaction;
    return Scaffold(
      appBar: AppBar(
        title: lastTransaction == null
            ? i18n.title.text()
            : i18n.balanceInCard(lastTransaction.balanceAfter.toStringAsFixed(2)).text(),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await refresh();
              },
              icon: const Icon(Icons.refresh))
        ],
        bottom: isFetching
            ? const PreferredSize(
                preferredSize: Size.fromHeight(4),
                child: LinearProgressIndicator(),
              )
            : null,
      ),
      body: TransactionList(records: records),
    );
  }
}
