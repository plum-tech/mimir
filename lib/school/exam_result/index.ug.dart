import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/widgets/app.dart';
import 'package:sit/school/exam_result/init.dart';
import 'package:sit/school/exam_result/widgets/ug.dart';
import 'package:sit/school/utils.dart';
import 'package:sit/settings/settings.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/utils/guard_launch.dart';
import 'package:universal_platform/universal_platform.dart';

import 'entity/result.ug.dart';
import "i18n.dart";
import 'page/evaluation.dart';

const _recentLength = 2;

class ExamResultUgAppCard extends ConsumerStatefulWidget {
  const ExamResultUgAppCard({super.key});

  @override
  ConsumerState<ExamResultUgAppCard> createState() => _ExamResultUgAppCardState();
}

class _ExamResultUgAppCardState extends ConsumerState<ExamResultUgAppCard> {
  @override
  Widget build(BuildContext context) {
    final storage = ExamResultInit.ugStorage;
    final currentSemester = estimateSemesterInfo();
    final resultList = ref.watch(storage.$resultListFamily(currentSemester));
    final showResultPreview = ref.watch(Settings.school.examResult.$showResultPreview);
    return AppCard(
      title: i18n.title.text(),
      view: showResultPreview == false
          ? null
          : resultList == null
              ? null
              : buildRecentResults(resultList),
      leftActions: [
        FilledButton.icon(
          onPressed: () async {
            await context.push("/exam-result/ug");
          },
          icon: const Icon(Icons.fact_check),
          label: i18n.check.text(),
        ),
        OutlinedButton.icon(
          onPressed: () async {
            if (UniversalPlatform.isDesktop) {
              await guardLaunchUrl(context, teacherEvaluationUri);
            } else {
              await context.push("/teacher-eval");
            }
          },
          label: i18n.teacherEval.text(),
        )
      ],
    );
  }

  Widget? buildRecentResults(List<ExamResultUg> resultList) {
    if (resultList.isEmpty) return null;
    resultList.sort((a, b) => -ExamResultUg.compareByTime(a, b));
    final results = resultList.sublist(0, min(_recentLength, resultList.length));
    return results
        .map((result) => ExamResultUgTile(
              result,
            ).inCard(clip: Clip.hardEdge))
        .toList()
        .column();
  }
}
