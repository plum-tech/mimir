import 'package:collection/collection.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/card.dart';

import '../../entity/local.dart';
import "../../i18n.dart";

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
