import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/attended.dart';

const _targetScores2019 = Class2ndPointsSummary(
  thematicReport: 1.5,
  practice: 2,
  creation: 1.5,
  schoolSafetyCivilization: 1,
  voluntary: 1,
  schoolCulture: 1,
);
const _admissionYear2targetScores = {
  2013: Class2ndPointsSummary(thematicReport: 1, schoolCulture: 1),
  2014: Class2ndPointsSummary(thematicReport: 1, practice: 1, schoolCulture: 1),
  2015: Class2ndPointsSummary(thematicReport: 1, practice: 1, creation: 1, schoolCulture: 1),
  2016: Class2ndPointsSummary(thematicReport: 1, practice: 1, creation: 1, schoolCulture: 1),
  2017: Class2ndPointsSummary(
    thematicReport: 1.5,
    practice: 2,
    creation: 1.5,
    schoolSafetyCivilization: 1,
    schoolCulture: 2,
  ),
  2018: Class2ndPointsSummary(
    thematicReport: 1.5,
    practice: 2,
    creation: 1.5,
    schoolSafetyCivilization: 1,
    schoolCulture: 2,
  ),
  2019: _targetScores2019,
  2020: _targetScores2019,
  2021: _targetScores2019,
  2022: _targetScores2019,
  2023: _targetScores2019,
};

Class2ndPointsSummary getTargetScoreOf({required int? admissionYear}) {
  return _admissionYear2targetScores[admissionYear] ?? _targetScores2019;
}

class Class2ndScoreSummeryCard extends StatelessWidget {
  final Class2ndPointsSummary targetScore;
  final Class2ndPointsSummary summary;
  final double aspectRatio;

  const Class2ndScoreSummeryCard({
    super.key,
    required this.targetScore,
    required this.summary,
    this.aspectRatio = 16 / 9,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Card(
        child: Class2ndScoreSummaryChart(targetScore: targetScore, summary: summary).padSymmetric(v: 4),
      ),
    );
  }
}

class Class2ndScoreSummaryChart extends StatelessWidget {
  final Class2ndPointsSummary targetScore;
  final Class2ndPointsSummary summary;

  const Class2ndScoreSummaryChart({
    super.key,
    required this.targetScore,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final scores = summary.toName2score();
    final targetScores = targetScore.toName2score();
    final barColor = context.colorScheme.primary;
    final completeStyle = TextStyle(color: context.colorScheme.primary);
    List<BarChartGroupData> values = [];
    for (var i = 0; i < scores.length; i++) {
      // Skip empty targets to prevent zero-division error.
      if (targetScores[i].score == 0) continue;
      final pct = scores[i].score / targetScores[i].score;
      values.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(
          toY: pct,
          width: 12,
          color: barColor,
        ),
      ]));
    }
    return BarChart(
      BarChartData(
        maxY: 1,
        barGroups: values,
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: const AxisTitles(),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double indexDouble, TitleMeta meta) {
                final i = indexDouble.toInt();
                final isComplete = scores[i].score / targetScores[i].score >= 1;
                return targetScores[i].score.toString().text(style: isComplete ? completeStyle : null);
              },
            ),
          ),
          rightTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              getTitlesWidget: (double indexDouble, TitleMeta meta) {
                final i = indexDouble.toInt();
                final isComplete = scores[i].score / targetScores[i].score >= 1;
                return Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: scores[i].type.l10nFullName(),
                  child: [
                    scores[i].type.l10nShortName().text(style: isComplete ? completeStyle : null),
                    scores[i].score.toString().text(style: isComplete ? completeStyle : null),
                  ].column(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// syncfusion_flutter_charts: ^22.2.12
// SfCartesianChart(
//   primaryXAxis: CategoryAxis(
//     majorGridLines: const MajorGridLines(width: 0),
//     axisLine: const AxisLine(width: 0),
//   ),
//   primaryYAxis: NumericAxis(
//     minimum: 0,
//     maximum: 1,
//     numberFormat: NumberFormat.percentPattern(),
//     majorGridLines: const MajorGridLines(width: 0),
//     axisLine: const AxisLine(width: 0),
//   ),
//   series: <ChartSeries<({String name, double score}), String>>[
//     BarSeries<({String name, double score}), String>(
//       borderRadius: BorderRadius.circular(4),
//       dataSource: scoreValues,
//       xValueMapper: (data, _) => data.name,
//       dataLabelMapper: (data, i) => "${data.score}/${targetScores[i].score}".toString(),
//       yValueMapper: (data, i) => data.score / targetScores[i].score,
//       color: context.colorScheme.primary,
//       dataLabelSettings: const DataLabelSettings(isVisible: true),
//     )
//   ],
// );
