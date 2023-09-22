import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/widgets/app.dart';
import 'package:mimir/school/entity/school.dart';
import 'package:mimir/school/event.dart';
import 'package:mimir/school/exam_result/init.dart';
import 'package:mimir/school/exam_result/widgets/item.dart';
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
  late final StreamSubscription<SchoolPageRefreshEvent> $refreshEvent;

  @override
  void initState() {
    super.initState();
    $refreshEvent = schoolEventBus.on<SchoolPageRefreshEvent>().listen((event) {
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
      // TODO: for debugging
      resultList = ExamResultInit.storage.getResultList((year: 2022, semester: Semester.all));
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
    return results.map((result) => ExamResultCard(result)).toList().column();
  }
}
