import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/local.dart';
import '../init.dart';
import '../using.dart';
import 'bill.dart';
import 'statistics.dart';

class ExpenseTrackerPage extends StatefulWidget {
  const ExpenseTrackerPage({super.key});

  @override
  State<ExpenseTrackerPage> createState() => _ExpenseTrackerPageState();
}

class _ExpenseTrackerPageState extends State<ExpenseTrackerPage> {
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
          BillPage(records: allRecords),
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
    FireOn.expenseTracker(ExpenseTackerRefreshEvent());
  }

  Future<void> fetch(DateTime start, DateTime end) async {
    final oaCredential = Auth.oaCredential;
    if (oaCredential == null) return;
    final account = oaCredential.account;
    for (int i = 0; i < 3; i++) {
      try {
        EasyLoading.showToast(i18n.toastLoading);
        allRecords = await cache.fetch(
          studentID: account,
          from: start,
          to: end,
          onLocalQuery: refreshRecords,
        );
        refreshRecords(allRecords);
        EasyLoading.showToast(i18n.toastLoadSuccessful);
        return;
      } catch (_) {}
    }
    EasyLoading.showToast(i18n.toastLoadFailed);
  }

  Widget buildMenu() {
    return PopupMenuButton(
      itemBuilder: (ctx) => [
        PopupMenuItem(
          child: Text(i18n.refreshMenuButton),
          onTap: () async {
            try {
              // 关闭用户交互
              EasyLoading.instance.userInteractions = false;
              EasyLoading.show(status: i18n.fetchingRecordTip);
              ExpenseTrackerInit.local
                ..clear()
                ..cachedTsEnd = null
                ..cachedTsStart = null;
              await fetch(DateTime(2010), DateTime.now());
            } catch (e, t) {
              EasyLoading.showError('${i18n.failed}: ${e.toString().split('\n')[0]}');
            } finally {
              // 关闭正在加载对话框
              EasyLoading.dismiss();
              // 开启用户交互
              EasyLoading.instance.userInteractions = true;
            }
          },
        ),
      ],
    );
  }
}
