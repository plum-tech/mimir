import 'package:flutter/material.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/life/expense_records/entity/statistics.dart';
import 'package:sit/life/expense_records/storage/local.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/life/expense_records/utils.dart';
import 'package:sit/utils/collection.dart';

import '../entity/local.dart';
import '../i18n.dart';
import '../init.dart';
import '../widget/chart.dart';

class ExpenseStatisticsPage extends StatefulWidget {
  const ExpenseStatisticsPage({super.key});

  @override
  State<ExpenseStatisticsPage> createState() => _ExpenseStatisticsPageState();
}

typedef Type2transactions = Map<TransactionType, ({List<Transaction> records, double total, double proportion})>;

class _ExpenseStatisticsPageState extends State<ExpenseStatisticsPage> {
  late List<Transaction> records;
  var selectedMode = StatisticsMode.month;
  late double total;

  @override
  void initState() {
    super.initState();
    refreshRecords();
  }

  void refreshRecords() {
    records = ExpenseRecordsInit.storage.getTransactionsByRange() ?? const [];
    records.retainWhere((record) => record.type.isConsume);
  }

  Widget buildModeSelector() {
    return SegmentedButton<StatisticsMode>(
      showSelectedIcon: false,
      segments: StatisticsMode.values
          .map((e) => ButtonSegment<StatisticsMode>(
                value: e,
                label: e.l10nName().text(),
              ))
          .toList(),
      selected: <StatisticsMode>{selectedMode},
      onSelectionChanged: (newSelection) {
        setState(() {
          selectedMode = newSelection.first;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.stats.title.text(),
      ),
      body: [
        buildModeSelector().padSymmetric(h: 16, v: 4),
        StatisticsSection(
          mode: selectedMode,
          all: records,
        ),
      ].listview(),
    );
    // final now = DateTime.now();
    // final years = _getYear(records);
    // final months = _getMonth(records, years, selectedYear);
    // return Scaffold(
    //   body: CustomScrollView(
    //     slivers: [
    //       SliverAppBar(
    //         pinned: true,
    //         expandedHeight: 200,
    //         flexibleSpace: FlexibleSpaceBar(
    //           title: i18n.stats.title.text(),
    //           centerTitle: true,
    //           background: YearMonthSelector(
    //             years: years,
    //             months: months,
    //             initialYear: now.year,
    //             initialMonth: now.month,
    //           ),
    //         ),
    //       ),
    //       SliverToBoxAdapter(
    //         child: _buildChartView(),
    //       ),
    //       SliverToBoxAdapter(
    //         child: ExpensePieChart(records: type2transactions),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class StatisticsSection extends StatefulWidget {
  final StatisticsMode mode;
  final List<Transaction> all;

  const StatisticsSection({
    super.key,
    required this.mode,
    required this.all,
  });

  @override
  State<StatisticsSection> createState() => _StatisticsSectionState();
}

class _StatisticsSectionState extends State<StatisticsSection> {
  late StartTime2Records startTime2Records = widget.mode.resort(widget.all);
  late int index = startTime2Records.length - 1;

  @override
  void didUpdateWidget(covariant StatisticsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode != widget.mode || oldWidget.all != widget.all) {
      setState(() {
        startTime2Records = widget.mode.resort(widget.all);
        index = startTime2Records.length - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = startTime2Records.indexAt(index);
    return [
      buildHeader(current.start),
      StatisticsPage(
        start: current.start,
        mode: widget.mode,
        records: current.records,
      ),
    ].column();
  }

  Widget buildHeader(DateTime start) {
    return OutlinedCard(
      child: [
        IconButton(
          onPressed: index > 0
              ? () {
                  setState(() {
                    index = index - 1;
                  });
                }
              : null,
          icon: Icon(context.icons.leftChevron),
        ),
        resolveTime4Display(context: context, mode: widget.mode, date: start).text(),
        IconButton(
          onPressed: index < startTime2Records.length - 1
              ? () {
                  setState(() {
                    index = index + 1;
                  });
                }
              : null,
          icon: Icon(context.icons.rightChevron),
        ),
      ].row(maa: MainAxisAlignment.spaceBetween),
    );
  }
}

class StatisticsPage extends StatefulWidget {
  final DateTime start;
  final List<Transaction> records;
  final StatisticsMode mode;

  const StatisticsPage({
    super.key,
    required this.start,
    required this.records,
    required this.mode,
  });

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    final separated = separateTransactionByType(widget.records);
    return [
      ExpenseLineChart(
        start: widget.start,
        records: widget.records,
        mode: widget.mode,
      ),
      ExpensePieChart(records: separated),
    ].column();
  }
}
