import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/score.dart';
import "../i18n.dart";

Class2ndScoreSummary calcTargetScore(int admissionYear) {
  const table = {
    2013: Class2ndScoreSummary(lecture: 1, campus: 1),
    2014: Class2ndScoreSummary(lecture: 1, practice: 1, campus: 1),
    2015: Class2ndScoreSummary(lecture: 1, practice: 1, creation: 1, campus: 1),
    2016: Class2ndScoreSummary(lecture: 1, practice: 1, creation: 1, campus: 1),
    2017: Class2ndScoreSummary(lecture: 1.5, practice: 2, creation: 1.5, safetyEdu: 1, campus: 2),
    2018: Class2ndScoreSummary(lecture: 1.5, practice: 2, creation: 1.5, safetyEdu: 1, campus: 2),
    2019: Class2ndScoreSummary(lecture: 1.5, practice: 2, creation: 1.5, safetyEdu: 1, voluntary: 1, campus: 1),
    2020: Class2ndScoreSummary(lecture: 1.5, practice: 2, creation: 1.5, safetyEdu: 1, voluntary: 1, campus: 1),
  };
  if (table.keys.contains(admissionYear)) {
    return table[admissionYear]!;
  } else {
    return table[2020]!;
  }
}

FlBorderData _borderData() => FlBorderData(show: false);

FlGridData _gridData() => FlGridData(show: false);

BarTouchData _barTouchData() => BarTouchData(
      enabled: false,
      /*touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.transparent,
        tooltipPadding: const EdgeInsets.all(0),
        tooltipMargin: 0,
        getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
        ) {
          return BarTooltipItem(
            rod.toY.round().toString(),
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),*/
    );

Widget _buildChart(BuildContext ctx, Class2ndScoreSummary targetScore, Class2ndScoreSummary? summary,
    {bool showTotal = false}) {
  if (summary == null) {
    return const CircularProgressIndicator();
  }
  List<double> buildScoreList(Class2ndScoreSummary scss) {
    return [scss.voluntary, scss.campus, scss.creation, scss.safetyEdu, scss.lecture, scss.practice];
  }

  final scoreValues = buildScoreList(summary);
  final totals = buildScoreList(targetScore);
  final scoreTitles = (const ['志愿', '校园文化', '三创', '安全文明', '讲座', '社会实践']).asMap().entries.map((e) {
    int index = e.key;
    String text = e.value;
    if (showTotal) {
      return '$text\n${scoreValues[index]}\n⎯⎯⎯\n${totals[index]}';
    } else {
      return '$text\n${scoreValues[index]}';
    }
  }).toList();

  List<BarChartGroupData> values = [];
  for (int i = 0; i < scoreValues.length; ++i) {
    if (totals[i] == 0) {
      continue;
    }
    values.add(BarChartGroupData(x: i, barRods: [
      BarChartRodData(
        toY: scoreValues[i] / totals[i],
        width: 12,
      )
    ]));
  }
  final titlesData = FlTitlesData(
    show: true,
    leftTitles: AxisTitles(),
    topTitles: AxisTitles(),
    rightTitles: AxisTitles(),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: showTotal ? 84 : 36,
        getTitlesWidget: (double value, TitleMeta meta) {
          const style = TextStyle(
            color: Color(0xff7589a2),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          );
          return Text(
            scoreTitles[value.toInt()],
            textAlign: TextAlign.center,
            style: style,
          );
        },
      ),
    ),
  );
  return BarChart(
    BarChartData(
      maxY: 1,
      barGroups: values,
      borderData: _borderData(),
      gridData: _gridData(),
      barTouchData: _barTouchData(),
      titlesData: titlesData,
    ),
  );
}

class Class2ndScoreSummeryCard extends StatelessWidget {
  final Class2ndScoreSummary targetScore;
  final Class2ndScoreSummary? summery;

  const Class2ndScoreSummeryCard({
    super.key,
    required this.targetScore,
    this.summery,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isPortrait) {
      return AspectRatio(
        aspectRatio: 1.8,
        child: Card(
          child: _buildChart(context, targetScore, summery).padSymmetric(v: 12),
        ),
      );
    } else {
      return [
        i18n.myScoreTitle.text(style: context.textTheme.headlineLarge).padFromLTRB(8, 24, 8, 0),
        _buildChart(context, targetScore, summery, showTotal: true)
            .padSymmetric(v: 12)
            .inCard(elevation: 8)
            .padSymmetric(v: 12.w, h: 8.h)
            .expanded()
      ].column(maa: MainAxisAlignment.spaceEvenly);
    }
  }
}
