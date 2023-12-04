import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/widgets/app.dart';
import 'package:sit/school/event.dart';
import 'package:sit/school/exam_result/init.dart';
import 'package:sit/school/exam_result/widgets/pg.dart';
import 'package:sit/utils/async_event.dart';
import 'package:rettulf/rettulf.dart';

import 'entity/result.pg.dart';
import "i18n.dart";

const _recentLength = 2;

class ExamResultPgAppCard extends StatefulWidget {
  const ExamResultPgAppCard({super.key});

  @override
  State<ExamResultPgAppCard> createState() => _ExamResultPgAppCardState();
}

class _ExamResultPgAppCardState extends State<ExamResultPgAppCard> {
  List<ExamResultPg>? resultList;
  late final EventSubscription $refreshEvent;

  @override
  void initState() {
    super.initState();
    $refreshEvent = schoolEventBus.addListener(() async {
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
    setState(() {
      resultList = ExamResultInit.pgStorage.getResultList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultList = this.resultList;
    return AppCard(
      title: i18n.title.text(),
      view: resultList == null ? null : buildRecentResults(resultList),
      leftActions: [
        FilledButton.icon(
          onPressed: () async {
            await context.push("/exam-result/pg");
          },
          icon: const Icon(Icons.fact_check),
          label: i18n.check.text(),
        ),
      ],
    );
  }

  Widget? buildRecentResults(List<ExamResultPg> resultList) {
    if (resultList.isEmpty) return null;
    final results = resultList.sublist(0, min(_recentLength, resultList.length));
    return results
        .map((result) => ExamResultPgCard(
              result,
              elevated: true,
            ))
        .toList()
        .column();
  }
}
