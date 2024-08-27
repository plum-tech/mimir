import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/design/animation/progress.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:mimir/design/widgets/fab.dart';
import 'package:mimir/school/utils.dart';
import 'package:mimir/school/widgets/semester.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/school/entity/school.dart';
import 'package:mimir/utils/error.dart';

import '../entity/result.ug.dart';
import '../init.dart';
import '../widgets/ug.dart';
import '../i18n.dart';
import '../x.dart';

class ExamResultUgPage extends ConsumerStatefulWidget {
  const ExamResultUgPage({super.key});

  @override
  ConsumerState<ExamResultUgPage> createState() => _ExamResultUgPageState();
}

class _ExamResultUgPageState extends ConsumerState<ExamResultUgPage> {
  static SemesterInfo? _lastSemesterInfo;
  late SemesterInfo initial = _lastSemesterInfo ?? estimateSemesterInfo();
  late List<ExamResultUg>? resultList = ExamResultInit.ugStorage.getResultList(initial);
  bool isFetching = false;
  final $loadingProgress = ValueNotifier(0.0);
  late SemesterInfo selected = initial;
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  void dispose() {
    $loadingProgress.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> fetch() async {
    if (!mounted) return;
    setState(() {
      isFetching = true;
    });
    try {
      final (:semester2Results, all: _) = await XExamResult.fetchAndCacheExamResultUgEachSemester(
        onProgress: (p) {
          if (!mounted) return;
          $loadingProgress.value = p;
        },
      );
      if (!mounted) return;
      setState(() {
        resultList = semester2Results[selected];
        isFetching = false;
      });
      $loadingProgress.value = 0;
    } catch (error, stackTrace) {
      handleRequestError(error, stackTrace);
      if (!mounted) return;
      setState(() {
        isFetching = false;
      });
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
    final resultList = this.resultList?.sorted(ExamResultUg.compareByTime).reversed.toList();
    return Scaffold(
      floatingActionButton: AutoHideFAB.extended(
        controller: controller,
        label: i18n.gpa.title.text(),
        icon: const Icon(Icons.assessment),
        onPressed: () async {
          await context.push("/exam-result/ug/gpa");
        },
      ),
      body: CustomScrollView(
        controller: controller,
        slivers: [
          SliverAppBar.medium(
            title: i18n.title.text(),
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
    final credentials = ref.watch(CredentialsInit.storage.$oaCredentials);
    return SemesterSelector(
      initial: initial,
      baseYear: getAdmissionYearFromStudentId(credentials?.account),
      onSelected: (newSelection) {
        _lastSemesterInfo = newSelection;
        setState(() {
          selected = newSelection;
          resultList = ExamResultInit.ugStorage.getResultList(newSelection);
        });
      },
    );
  }
}
