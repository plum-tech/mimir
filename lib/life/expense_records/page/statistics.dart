import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
import '../widget/transaction.dart';

class ExpenseStatisticsPage extends StatefulWidget {
  const ExpenseStatisticsPage({super.key});

  @override
  State<ExpenseStatisticsPage> createState() => _ExpenseStatisticsPageState();
}

typedef Type2transactions = Map<TransactionType, ({List<Transaction> records, double total, double proportion})>;

class _ExpenseStatisticsPageState extends State<ExpenseStatisticsPage> {
  late List<Transaction> allRecords;
  var selectedMode = StatisticsMode.month;
  late double total;

  @override
  void initState() {
    super.initState();
    refreshRecords();
  }

  void refreshRecords() {
    allRecords = ExpenseRecordsInit.storage.getTransactionsByRange() ?? const [];
    allRecords.retainWhere((record) => record.type.isConsume);
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
          all: allRecords,
        ).expanded(),
      ].column(caa: CrossAxisAlignment.stretch),
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
    final separated = separateTransactionByType(current.records);
    return [
      [
        SizedBox(height: 50,),
        ExpenseLineChart(
          start: current.start,
          records: current.records,
          mode: widget.mode,
        ),
        ExpensePieChart(records: separated),
        ...current.records.map((record) {
          return TransactionTile(record);
        }),
      ].listview(),
      // ListView()
      buildHeader(current.start).align(at: Alignment.topCenter),
    ].stack();
    return [
      buildHeader(current.start),
      [
        ExpenseLineChart(
          start: current.start,
          records: current.records,
          mode: widget.mode,
        ),
        ExpensePieChart(records: separated),
        ...current.records.map((record) {
          return TransactionTile(record);
        }),
      ].listview().expanded(),
      // ListView()
    ].column();
  }

  Widget buildHeader(DateTime start) {
    return OutlinedCard(
      child: [
        PlatformIconButton(
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
        PlatformIconButton(
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
