import 'package:collection/collection.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:rettulf/rettulf.dart';
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

class _ExpenseLineChartState extends State<ExpenseLineChart> {
  @override
  Widget build(BuildContext context) {
    final data = buildData();
    return OutlinedCard(
      child: AspectRatio(
        aspectRatio: 1.5,
        child: BaseLineChartWidget(
          bottomTitles: List.generate(data.length, (i) => (i + 1).toString()),
          values: data,
        ).padSymmetric(v: 12, h: 8),
      ),
    );
  }

  List<double> buildData() {
    final now = DateTime.now();
    final start = widget.start;
    switch (widget.mode) {
      case StatisticsMode.week:
        final List<double> daysAmount = List.filled(7, 0.00);
        for (final record in widget.records) {
          daysAmount[(record.timestamp.day - 1) % 7] += record.deltaAmount;
        }
        return daysAmount;
      case StatisticsMode.month:
        final List<double> daysAmount = List.filled(
            start.year == now.year && start.month == now.month
                ? now.day
                : daysInMonth(year: start.year, month: start.month),
            0.00);
        for (final record in widget.records) {
          daysAmount[record.timestamp.day - 1] += record.deltaAmount;
        }
        return daysAmount;
      case StatisticsMode.year:
        final List<double> monthAmounts = List.filled(start.year == now.year ? now.month : 12, 0.00);
        for (final record in widget.records) {
          monthAmounts[record.timestamp.month - 1] += record.deltaAmount;
        }
        return monthAmounts;
    }
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
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.transparent,
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
