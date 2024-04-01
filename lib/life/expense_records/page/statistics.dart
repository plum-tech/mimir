import 'package:flutter/material.dart';
import 'package:sit/life/expense_records/entity/statistics.dart';
import 'package:sit/life/expense_records/storage/local.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/life/expense_records/utils.dart';

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
  late StartTime2Records startTime2Records = resortRecords();

  StartTime2Records resortRecords() {
    final startTime2Records = widget.mode.resort(widget.all);
    return startTime2Records;
  }

  @override
  void didUpdateWidget(covariant StatisticsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode != widget.mode || oldWidget.all != widget.all) {
      setState(() {
        startTime2Records = resortRecords();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatisticsPage(
      start: startTime2Records.first.start,
      mode: widget.mode,
      records: startTime2Records.first.records,
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
