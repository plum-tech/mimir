import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:sit/credentials/widgets/oa_scope.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/life/expense_records/storage/local.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/life/expense_records/widget/group.dart';
import 'package:sit/utils/error.dart';

import '../aggregated.dart';
import '../entity/local.dart';
import '../init.dart';
import '../i18n.dart';
import '../utils.dart';

class ExpenseRecordsPage extends StatefulWidget {
  const ExpenseRecordsPage({super.key});

  @override
  State<ExpenseRecordsPage> createState() => _ExpenseRecordsPageState();
}

class _ExpenseRecordsPageState extends State<ExpenseRecordsPage> {
  final $lastTransaction = ExpenseRecordsInit.storage.listenLastTransaction();
  bool isFetching = false;
  List<Transaction>? records;

  List<({YearMonth time, List<Transaction> records})>? month2records;

  @override
  void initState() {
    super.initState();
    $lastTransaction.addListener(onLatestChanged);
    updateRecords(ExpenseRecordsInit.storage.getTransactionsByRange());
  }

  @override
  void dispose() {
    $lastTransaction.removeListener(onLatestChanged);
    super.dispose();
  }

  void onLatestChanged() {
    setState(() {});
  }

  void updateRecords(List<Transaction>? records) {
    if (!mounted) return;
    setState(() {
      this.records = records;
      month2records = records == null ? null : groupTransactionsByMonthYear(records);
    });
  }

  Future<void> refresh() async {
    final oaCredential = context.auth.credentials;
    if (oaCredential == null) return;
    if (!mounted) return;
    setState(() {
      isFetching = true;
    });
    try {
      await ExpenseAggregated.fetchAndSaveTransactionUntilNow(
        studentId: oaCredential.account,
      );
      updateRecords(ExpenseRecordsInit.storage.getTransactionsByRange());
      setState(() {
        isFetching = false;
      });
    } catch (error, stackTrace) {
      handleRequestError(context, error, stackTrace);
      setState(() {
        isFetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final month2records = this.month2records;
    final lastTransaction = ExpenseRecordsInit.storage.latestTransaction;
    return Scaffold(
      appBar: AppBar(
        title: lastTransaction == null
            ? i18n.title.text()
            : i18n.balanceInCard(lastTransaction.balanceAfter.toStringAsFixed(2)).text(),
        actions: [
          IconButton(
            tooltip: i18n.delete,
            icon: Icon(PlatformIcons(context).delete),
            onPressed: () async {
              ExpenseRecordsInit.storage.clearIndex();
              await HapticFeedback.heavyImpact();
              updateRecords(null);
            },
          ),
        ],
        centerTitle: true,
        bottom: isFetching
            ? const PreferredSize(
                preferredSize: Size.fromHeight(4),
                child: LinearProgressIndicator(),
              )
            : null,
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          await HapticFeedback.heavyImpact();
          await refresh();
        },
        child: CustomScrollView(
          slivers: [
            if (month2records == null || month2records.isEmpty)
              SliverFillRemaining(
                child: LeavingBlank(
                  icon: Icons.inbox_outlined,
                  desc: i18n.noTransactionsTip,
                ),
              )
            else
              ...month2records.mapIndexed(
                (index, e) {
                  return TransactionGroupSection(
                    // expand records in the first month by default.
                    initialExpanded: index == 0,
                    time: e.time,
                    records: e.records,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
