import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/common.dart';

import '../entity/local.dart';
import '../utils.dart';
import 'group.dart';
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

class _TransactionListState extends State<TransactionList> {
  late List<({YearMonth time, List<Transaction> records})> month2records = groupTransactionsByMonthYear(widget.records);

  @override
  void didUpdateWidget(covariant TransactionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.records.equals(oldWidget.records)) {
      setState(() {
        month2records = groupTransactionsByMonthYear(widget.records);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (month2records.isEmpty)
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
    );
  }
}
