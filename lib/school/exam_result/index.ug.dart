import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/widgets/app.dart';
import 'package:sit/school/event.dart';
import 'package:sit/school/exam_result/init.dart';
import 'package:sit/school/exam_result/widgets/ug.dart';
import 'package:sit/school/utils.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/utils/async_event.dart';
import 'package:rettulf/rettulf.dart';

import 'entity/result.ug.dart';
import "i18n.dart";

const _recentLength = 2;

class ExamResultUgAppCard extends StatefulWidget {
  const ExamResultUgAppCard({super.key});

  @override
  State<ExamResultUgAppCard> createState() => _ExamResultUgAppCardState();
}

class _ExamResultUgAppCardState extends State<ExamResultUgAppCard> {
  List<ExamResultUg>? resultList;
  late final EventSubscription $refreshEvent;
  late final StreamSubscription $resultList;
  late final currentSemester = estimateCurrentSemester();
  final $showResultPreview = Settings.school.examResult.listenShowResultPreview();
  bool showResultPreview = Settings.school.examResult.showResultPreview;

  @override
  void initState() {
    super.initState();
    $refreshEvent = schoolEventBus.addListener(() async {
      refresh();
    });
    $resultList = ExamResultInit.ugStorage.watchResultList(() => currentSemester).listen((event) {
      refresh();
    });
    $showResultPreview.addListener(refreshShowResultPreview);
    refresh();
  }

  @override
  void dispose() {
    $refreshEvent.cancel();
    $resultList.cancel();
    $showResultPreview.removeListener(refreshShowResultPreview);
    super.dispose();
  }

  void refresh() {
    setState(() {
      resultList = ExamResultInit.ugStorage.getResultList(currentSemester);
    });
  }

  void refreshShowResultPreview() {
    setState(() {
      showResultPreview = Settings.school.examResult.showResultPreview;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: i18n.title.text(),
      view: buildRecentResults(),
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
            await context.push("/exam-result/ug/gpa");
          },
          icon: const Icon(Icons.assessment),
          label: i18n.gpa.title.text(),
        )
      ],
    );
  }

  Widget? buildRecentResults() {
    if (!showResultPreview) return null;
    final resultList = this.resultList;
    if (resultList == null || resultList.isEmpty) return null;
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
