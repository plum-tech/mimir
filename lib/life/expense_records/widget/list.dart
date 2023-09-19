import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/grouped.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/local.dart';
import '../i18n.dart';
import '../utils.dart';
import 'transaction.dart';

class TransactionList extends StatefulWidget {
  final List<Transaction> records;

  const TransactionList({
    super.key,
    required this.records,
  });

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  late List<({YearMonth time, List<Transaction> records})> month2records;

  @override
  void initState() {
    super.initState();
    updateGroupedRecords();
  }

  @override
  void didUpdateWidget(covariant TransactionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.records.equals(oldWidget.records)) {
      updateGroupedRecords();
    }
  }

  void updateGroupedRecords() {
    final groupByYearMonth = groupTransactionsByMonthYear(widget.records);
    setState(() {
      month2records = groupByYearMonth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: month2records.mapIndexed(
        (index, e) {
          final (:income, :outcome) = accumulateTransactions(e.records);
          return GroupedSection(
            title: context.formatYmText((e.time.toDateTime())).text(style: context.textTheme.titleMedium),
            subtitle: "${i18n.income(income.toStringAsFixed(2))}\n${i18n.outcome(outcome.toStringAsFixed(2))}".text(
              maxLines: 2,
            ),
            // expand records in the first month by default.
            initialExpanded: index == 0,
            items: e.records,
            itemBuilder: (ctx, i, record) {
              return TransactionTile(record);
            },
          );
        },
      ).toList(),
    );
  }
}
