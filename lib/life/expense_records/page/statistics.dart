import 'package:flutter/material.dart';
import 'package:mimir/life/expense_records/init.dart';
import 'package:mimir/widgets/base_line_chart.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/local.dart';
import '../i18n.dart';

class ExpenseStatisticsPage extends StatefulWidget {
  const ExpenseStatisticsPage({super.key});

  @override
  State<ExpenseStatisticsPage> createState() => _ExpenseStatisticsPageState();
}

class _ExpenseStatisticsPageState extends State<ExpenseStatisticsPage> {
  // TODO:
  late List<Transaction> records = [];
  final now = DateTime.now();

  late int selectedYear = now.year;
  late int selectedMonth = now.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.stats.title.text(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildDateSelector(),
            _buildChartView(),
            _buildClassificationView(),
          ],
        ),
      ),
    );
  }

  List<int> _getYear(List<Transaction> expenseBillDesc) {
    List<int> years = [];

    final currentYear = now.year;
    final int startYear = expenseBillDesc.isNotEmpty ? expenseBillDesc.last.datetime.year : currentYear;
    for (int year = startYear; year <= currentYear; year++) {
      years.add(year);
    }
    return years;
  }

  List<int> _getMonth(List<Transaction> expenseBill, List<int> years, int year) {
    List<int> result = [];
    if (now.year == year) {
      for (int month = 1; month <= now.month; month++) {
        result.add(month);
      }
    } else if (years.first == year) {
      for (int month = expenseBill.last.datetime.month; month <= 12; month++) {
        result.add(month);
      }
    } else {
      result = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    }
    return result;
  }

  Widget _buildDateSelector() {
    // TODO: 支持查看全年统计, 此时 chart line 也需要修改.
    final List<int> years = _getYear(records);
    final List<int> months = _getMonth(records, years, selectedYear);

    // TODO: 年月不超过当前日期.
    final yearWidgets = years.map((e) => PopupMenuItem<int>(value: e, child: Text(e.toString()))).toList();
    final monthWidgets = months.map((e) => PopupMenuItem<int>(value: e, child: Text(e.toString()))).toList();

    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          PopupMenuButton(
            onSelected: (int value) => setState(() {
              selectedYear = value;
              final monthList = _getMonth(records, years, selectedYear);
              if (!monthList.toSet().contains(selectedMonth)) {
                selectedMonth = monthList[0];
              }
            }),
            child: Text('$selectedYear 年', style: titleStyle),
            itemBuilder: (_) => yearWidgets,
          ),
          PopupMenuButton(
            onSelected: (int value) => setState(() => selectedMonth = value),
            child: Text(' $selectedMonth 月', style: titleStyle),
            itemBuilder: (_) => monthWidgets,
          ),
        ],
      ),
    );
  }

  // TODO: 这个函数应该放在 DAO 或 service
  List<Transaction> _filterExpense() {
    return records
        .where((element) => element.datetime.year == selectedYear && element.datetime.month == selectedMonth)
        .toList();
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
    _filterExpense().forEach(
        (e) => daysAmount[e.datetime.day - 1] += ((delta) => delta < 0 ? -delta : 0)(e.balanceAfter - e.balanceBefore));

    final width = MediaQuery.of(context).size.width - 70;
    return Card(
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

  List<Widget> _buildClassifiedStat(BuildContext ctx) {
    final theme = ctx.theme;
    // 各分类下消费的统计
    List<double> sumByClassification = List.filled(TransactionType.values.length, 0.0);
    for (final line in _filterExpense()) {
      sumByClassification[line.type.index] +=
          ((delta) => delta < 0 ? -delta : 0)(line.balanceAfter - line.balanceBefore);
    }
    final backgroundColor = theme.secondaryHeaderColor;

    double sum = sumByClassification.fold(0.0, (previousValue, element) => previousValue += element);

    return TransactionType.values.where((e) => !{TransactionType.topUp, TransactionType.subsidy}.contains(e)).map(
      (type) {
        final double sumInType = sumByClassification[type.index];
        final double percentage = sum != 0 ? sumInType / sum : 0;

        return ListTile(
          leading: type.icon.make(color: type.color, size: 32),
          title: type.localized().text(style: theme.textTheme.titleMedium),
          subtitle: LinearProgressIndicator(value: percentage, backgroundColor: backgroundColor),
          // 下方 SizedBox 用于限制文字宽度, 使左侧进度条的右端对齐.
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              i18n.unit.rmb(sumInType.toStringAsFixed(2)).text(),
              SizedBox(
                width: 60,
                child: Text(
                  '${(percentage * 100).toStringAsFixed(2)}%',
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          dense: true,
        );
      },
    ).toList();
  }

  Widget _buildClassificationView() {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
            child: i18n.stats.categories.text(style: context.textTheme.titleLarge).center(),
          ),
          Column(
            children: _buildClassifiedStat(context),
          )
        ],
      ),
    );
  }
}
