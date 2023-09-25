import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/grouped.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/local.dart';
import '../utils.dart';
import '../i18n.dart';
import 'transaction.dart';

class TransactionGroupSection extends StatelessWidget {
  final bool initialExpanded;
  final YearMonth time;
  final List<Transaction> records;

  const TransactionGroupSection({
    required this.time,
    required this.records,
    this.initialExpanded = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final (:income, :outcome) = accumulateTransactionIncomeOutcome(records);
    return GroupedSection(
      title: context.formatYmText((time.toDateTime())).text(style: context.textTheme.titleMedium),
      subtitle: "${i18n.income(income.toStringAsFixed(2))}\n${i18n.outcome(outcome.toStringAsFixed(2))}".text(
        maxLines: 2,
      ),
      initialExpanded: initialExpanded,
      items: records,
      itemBuilder: (ctx, i, record) {
        return TransactionTile(record);
      },
    );
  }
}
