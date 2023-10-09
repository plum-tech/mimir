import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/widgets/app.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/school/event.dart';
import 'package:sit/school/exam_result/init.dart';
import 'package:sit/school/exam_result/widgets/item.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/utils/async_event.dart';
import 'package:rettulf/rettulf.dart';

import 'entity/result.dart';
import "i18n.dart";

const _recentLength = 2;

class ExamResultAppCard extends StatefulWidget {
  const ExamResultAppCard({super.key});

  @override
  State<ExamResultAppCard> createState() => _ExamResultAppCardState();
}

class _ExamResultAppCardState extends State<ExamResultAppCard> {
  List<ExamResult>? resultList;
  late final EventSubscription $refreshEvent;

  @override
  void initState() {
    super.initState();
    $refreshEvent = schoolEventBus.addListener(() {
      refresh();
    });
    refresh();
  }

  @override
  void dispose() {
    $refreshEvent.cancel();
    super.dispose();
  }

  void refresh() {
    final now = DateTime.now();
    final current = (
      year: now.month >= 9 ? now.year : now.year - 1,
      semester: now.month >= 3 && now.month <= 7 ? Semester.term2 : Semester.term1,
    );
    setState(() {
      resultList = ExamResultInit.storage.getResultList(current);
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultList = this.resultList;
    return AppCard(
      title: i18n.title.text(),
      view: resultList != null ? buildRecentResults(resultList) : const SizedBox(),
      leftActions: [
        FilledButton.icon(
          onPressed: () {
            context.push("/exam-result");
          },
          icon: const Icon(Icons.fact_check),
          label: i18n.check.text(),
        ),
        OutlinedButton(
          onPressed: () {
            context.push("/teacher-eval");
          },
          child: i18n.teacherEval.text(),
        )
      ],
    );
  }

  Widget buildRecentResults(List<ExamResult> resultList) {
    if (resultList.isEmpty) return const SizedBox();
    resultList.sort((a, b) => -ExamResult.compareByTime(a, b));
    final results = resultList.sublist(0, min(_recentLength, resultList.length));
    return Settings.school.examResult.listenAppCardShowResultDetails() >>
        (ctx, _) {
          final showDetails = Settings.school.examResult.appCardShowResultDetails;
          return results
              .map((result) => ExamResultCard(
                    result,
                    showDetails: showDetails,
                  ))
              .toList()
              .column();
        };
  }
}
