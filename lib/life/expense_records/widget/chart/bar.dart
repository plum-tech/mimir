import 'package:collection/collection.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/l10n/time.dart';
import 'package:sit/utils/date.dart';

import '../../entity/local.dart';
import '../../entity/statistics.dart';
import "../../i18n.dart";

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
    final delegate = StatisticsDelegate.byMode(
      widget.mode,
      start: widget.start,
      records: widget.records,
    );
    return OutlinedCard(
      child: AspectRatio(
        aspectRatio: 1.5,
        child: AmountChartWidget(
          delegate: delegate,
        ).padSymmetric(v: 12, h: 8),
      ),
    );
  }
}

final _monthFormat = DateFormat.MMM();

class StatisticsDelegate {
  final List<double> data;
  final StatisticsMode mode;
  final GetTitleWidgetFunction side;
  final GetTitleWidgetFunction bottom;

  const StatisticsDelegate({
    required this.mode,
    required this.data,
    required this.side,
    required this.bottom,
  });

  factory StatisticsDelegate.byMode(
    StatisticsMode mode, {
    required DateTime start,
    required List<Transaction> records,
  }) {
    switch (mode) {
      case StatisticsMode.week:
        return StatisticsDelegate.week(start: start, records: records);
      case StatisticsMode.month:
        return StatisticsDelegate.month(start: start, records: records);
      case StatisticsMode.year:
        return StatisticsDelegate.year(start: start, records: records);
    }
  }

  factory StatisticsDelegate.week({
    required DateTime start,
    required List<Transaction> records,
  }) {
    final now = DateTime.now();
    final List<double> weekAmount = List.filled(
      start.year == now.year && start.week == now.week ? now.weekday : 7,
      0.00,
    );
    for (final record in records) {
      // add data at the same weekday.
      // sunday goes first
      weekAmount[record.timestamp.weekday == DateTime.sunday ? 0 : record.timestamp.weekday] += record.deltaAmount;
    }
    return StatisticsDelegate(
      mode: StatisticsMode.week,
      data: weekAmount,
      side: _buildSideTitle,
      bottom: (value, mate) {
        final index = value.toInt();
        return SideTitleWidget(
          axisSide: mate.axisSide,
          child: Text(
            Weekday.calendarOrder[index].l10nShort(),
          ),
        );
      },
    );
  }

  factory StatisticsDelegate.month({
    required DateTime start,
    required List<Transaction> records,
  }) {
    final now = DateTime.now();
    final List<double> dayAmount = List.filled(
        start.year == now.year && start.month == now.month
            ? now.day
            : daysInMonth(year: start.year, month: start.month),
        0.00);
    for (final record in records) {
      // add data on the same day.
      dayAmount[record.timestamp.day - 1] += record.deltaAmount;
    }
    return StatisticsDelegate(
      mode: StatisticsMode.week,
      data: dayAmount,
      side: _buildSideTitle,
      bottom: (value, mate) {
        final index = value.toInt();
        return SideTitleWidget(
          axisSide: mate.axisSide,
          child: Text(
            "${index + 1}",
          ),
        );
      },
    );
  }

  factory StatisticsDelegate.year({
    required DateTime start,
    required List<Transaction> records,
  }) {
    final now = DateTime.now();
    final List<double> monthAmount = List.filled(start.year == now.year ? now.month : 12, 0.00);
    for (final record in records) {
      // add data in the same month.
      monthAmount[record.timestamp.month - 1] += record.deltaAmount;
    }
    return StatisticsDelegate(
      mode: StatisticsMode.week,
      data: monthAmount,
      side: _buildSideTitle,
      bottom: (value, mate) {
        final index = value.toInt();
        return SideTitleWidget(
          axisSide: mate.axisSide,
          child: Text(
            _monthFormat.format(DateTime(0, index + 1)).substring(0, 3),
          ),
        );
      },
    );
  }

  static Widget _buildSideTitle(double value, TitleMeta meta) {
    String text = '¥${value.round()}';
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text),
    );
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
              getTitlesWidget: delegate.bottom,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: delegate.side,
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
        barGroups: delegate.data
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
