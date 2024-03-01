import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/life/expense_records/entity/statistics.dart';
import 'package:sit/life/expense_records/storage/local.dart';
import 'package:sit/life/expense_records/utils.dart';
import 'package:rettulf/rettulf.dart';
import 'package:fl_chart/fl_chart.dart';

import '../entity/local.dart';
import '../i18n.dart';
import '../init.dart';
import '../widget/chart.dart';
import '../widget/selector.dart';

class ExpenseStatisticsPage extends StatefulWidget {
  const ExpenseStatisticsPage({super.key});

  @override
  State<ExpenseStatisticsPage> createState() => _ExpenseStatisticsPageState();
}

typedef Type2transactions = Map<TransactionType, ({List<Transaction> records, double total, double proportion})>;

class _ExpenseStatisticsPageState extends State<ExpenseStatisticsPage> {
  late List<Transaction> records;
  var selectedMode = StatisticsMode.week;
  late double total;
  late Type2transactions type2transactions;
  late int selectedYear;
  late int selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedYear = now.year;
    selectedMonth = now.month;
    refreshRecords();
  }

  void refreshRecords() {
    records = ExpenseRecordsInit.storage.getTransactionsByRange(
          start: DateTime(selectedYear, selectedMonth, 1),
          end: DateTime(selectedYear, selectedMonth + 1),
        ) ??
        const [];
    records.retainWhere((record) => record.type.isConsume);
    final type2transactions = records.groupListsBy((record) => record.type);
    final type2total = type2transactions.map((type, records) => MapEntry(type, accumulateTransactionAmount(records)));
    total = type2total.values.sum;
    this.type2transactions = type2transactions.map((type, records) {
      final (income: _, :outcome) = accumulateTransactionIncomeOutcome(records);
      return MapEntry(type, (records: records, total: outcome, proportion: (type2total[type] ?? 0) / total));
    });
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
        StatisticsSection(mode: selectedMode, all: type2transactions).expanded(),
      ].column(),
    );
    // _buildChartView(),
    // ExpensePieChart(records: type2transactions),
    final now = DateTime.now();
    final years = _getYear(records);
    final months = _getMonth(records, years, selectedYear);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: i18n.stats.title.text(),
              centerTitle: true,
              background: YearMonthSelector(
                years: years,
                months: months,
                initialYear: now.year,
                initialMonth: now.month,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildChartView(),
          ),
          SliverToBoxAdapter(
            child: ExpensePieChart(records: type2transactions),
          ),
        ],
      ),
    );
  }

  List<int> _getYear(List<Transaction> expenseBillDesc) {
    List<int> years = [];
    final now = DateTime.now();
    final currentYear = now.year;
    final int startYear = expenseBillDesc.isNotEmpty ? expenseBillDesc.last.timestamp.year : currentYear;
    for (int year = startYear; year <= currentYear; year++) {
      years.add(year);
    }
    return years;
  }

  List<int> _getMonth(List<Transaction> expenseBill, List<int> years, int year) {
    List<int> result = [];
    final now = DateTime.now();
    if (now.year == year) {
      for (int month = 1; month <= now.month; month++) {
        result.add(month);
      }
    } else if (years.first == year) {
      for (int month = expenseBill.last.timestamp.month; month <= 12; month++) {
        result.add(month);
      }
    } else {
      result = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    }
    return result;
  }

  static int getDayCountOfMonth(int year, int month) {
    final int daysFeb = (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) ? 29 : 28;
    List<int> days = [31, daysFeb, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return days[month - 1];
  }

  Widget _buildChartView() {
    // TODO: take current month into account
    // 得到该年该月有多少天, 生成数组记录每一天的消费.
    final List<double> daysAmount = List.filled(getDayCountOfMonth(selectedYear, selectedMonth), 0.00);
    // 便利该月消费情况, 加到上述统计列表中.
    for (final record in records) {
      daysAmount[record.timestamp.day - 1] += record.deltaAmount;
    }
    return OutlinedCard(
      child: AspectRatio(
        aspectRatio: 1.5,
        child: BaseLineChartWidget(
          bottomTitles: List.generate(daysAmount.length, (i) => (i + 1).toString()),
          values: daysAmount,
        ).padSymmetric(v: 12, h: 8),
      ),
    );
  }

  Widget buildWeekChart() {
    return const BaseLineChartWidget(
      bottomTitles: [],
      values: [],
    );
  }

  Widget buildMonthChart() {
    return const BaseLineChartWidget(
      bottomTitles: [],
      values: [],
    );
  }

  Widget buildYearChart() {
    return const BaseLineChartWidget(
      bottomTitles: [],
      values: [],
    );
  }
}

class StatisticsSection extends StatefulWidget {
  final StatisticsMode mode;
  final Type2transactions all;

  const StatisticsSection({
    super.key,
    required this.mode,
    required this.all,
  });

  @override
  State<StatisticsSection> createState() => _StatisticsSectionState();
}

class _StatisticsSectionState extends State<StatisticsSection> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: 10,
      itemBuilder: (ctx, i) {
        return const StatisticsPage();
      },
    );
  }
}

class BaseLineChartWidget extends StatelessWidget {
  final List<String> bottomTitles;
  final List<double> values;

  const BaseLineChartWidget({
    super.key,
    required this.bottomTitles,
    required this.values,
  });

  ///底部标题栏
  Widget bottomTitle(BuildContext ctx, double value, TitleMeta mate) {
    if ((value * 10).toInt() % 10 == 5) {
      return const SizedBox();
    }

    return SideTitleWidget(
      axisSide: mate.axisSide,
      child: Text(
        bottomTitles[value.toInt()],
        style: ctx.textTheme.bodySmall?.copyWith(
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  ///左边部标题栏
  Widget leftTitle(BuildContext ctx, double value, TitleMeta mate) {
    const style = TextStyle(
      color: Colors.blueGrey,
      fontSize: 11,
    );
    String text = '¥${value.toStringAsFixed(2)}';
    return SideTitleWidget(
      axisSide: mate.axisSide,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        ///触摸控制
        lineTouchData: const LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.transparent,
          ),
          touchSpotThreshold: 10,
        ),
        borderData: FlBorderData(
          border: const Border(
            bottom: BorderSide.none,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              color: context.colorScheme.primary.withOpacity(0.15),
            ),
            spots: values
                .map((e) => (e * 100).toInt() / 100) // 保留两位小数
                .toList()
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            color: context.colorScheme.primary,
            isCurved: true,
            preventCurveOverShooting: true,
            barWidth: 1,
          ),
        ],

        ///图表线表线框
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (v, meta) => leftTitle(context, v, meta),
            ),
          ),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 55,
              getTitlesWidget: (v, meta) => bottomTitle(context, v, meta),
            ),
          ),
        ),
      ),
    );
  }
}

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
