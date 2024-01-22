import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/credentials/widgets/oa_scope.dart';
import 'package:sit/design/animation/progress.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/school/exam_result/aggregated.dart';
import 'package:sit/school/utils.dart';
import 'package:sit/school/widgets/semester.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/utils/error.dart';
import 'package:sit/utils/guard_launch.dart';
import 'package:universal_platform/universal_platform.dart';

import '../entity/result.ug.dart';
import '../init.dart';
import '../widgets/ug.dart';
import '../i18n.dart';
import 'evaluation.dart';

class ExamResultUgPage extends StatefulWidget {
  const ExamResultUgPage({super.key});

  @override
  State<ExamResultUgPage> createState() => _ExamResultUgPageState();
}

class _ExamResultUgPageState extends State<ExamResultUgPage> {
  late SemesterInfo initial = ExamResultInit.ugStorage.lastSemesterInfo ?? estimateCurrentSemester();
  late List<ExamResultUg>? resultList = ExamResultInit.ugStorage.getResultList(initial);
  bool isFetching = false;
  final $loadingProgress = ValueNotifier(0.0);
  late SemesterInfo selected = initial;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  void dispose() {
    $loadingProgress.dispose();
    super.dispose();
  }

  Future<void> fetch() async {
    if (!mounted) return;
    setState(() {
      isFetching = true;
    });
    try {
      final (:semester2Results, all: _) = await ExamResultAggregated.fetchAndCacheExamResultUgEachSemester(
        onProgress: (p) {
          if (!mounted) return;
          $loadingProgress.value = p;
        },
      );
      setState(() {
        resultList = semester2Results[selected];
        isFetching = false;
      });
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
      if (!mounted) return;
      setState(() {
        isFetching = false;
      });
    } finally {
      $loadingProgress.value = 0;
    }
  }

  Future<void> onChangeSemester(SemesterInfo info) async {
    if (!mounted) return;
    setState(() {
      resultList = ExamResultInit.ugStorage.getResultList(info);
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultList = this.resultList;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: i18n.title.text(),
            actions: [
              PlatformTextButton(
                child: i18n.teacherEval.text(),
                onPressed: () async {
                  if (UniversalPlatform.isDesktop) {
                    await guardLaunchUrl(context, teacherEvaluationUri);
                  } else {
                    await context.push("/teacher-eval");
                  }
                },
              )
            ],
          ),
          SliverToBoxAdapter(
            child: buildSemesterSelector(),
          ),
          if (resultList != null)
            if (resultList.isEmpty)
              SliverFillRemaining(
                child: LeavingBlank(
                  icon: Icons.inbox_outlined,
                  desc: i18n.noResultsTip,
                ),
              )
            else
              SliverList.builder(
                itemCount: resultList.length,
                itemBuilder: (item, i) => ExamResultUgTile(
                  resultList[i],
                ).inFilledCard(clip: Clip.hardEdge),
              ),
        ],
      ),
      bottomNavigationBar: isFetching
          ? PreferredSize(
              preferredSize: const Size.fromHeight(4),
              child: $loadingProgress >> (ctx, value) => AnimatedProgressBar(value: value),
            )
          : null,
    );
  }

  Widget buildSemesterSelector() {
    return SemesterSelector(
      initial: initial,
      baseYear: getAdmissionYearFromStudentId(context.auth.credentials?.account),
      onSelected: (newSelection) {
        ExamResultInit.ugStorage.lastSemesterInfo = newSelection;
        setState(() {
          selected = newSelection;
          resultList = ExamResultInit.ugStorage.getResultList(newSelection);
        });
      },
    );
  }
}
