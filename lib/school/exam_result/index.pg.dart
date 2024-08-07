import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/widgets/app.dart';
import 'package:sit/school/exam_result/init.dart';
import 'package:sit/school/exam_result/widgets/pg.dart';
import 'package:sit/settings/settings.dart';
import 'package:rettulf/rettulf.dart';

import 'entity/result.pg.dart';
import "i18n.dart";

class ExamResultPgAppCard extends ConsumerStatefulWidget {
  const ExamResultPgAppCard({super.key});

  @override
  ConsumerState<ExamResultPgAppCard> createState() => _ExamResultPgAppCardState();
}

class _ExamResultPgAppCardState extends ConsumerState<ExamResultPgAppCard> {
  @override
  Widget build(BuildContext context) {
    final storage = ExamResultInit.pgStorage;
    final showResultPreview = ref.watch(Settings.school.examResult.$showResultPreview);
    final resultList = ref.watch(storage.$resultList);
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
