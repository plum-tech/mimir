import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../entity/statistics.dart';
import 'base_chart.dart';

class HourlyElectricityChart extends StatelessWidget {
  final List<HourlyBill> data;
  const HourlyElectricityChart(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseElectricityChartWidget(
      values: data.map((e) => e.consumption).toList(),
      bottomTitles: data.map((e) => DateFormat('HH:mm').format(e.time)).toList(),
    );
  }
}
