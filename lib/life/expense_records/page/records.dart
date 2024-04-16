import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
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

class ExpenseRecordsPage extends ConsumerStatefulWidget {
  const ExpenseRecordsPage({super.key});

  @override
  ConsumerState<ExpenseRecordsPage> createState() => _ExpenseRecordsPageState();
}

class _ExpenseRecordsPageState extends ConsumerState<ExpenseRecordsPage> {
  bool isFetching = false;
  List<Transaction>? records;
  List<({YearMonth time, List<Transaction> records})>? month2records;

  @override
  void initState() {
    super.initState();
    updateRecords(ExpenseRecordsInit.storage.getTransactionsByRange());
  }

  void updateRecords(List<Transaction>? records) {
    if (!mounted) return;
    setState(() {
      this.records = records;
      month2records = records == null ? null : groupTransactionsByMonthYear(records);
    });
  }

  Future<void> refresh() async {
    final credentials = ref.read(CredentialsInit.storage.$oaCredentials);
    if (credentials == null) return;
    if (!mounted) return;
    setState(() {
      isFetching = true;
    });
    try {
      await ExpenseAggregated.fetchAndSaveTransactionUntilNow(
        oaAccount: credentials.account,
      );
      updateRecords(ExpenseRecordsInit.storage.getTransactionsByRange());
      setState(() {
        isFetching = false;
      });
    } catch (error, stackTrace) {
      handleRequestError(error, stackTrace);
      setState(() {
        isFetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = ExpenseRecordsInit.storage;
    final month2records = this.month2records;
    final lastTransaction = ref.watch(storage.$lastTransaction);
    return Scaffold(
      appBar: AppBar(
        title: lastTransaction == null
            ? i18n.title.text()
            : i18n.balanceInCard(lastTransaction.balanceAfter.toStringAsFixed(2)).text(),
        actions: [
          PlatformIconButton(
            material: (ctx, p) {
              return MaterialIconButtonData(
                tooltip: i18n.delete,
              );
            },
            icon: Icon(context.icons.delete),
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
