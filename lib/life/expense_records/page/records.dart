import 'package:flutter/material.dart';
import 'package:mimir/credential/symbol.dart';
import 'package:mimir/mini_app.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/local.dart';
import '../init.dart';
import '../i18n.dart';
import '../widget/list.dart';

class ExpenseRecordsPage extends StatefulWidget {
  const ExpenseRecordsPage({super.key});

  @override
  State<ExpenseRecordsPage> createState() => _ExpenseRecordsPageState();
}

class _ExpenseRecordsPageState extends State<ExpenseRecordsPage> {
  final cache = ExpenseRecordsInit.cache;

  final ValueNotifier<double?> $balance = ValueNotifier(null);

  List<Transaction> records = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await fetch(DateTime(2010), DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: $balance >>
            (ctx, v) {
              if (v == null) {
                return MiniApp.expense.l10nName().text();
              } else {
                return i18n.balanceInCard(v.toStringAsFixed(2)).text();
              }
            },
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                ExpenseRecordsInit.storage
                  ..clear()
                  ..cachedTsEnd = null
                  ..cachedTsStart = null;
                await fetch(DateTime(2010), DateTime.now());
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: TransactionList(records: records),
    );
  }

  void refreshRecords(List<Transaction> records) {
    if (!mounted) return;
    // 过滤支付宝的充值，否则将和圈存机叠加
    records = records.where((e) => e.type != TransactionType.topUp).toList();
    setState(() {
      this.records = records;
      if (this.records.isNotEmpty) {
        $balance.value = this.records.last.balanceAfter;
      }
    });
  }

  Future<void> fetch(DateTime start, DateTime end) async {
    final oaCredential = context.auth.credential;
    if (oaCredential == null) return;
    final account = oaCredential.account;
    for (int i = 0; i < 3; i++) {
      try {
        records = await cache.fetch(
          studentID: account,
          from: start,
          to: end,
          onLocalQuery: refreshRecords,
        );
        refreshRecords(records);
        return;
      } catch (_) {}
    }
  }
}
