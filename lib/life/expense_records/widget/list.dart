import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/grouped.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/local.dart';
import '../i18n.dart';
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

typedef YearMonth = ({int year, int month});

extension YearMonthX on YearMonth {
  int compareTo(YearMonth other, {bool ascending = true}) {
    final sign = ascending ? 1 : -1;
    return switch (this.year - other.year) {
      > 0 => 1 * sign,
      < 0 => -1 * sign,
      _ => switch (this.month - other.month) {
          > 0 => 1 * sign,
          < 0 => -1 * sign,
          _ => 0,
        }
    };
  }

  DateTime toDateTime() => DateTime(year, month);
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
    final groupByYearMonth = widget.records
        .groupListsBy((r) => (year: r.timestamp.year, month: r.timestamp.month))
        .entries
        // the latest goes first
        .map((e) => (time: e.key, records: e.value.sorted((a, b) => -a.timestamp.compareTo(b.timestamp))))
        .toList();
    groupByYearMonth.sort((a, b) => a.time.compareTo(b.time, ascending: false));
    setState(() {
      month2records = groupByYearMonth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: month2records.mapIndexed(
        (index, e) {
          final (:income, :outcome) = accumulate(e.records);
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

({double income, double outcome}) accumulate(List<Transaction> transactions) {
  double income = 0;
  double outcome = 0;
  for (final transaction in transactions) {
    if (transaction.isConsume) {
      outcome += transaction.deltaAmount;
    } else {
      income += transaction.deltaAmount;
    }
  }
  return (income: income, outcome: outcome);
}
