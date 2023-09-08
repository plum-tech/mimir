import 'package:flutter/material.dart';
import 'package:mimir/credential/symbol.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/local.dart';
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
  final cache = ExpenseRecordsInit.cache;

  final ValueNotifier<double?> $balance = ValueNotifier(null);

  List<Transaction>? records;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await refresh();
    });
  }

  Future<void> refresh({
    bool clear = false,
  }) async {
    final oaCredential = context.auth.credential;
    if (oaCredential == null) return;
    if (clear) {
      ExpenseRecordsInit.storage
        ..clear()
        ..cachedTsEnd = null
        ..cachedTsStart = null;
      setState(() {
        records = null;
      });
    }
    await fetchTransaction(
      studentId: oaCredential.account,
      start: DateTime(2010),
      end: DateTime.now(),
      onLocalQuery: refreshRecords,
    );
  }

  void refreshRecords(List<Transaction> records) {
    if (!mounted) return;
    // 过滤支付宝的充值，否则将和圈存机叠加
    records = records.where((e) => e.type != TransactionType.topUp).toList();
    setState(() {
      this.records = records;
      if (records.isNotEmpty) {
        final lastTransaction = records.last;
        $balance.value = lastTransaction.balanceAfter;
        ExpenseRecordsInit.storage.lastTransaction = lastTransaction;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final records = this.records;
    return Scaffold(
      appBar: AppBar(
        title: $balance >>
            (ctx, v) {
              if (v == null) {
                return i18n.title.text();
              } else {
                return i18n.balanceInCard(v.toStringAsFixed(2)).text();
              }
            },
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await refresh(clear: true);
              },
              icon: const Icon(Icons.refresh))
        ],
        bottom: records != null && records.isNotEmpty
            ? null
            : const PreferredSize(
                preferredSize: Size.fromHeight(4),
                child: LinearProgressIndicator(),
              ),
      ),
      body: records == null ? null : TransactionList(records: records),
    );
  }
}
