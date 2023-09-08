import 'package:flutter/material.dart';
import 'package:mimir/credential/symbol.dart';
import 'package:mimir/mini_app.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/local.dart';
import '../init.dart';
import '../i18n.dart';
import '../widget/list.dart';
import 'statistics.dart';

class ExpenseRecordsPage extends StatefulWidget {
  const ExpenseRecordsPage({super.key});

  @override
  State<ExpenseRecordsPage> createState() => _ExpenseRecordsPageState();
}

class _ExpenseRecordsPageState extends State<ExpenseRecordsPage> {
  int currentIndex = 0;

  final cache = ExpenseTrackerInit.cache;

  final ValueNotifier<double?> $balance = ValueNotifier(null);

  List<Transaction> allRecords = [];

  List<Widget> pages = [];

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
        title: buildAppBarTitle(context),
        centerTitle: true,
        actions: [buildMenu()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: [
          TransactionList(records: allRecords),
          StatisticsPage(records: allRecords),
        ][currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: i18n.navigation.bill,
            icon: const Icon(Icons.assignment_rounded),
          ),
          BottomNavigationBarItem(
            label: i18n.navigation.statistics,
            icon: const Icon(Icons.data_saver_off),
          )
        ],
        currentIndex: currentIndex,
        onTap: (int index) => setState(() => currentIndex = index),
      ),
    );
  }

  Widget buildAppBarTitle(BuildContext ctx) {
    return $balance >>
        (ctx, v) {
          if (v == null) {
            return MiniApp.expense.l10nName().text();
          } else {
            return i18n.balanceInCard(v.toStringAsFixed(2)).text();
          }
        };
  }

  void refreshRecords(List<Transaction> records) {
    if (!mounted) return;
    // 过滤支付宝的充值，否则将和圈存机叠加
    records = records.where((e) => e.type != TransactionType.topUp).toList();
    setState(() {
      allRecords = records;
      if (allRecords.isNotEmpty) {
        $balance.value = allRecords.last.balanceAfter;
      }
    });
  }

  Future<void> fetch(DateTime start, DateTime end) async {
    final oaCredential = context.auth.credential;
    if (oaCredential == null) return;
    final account = oaCredential.account;
    for (int i = 0; i < 3; i++) {
      try {
        allRecords = await cache.fetch(
          studentID: account,
          from: start,
          to: end,
          onLocalQuery: refreshRecords,
        );
        refreshRecords(allRecords);
        return;
      } catch (_) {}
    }
  }

  Widget buildMenu() {
    return PopupMenuButton(
      itemBuilder: (ctx) => [
        PopupMenuItem(
          child: Text(i18n.refreshMenuButton),
          onTap: () async {
            try {
              // 关闭用户交互
              ExpenseTrackerInit.storage
                ..clear()
                ..cachedTsEnd = null
                ..cachedTsStart = null;
              await fetch(DateTime(2010), DateTime.now());
            } catch (e, t) {
            } finally {
            }
          },
        ),
      ],
    );
  }
}
