import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/widgets/app.dart';
import 'package:sit/school/event.dart';
import 'package:sit/school/exam_result/init.dart';
import 'package:sit/school/exam_result/widgets/pg.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/utils/async_event.dart';
import 'package:rettulf/rettulf.dart';

import 'entity/result.pg.dart';
import "i18n.dart";

class ExamResultPgAppCard extends StatefulWidget {
  const ExamResultPgAppCard({super.key});

  @override
  State<ExamResultPgAppCard> createState() => _ExamResultPgAppCardState();
}

class _ExamResultPgAppCardState extends State<ExamResultPgAppCard> {
  List<ExamResultPg>? resultList;
  late final EventSubscription $refreshEvent;
  final $resultList = ExamResultInit.pgStorage.listenResultList();
  final $showResultPreview = Settings.school.examResult.listenShowResultPreview();
  bool showResultPreview = Settings.school.examResult.showResultPreview;

  @override
  void initState() {
    super.initState();
    $refreshEvent = schoolEventBus.addListener(() async {
      refresh();
    });
    $resultList.addListener(refresh);
    $showResultPreview.addListener(refreshShowResultPreview);
    refresh();
  }

  @override
  void dispose() {
    $refreshEvent.cancel();
    $resultList.removeListener(refresh);
    $showResultPreview.removeListener(refreshShowResultPreview);
    super.dispose();
  }

  void refresh() {
    setState(() {
      resultList = ExamResultInit.pgStorage.getResultList();
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
            await context.push("/exam-result/pg");
          },
          icon: const Icon(Icons.fact_check),
          label: i18n.check.text(),
        ),
      ],
    );
  }

  Widget? buildRecentResults() {
    if (!showResultPreview) return null;
    final resultList = this.resultList;
    if (resultList == null || resultList.isEmpty) return null;
    return CarouselSlider.builder(
      itemCount: resultList.length,
      options: CarouselOptions(
        height: 120,
        viewportFraction: 0.45,
        enableInfiniteScroll: false,
        padEnds: false,
      ),
      itemBuilder: (BuildContext context, int i, int pageViewIndex) {
        final result = resultList[i];
        return ExamResultPgCarouselCard(
          result,
          elevated: true,
        ).sized(w: 180);
      },
    );
  }
}
