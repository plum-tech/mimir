import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';
import 'package:rettulf/rettulf.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../entity/score.dart';

const _targetScores2020 =
    Class2ndScoreSummary(lecture: 1.5, practice: 2, creation: 1.5, safetyEdu: 1, voluntary: 1, campusCulture: 1);
const _admissionYear2targetScores = {
  2013: Class2ndScoreSummary(lecture: 1, campusCulture: 1),
  2014: Class2ndScoreSummary(lecture: 1, practice: 1, campusCulture: 1),
  2015: Class2ndScoreSummary(lecture: 1, practice: 1, creation: 1, campusCulture: 1),
  2016: Class2ndScoreSummary(lecture: 1, practice: 1, creation: 1, campusCulture: 1),
  2017: Class2ndScoreSummary(lecture: 1.5, practice: 2, creation: 1.5, safetyEdu: 1, campusCulture: 2),
  2018: Class2ndScoreSummary(lecture: 1.5, practice: 2, creation: 1.5, safetyEdu: 1, campusCulture: 2),
  2019: Class2ndScoreSummary(lecture: 1.5, practice: 2, creation: 1.5, safetyEdu: 1, voluntary: 1, campusCulture: 1),
  2020: _targetScores2020,
};

Class2ndScoreSummary getTargetScoreOf({required int admissionYear}) {
  final targetScores = _admissionYear2targetScores[admissionYear];
  if (targetScores != null) {
    return targetScores;
  } else {
    return _targetScores2020;
  }
}

class Class2ndScoreSummaryChart extends StatelessWidget {
  final Class2ndScoreSummary targetScore;
  final Class2ndScoreSummary summary;

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
                return [
                  scores[i].name.text(style: isComplete? completeStyle : null),
                  scores[i].score.toString().text(style: isComplete ? completeStyle : null),
                ].column();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class Class2ndScoreSummeryCard extends StatelessWidget {
  final Class2ndScoreSummary targetScore;
  final Class2ndScoreSummary summary;

  const Class2ndScoreSummeryCard({
    super.key,
    required this.targetScore,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: Card(
        child: Class2ndScoreSummaryChart(targetScore: targetScore, summary: summary).padSymmetric(v: 4),
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
