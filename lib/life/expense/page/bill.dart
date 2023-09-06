import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:mimir/design/colors.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/local.dart';
import '../i18n.dart';

class BillPage extends StatelessWidget {
  final List<Transaction> records;

  const BillPage({
    Key? key,
    required this.records,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final groupTitleStyle = textTheme.titleMedium;
    final groupSubtitleStyle = textTheme.titleLarge;

    return GroupedListView<Transaction, int>(
      elements: records,
      groupBy: (element) => element.datetime.year * 12 + element.datetime.month,
      useStickyGroupSeparators: true,
      stickyHeaderBackgroundColor: context.bgColor,
      order: GroupedListOrder.DESC,
      itemComparator: (item1, item2) => item1.datetime.compareTo(item2.datetime),
      // 生成每一组的头部
      groupHeaderBuilder: (Transaction firstGroupRecord) {
        double totalSpent = 0;
        double totalIncome = 0;
        int month = firstGroupRecord.datetime.month;
        int year = firstGroupRecord.datetime.year;

        for (final element in records) {
          if (element.datetime.month == month && element.datetime.year == year) {
            if (element.isConsume) {
              totalSpent += element.deltaAmount;
            } else {
              totalIncome += element.deltaAmount;
            }
          }
        }
        return ListTile(
          tileColor: context.bgColor,
          title: context.formatYmText(firstGroupRecord.datetime).text(style: groupTitleStyle),
          subtitle:
              "${i18n.spentStatistics(totalSpent.toStringAsFixed(2))} ${i18n.incomeStatistics(totalIncome.toStringAsFixed(2))}"
                  .text(style: groupSubtitleStyle),
        );
      },
      // 生成账单项
      itemBuilder: (ctx, e) {
        return TransactionTile(trans: e);
      },
    );
  }
}

class TransactionTile extends StatelessWidget {
  final Transaction trans;

  const TransactionTile({super.key, required this.trans});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(trans.bestTitle ?? i18n.unknown, style: context.textTheme.titleSmall),
      subtitle: context.formatYmdhmsNum(trans.datetime).text(),
      leading: trans.type.icon.make(color: trans.type.color, size: 32),
      trailing: trans.toReadableString().text(
            style: TextStyle(color: trans.billColor, fontWeight: FontWeight.bold, fontSize: 18),
          ),
    );
  }
}
