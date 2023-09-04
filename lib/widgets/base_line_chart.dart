import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

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
