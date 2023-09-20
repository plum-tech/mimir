import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:mimir/life/expense_records/storage/local.dart';
import 'package:mimir/life/expense_records/utils.dart';
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

class _ExpenseStatisticsPageState extends State<ExpenseStatisticsPage> {
  late List<Transaction> records;
  late double total;
  late Map<TransactionType, ({List<Transaction> records, double total, double proportion})> type2transactions;
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

  @override
  Widget build(BuildContext context) {
    final years = _getYear(records);
    final months = _getMonth(records, years, selectedYear);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 180,
          flexibleSpace: FlexibleSpaceBar(
            title: i18n.stats.title.text(),
            centerTitle: true,
            background: YearMonthSelector(
              years: years,
              months: months,
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

  static int _getDayCountOfMonth(int year, int month) {
    final int daysFeb = (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) ? 29 : 28;
    List<int> days = [31, daysFeb, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return days[month - 1];
  }

  Widget _buildChartView() {
    // 得到该年该月有多少天, 生成数组记录每一天的消费.
    final List<double> daysAmount = List.filled(_getDayCountOfMonth(selectedYear, selectedMonth), 0.00);
    // 便利该月消费情况, 加到上述统计列表中.
    for (final record in records) {
      daysAmount[record.timestamp.day - 1] += record.deltaAmount;
    }

    final width = MediaQuery.of(context).size.width - 70;
    return OutlinedCard(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
              child: i18n.stats.title.text(style: context.textTheme.titleLarge).center(),
            ),
            // const SizedBox(height: 5),
            Center(
              child: SizedBox(
                height: width * 0.5,
                width: width,
                child: BaseLineChartWidget(
                  bottomTitles: List.generate(daysAmount.length, (i) => (i + 1).toString()),
                  values: daysAmount,
                ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

class BaseLineChartWidget extends StatelessWidget {
  final List<String> bottomTitles;
  final List<double> values;

  const BaseLineChartWidget({
    Key? key,
    required this.bottomTitles,
    required this.values,
  }) : super(key: key);

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

  List<FlSpot> buildSpotList() {
    return values
        .map((e) => (e * 100).toInt() / 100) // 保留两位小数
        .toList()
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        ///触摸控制
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.transparent,
          ),
          touchSpotThreshold: 10,
        ),
        borderData: FlBorderData(
          border: const Border(
            bottom: BorderSide(width: 1.0),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).secondaryHeaderColor.withAlpha(70),
            ),
            spots: buildSpotList(),
            color: Colors.blueAccent,
            preventCurveOverShooting: false,
            // isCurved: true,
            barWidth: 2,
            preventCurveOvershootingThreshold: 1.0,
          ),
        ],

        ///图表线表线框
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 2,
          verticalInterval: 2,
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (v, meta) => leftTitle(context, v, meta),
            ),
          ),
          topTitles: AxisTitles(),
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
