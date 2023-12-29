import 'package:carousel_slider/carousel_slider.dart';
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

class ExamResultPgAppCard extends StatefulWidget {
  const ExamResultPgAppCard({super.key});

  @override
  State<ExamResultPgAppCard> createState() => _ExamResultPgAppCardState();
}

class _ExamResultPgAppCardState extends State<ExamResultPgAppCard> {
  List<ExamResultPg>? resultList;
  late final EventSubscription $refreshEvent;
  final $resultList = ExamResultInit.pgStorage.listenResultList();
  @override
  void initState() {
    super.initState();
    $refreshEvent = schoolEventBus.addListener(() async {
      refresh();
    });
    $resultList.addListener(refresh);
    refresh();
  }

  @override
  void dispose() {
    $refreshEvent.cancel();
    $resultList.removeListener(refresh);
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

  Widget? buildRecentResults(List<ExamResultPg> results) {
    if (results.isEmpty) return null;
    return CarouselSlider.builder(
      itemCount: results.length,
      options: CarouselOptions(
        height: 120,
        viewportFraction: 0.45,
        enableInfiniteScroll: false,
        padEnds: false,
        autoPlay: true,
        autoPlayInterval: const Duration(milliseconds: 2500),
        autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
      ),
      itemBuilder: (BuildContext context, int i, int pageViewIndex) {
        final result = results[i];
        return ExamResultPgCarouselCard(
          result,
          elevated: true,
        ).sized(w: 180);
      },
    );
  }
}
