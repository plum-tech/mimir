import 'package:collection/collection.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/l10n/time.dart';
import 'package:sit/utils/date.dart';

import '../entity/local.dart';
import '../entity/statistics.dart';
import "../i18n.dart";

class ExpensePieChart extends StatefulWidget {
  final Map<TransactionType, ({List<Transaction> records, double total, double proportion})> records;

  const ExpensePieChart({
    super.key,
    required this.records,
  });

  @override
  State<ExpensePieChart> createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends State<ExpensePieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    assert(widget.records.keys.every((type) => type.isConsume));
    return OutlinedCard(
      child: [
        AspectRatio(
          aspectRatio: 1.5,
          child: buildChart(),
        ),
        buildLegends().padAll(8).align(at: Alignment.topLeft),
      ].column(),
    );
  }

  Widget buildChart() {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(
          show: false,
        ),
        sectionsSpace: 0,
        centerSpaceRadius: 60,
        sections: widget.records.entries.mapIndexed((i, entry) {
          final isTouched = i == touchedIndex;
          final MapEntry(key: type, value: (records: _, :total, :proportion)) = entry;
          final color = type.color.harmonizeWith(context.colorScheme.primary);
          return PieChartSectionData(
            color: color.withOpacity(isTouched ? 1 : 0.8),
            value: total,
            title: "${(proportion * 100).toStringAsFixed(2)}%",
            titleStyle: context.textTheme.titleSmall,
            radius: isTouched ? 55 : 50,
            badgeWidget: Icon(type.icon, color: color),
            badgePositionPercentageOffset: 1.5,
          );
        }).toList(),
      ),
    );
  }

  Widget buildLegends() {
    return widget.records.entries
        .map((record) {
          final MapEntry(key: type, value: (records: _, :total, proportion: _)) = record;
          final color = type.color.harmonizeWith(context.colorScheme.primary);
          return Chip(
            avatar: Icon(type.icon, color: color),
            labelStyle: TextStyle(color: color),
            label: "${type.localized()}: ${i18n.unit.rmb(total.toStringAsFixed(2))}".text(),
          );
        })
        .toList()
        .wrap(spacing: 4);
  }
}

class ExpenseLineChart extends StatefulWidget {
  final DateTime start;
  final StatisticsMode mode;
  final List<Transaction> records;

  const ExpenseLineChart({
    super.key,
    required this.start,
    required this.records,
    required this.mode,
  });

  @override
  State<ExpenseLineChart> createState() => _ExpenseLineChartState();
}

final _monthFormat = DateFormat.MMM();

class _ExpenseLineChartState extends State<ExpenseLineChart> {
  @override
  Widget build(BuildContext context) {
    final (:data, :titles) = buildData(
      start: widget.start,
      mode: widget.mode,
      records: widget.records,
    );
    return OutlinedCard(
      child: AspectRatio(
        aspectRatio: 1.5,
        child: AmountChartWidget(
          bottomTitles: titles,
          values: data,
        ).padSymmetric(v: 12, h: 8),
      ),
    );
  }
}

({List<double> data, List<String> titles}) buildData({
  required DateTime start,
  required StatisticsMode mode,
  required List<Transaction> records,
}) {
  final now = DateTime.now();
  switch (mode) {
    case StatisticsMode.week:
      final List<double> weekAmount = List.filled(
        start.year == now.year && start.week == now.week ? now.weekday : 7,
        0.00,
      );
      for (final record in records) {
        // add data at the same weekday.
        // sunday goes first
        weekAmount[record.timestamp.weekday == DateTime.sunday ? 0 : record.timestamp.weekday] += record.deltaAmount;
      }
      return (data: weekAmount, titles: Weekday.calendarOrder.map((w) => w.l10nShort()).toList());
    case StatisticsMode.month:
      final List<double> dayAmount = List.filled(
          start.year == now.year && start.month == now.month
              ? now.day
              : daysInMonth(year: start.year, month: start.month),
          0.00);
      for (final record in records) {
        // add data on the same day.
        dayAmount[record.timestamp.day - 1] += record.deltaAmount;
      }
      return (data: dayAmount, titles: List.generate(dayAmount.length, (i) => (i + 1).toString()));
    case StatisticsMode.year:
      final List<double> monthAmount = List.filled(start.year == now.year ? now.month : 12, 0.00);
      for (final record in records) {
        // add data in the same month.
        monthAmount[record.timestamp.month - 1] += record.deltaAmount;
      }
      return (
        data: monthAmount,
        titles: List.generate(monthAmount.length, (i) => _monthFormat.format(DateTime(0, i + 1)).substring(0, 3))
      );
  }
}

class AmountChartWidget extends StatelessWidget {
  final List<String> bottomTitles;
  final List<double> values;

  const AmountChartWidget({
    super.key,
    required this.bottomTitles,
    required this.values,
  });

  Widget buildLeftTitle(double value, TitleMeta meta) {
    String text = '¥${value.round()}';
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text),
    );
  }

  Widget buildBottomTitle(double value, TitleMeta mate) {
    final index = value.toInt();
    if (!(index == 0 || index == values.length - 1) && index % 5 != 0) {
      return const SizedBox();
    }

    return SideTitleWidget(
      axisSide: mate.axisSide,
      child: Text(
        bottomTitles[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.center,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: buildBottomTitle,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: buildLeftTitle,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          checkToShowHorizontalLine: (value) => value % 5 == 0,
          getDrawingHorizontalLine: (value) => FlLine(
            color: context.colorScheme.secondary.withOpacity(0.2),
            strokeWidth: 1,
          ),
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(
          show: false,
        ),
        groupsSpace: 40,
        barGroups: values
            .mapIndexed((i, v) => BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: v,
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
