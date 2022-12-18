import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../entity/statistics.dart';
import 'base_chart.dart';

class DailyElectricityChart extends StatelessWidget {
  final List<DailyBill> data;
  const DailyElectricityChart(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseElectricityChartWidget(
      values: data.map((e) => e.consumption).toList(),
      bottomTitles: data.map((e) => DateFormat('MM/dd').format(e.date)).toList(),
    );
  }
}
