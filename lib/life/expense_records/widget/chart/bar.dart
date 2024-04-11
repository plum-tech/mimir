import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/utils/date.dart';

import '../../entity/statistics.dart';
import '../../utils.dart';
import 'delegate.dart';
import 'header.dart';

class ExpenseBarChart extends StatefulWidget {
  final StatisticsDelegate delegate;

  const ExpenseBarChart({
    super.key,
    required this.delegate,
  });

  @override
  State<ExpenseBarChart> createState() => _ExpenseBarChartState();
}

class _ExpenseBarChartState extends State<ExpenseBarChart> {
  StatisticsDelegate get delegate => widget.delegate;
  DateTime get start => delegate.start;
  StatisticsMode get mode => delegate.mode;
  @override
  Widget build(BuildContext context) {
    return [
      buildChartHeader().padFromLTRB(16, 8, 0, 8),
      AspectRatio(
        aspectRatio: 1.5,
        child: AmountChartWidget(
          delegate: delegate,
        ).padSymmetric(v: 12, h: 8),
      ),
    ].column(caa: CrossAxisAlignment.start);
  }

  Widget buildChartHeader() {
    final from = start;
    final to = mode.getAfterUnitTime(start: start, endLimit: DateTime.now());
    return switch (mode) {
      StatisticsMode.day => ExpenseChartHeader(
        upper: "Hourly average",
        content: "¥${delegate.average.toStringAsFixed(2)}",
        lower: DateFormat.yMMMMd().format(from),
      ),
      StatisticsMode.year => ExpenseChartHeader(
          upper: "Monthly average",
          content: "¥${delegate.average.toStringAsFixed(2)}",
          lower: formatDateSpan(from: from, to: to),
        ),
      StatisticsMode.week || StatisticsMode.month => ExpenseChartHeader(
          upper: "Daily average",
          content: "¥${delegate.average.toStringAsFixed(2)}",
          lower: formatDateSpan(from: from, to: to),
        ),
    };
  }
}

class AmountChartWidget extends StatelessWidget {
  final StatisticsDelegate delegate;

  const AmountChartWidget({
    super.key,
    required this.delegate,
  });

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
              getTitlesWidget: (v, meta) => delegate.bottom(context, v, meta),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (v, meta) => delegate.side(context, v, meta),
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            if (delegate.average.isFinite)
              HorizontalLine(
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.bottomRight,
                  style: context.textTheme.labelSmall,
                  labelResolver: (line) => "avg",
                ),
                y: delegate.average,
                strokeWidth: 3,
                color: context.colorScheme.tertiary.withOpacity(0.5),
                dashArray: [5, 5],
              ),
          ],
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
        barGroups: delegate.data.mapIndexed((i, records) {
          final (:total, :type2Stats) = statisticsTransactionByType(records);
          var c = 0.0;
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: total,
                rodStackItems: type2Stats.entries.map((e) {
                  final res = BarChartRodStackItem(
                    c,
                    c + e.value.total,
                    e.key.color,
                  );
                  c += e.value.total;
                  return res;
                }).toList(),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

