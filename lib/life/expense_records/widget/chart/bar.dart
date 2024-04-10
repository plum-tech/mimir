import 'dart:math';

import 'package:collection/collection.dart' hide IterableDoubleExtension;
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/l10n/time.dart';
import 'package:sit/route.dart';
import 'package:sit/utils/date.dart';
import 'package:statistics/statistics.dart';

import '../../entity/local.dart';
import '../../entity/statistics.dart';
import "../../i18n.dart";
import '../../utils.dart';
import 'header.dart';

class ExpenseBarChart extends StatefulWidget {
  final DateTime start;
  final StatisticsMode mode;
  final List<Transaction> records;

  const ExpenseBarChart({
    super.key,
    required this.start,
    required this.records,
    required this.mode,
  });

  @override
  State<ExpenseBarChart> createState() => _ExpenseBarChartState();
}

class _ExpenseBarChartState extends State<ExpenseBarChart> {
  @override
  Widget build(BuildContext context) {
    assert(widget.records.every((type) => type.isConsume));
    final delegate = StatisticsDelegate.byMode(
      widget.mode,
      start: widget.start,
      records: widget.records,
    );
    return [
      buildChartHeader(delegate).padFromLTRB(16, 8, 0, 8),
      AspectRatio(
        aspectRatio: 1.5,
        child: AmountChartWidget(
          delegate: delegate,
        ).padSymmetric(v: 12, h: 8),
      ),
    ].column(caa: CrossAxisAlignment.start);
  }

  Widget buildChartHeader(StatisticsDelegate delegate) {
    final from = widget.start;
    final to = widget.mode.getAfterUnitTime(start: widget.start, endLimit: DateTime.now());
    return switch (widget.mode) {
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

class StatisticsDelegate {
  final List<List<Transaction>> data;
  final double average;
  final double total;
  final StatisticsMode mode;
  final Widget Function(BuildContext context, double value, TitleMeta meta) side;
  final Widget Function(BuildContext context, double value, TitleMeta meta) bottom;

  const StatisticsDelegate({
    required this.mode,
    required this.data,
    required this.average,
    required this.total,
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
    final data = List.generate(
      start.year == now.year && start.week == now.week ? now.weekday : 7,
      (i) => <Transaction>[],
    );
    for (final record in records) {
      // add data at the same weekday.
      // sunday goes first
      data[record.timestamp.weekday == DateTime.sunday ? 0 : record.timestamp.weekday].add(record);
    }
    final amounts = records.map((r) => r.deltaAmount).toList();
    final dayTotals =
        data.map((monthRecords) => monthRecords.map((r) => r.deltaAmount).sum).where((total) => total > 0).toList();
    return StatisticsDelegate(
      mode: StatisticsMode.week,
      data: data,
      side: _buildSideTitle,
      average: dayTotals.isEmpty ? 0.0 : dayTotals.mean,
      total: amounts.sum,
      bottom: (ctx, value, mate) {
        final index = value.toInt();
        return SideTitleWidget(
          axisSide: mate.axisSide,
          child: Text(
            style: ctx.textTheme.labelMedium,
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
    final data = List.generate(
      start.year == now.year && start.month == now.month ? now.day : daysInMonth(year: start.year, month: start.month),
      (i) => <Transaction>[],
    );
    for (final record in records) {
      // add data on the same day.
      data[record.timestamp.day - 1].add(record);
    }
    final amounts = records.map((r) => r.deltaAmount).toList();
    final dayTotals =
        data.map((monthRecords) => monthRecords.map((r) => r.deltaAmount).sum).where((total) => total > 0).toList();
    final sep = data.length ~/ 5;
    return StatisticsDelegate(
      mode: StatisticsMode.week,
      data: data,
      average: dayTotals.isEmpty ? 0.0 : dayTotals.mean,
      total: amounts.sum,
      side: _buildSideTitle,
      bottom: (ctx, value, meta) {
        final index = value.toInt();
        if (!(index == 0 || index == data.length - 1) && index % sep != 0) {
          return const SizedBox();
        }
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: Text(
            style: ctx.textTheme.labelMedium,
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
    final _monthFormat = DateFormat.MMM($Key.currentContext!.locale.toString());
    final now = DateTime.now();
    final data = List.generate(start.year == now.year ? now.month : 12, (i) => <Transaction>[]);
    for (final record in records) {
      // add data in the same month.
      data[record.timestamp.month - 1].add(record);
    }
    final amounts = records.map((r) => r.deltaAmount).toList();
    final monthTotals =
        data.map((monthRecords) => monthRecords.map((r) => r.deltaAmount).sum).where((total) => total > 0).toList();
    return StatisticsDelegate(
      mode: StatisticsMode.week,
      data: data,
      average: monthTotals.isEmpty ? 0.0 : monthTotals.mean,
      total: amounts.sum,
      side: _buildSideTitle,
      bottom: (ctx, value, mate) {
        final index = value.toInt();
        final text = _monthFormat.format(DateTime(0, index + 1));
        return SideTitleWidget(
          axisSide: mate.axisSide,
          child: Text(
            style: ctx.textTheme.labelMedium,
            text.substring(0, min(3, text.length)),
          ),
        );
      },
    );
  }

  static Widget _buildSideTitle(BuildContext ctx, double value, TitleMeta meta) {
    String text = '¥${value.round()}';
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        style: ctx.textTheme.labelMedium,
        text,
      ),
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
              getTitlesWidget: (v, meta) => delegate.bottom(context, v, meta),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
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
                  labelResolver: (line) => "¥${line.y.toStringAsFixed(2)}",
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
          final (:total, :parts) = separateTransactionByType(records);
          var c = 0.0;
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: total,
                rodStackItems: parts.entries.map((e) {
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

