import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/grouped.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/local.dart';
import '../i18n.dart';

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
        .groupListsBy((r) => (year: r.datetime.year, month: r.datetime.month))
        .entries
        .map((e) => (time: e.key, records: e.value))
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
            title: context.formatYmText((e.time.toDateTime())).text(),
            subtitle: "${i18n.income(income.toStringAsFixed(2))} ${i18n.outcome(outcome.toStringAsFixed(2))}".text(),
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

// return GroupedListView<Transaction, int>(
//   // 生成每一组的头部
//   groupHeaderBuilder: (Transaction firstGroupRecord) {
//     double totalSpent = 0;
//     double totalIncome = 0;
//     int month = firstGroupRecord.datetime.month;
//     int year = firstGroupRecord.datetime.year;
//
//     for (final element in records) {
//       if (element.datetime.month == month && element.datetime.year == year) {
//         if (element.isConsume) {
//           totalSpent += element.deltaAmount;
//         } else {
//           totalIncome += element.deltaAmount;
//         }
//       }
//     }
//     return ListTile(
//       tileColor: context.bgColor,
//       title: context.formatYmText(firstGroupRecord.datetime).text(style: groupTitleStyle),
//       subtitle:
//           "${i18n.spentStatistics(totalSpent.toStringAsFixed(2))} ${i18n.incomeStatistics(totalIncome.toStringAsFixed(2))}"
//               .text(style: groupSubtitleStyle),
//     );
//   },
// );

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile(this.transaction, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(transaction.bestTitle ?? i18n.unknown, style: context.textTheme.titleSmall),
      subtitle: context.formatYmdhmsNum(transaction.datetime).text(),
      leading: transaction.type.icon.make(color: transaction.type.color, size: 32),
      trailing: transaction.toReadableString().text(
            style: TextStyle(color: transaction.billColor, fontWeight: FontWeight.bold, fontSize: 18),
          ),
    );
  }
}
