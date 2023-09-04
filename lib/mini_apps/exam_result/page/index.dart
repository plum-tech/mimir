import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/util/guard_launch.dart';
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

import '../entity/result.dart';
import '../events.dart';
import '../init.dart';
import '../widgets/item.dart';
import '../using.dart';
import '../util.dart';
import 'evaluation.dart';

class ExamResultPage extends StatefulWidget {
  const ExamResultPage({super.key});

  @override
  State<ExamResultPage> createState() => _ExamResultPageState();
}

class _ExamResultPageState extends State<ExamResultPage> {
  /// 四位年份
  late int selectedYear;

  /// 要查询的学期
  late Semester selectedSemester;

  /// 成绩列表
  List<ExamResult>? _allResults;

  // ValueNotifier is used to limit rebuilding when `Lesson Eval` is going up or going down.
  final $showEvaluationBtn = ValueNotifier(true);
  bool isSelecting = false;
  var multiselect = MultiselectController();
  final _multiselectKey = GlobalKey(debugLabel: "Multiselect");

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedYear = (now.month >= 9 ? now.year : now.year - 1);
    selectedSemester = Semester.all;
    onRefresh();
  }

  void onRefresh() {
    if (!mounted) return;
    setState(() {
      _allResults = null;
    });
    ExamResultInit.resultService.getResultList(SchoolYear(selectedYear), selectedSemester).then((value) {
      if (!mounted) return;
      setState(() {
        _allResults = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final allResults = _allResults;
    final selectedExams = isSelecting ? multiselect.getSelectedItems().cast<ExamResult>() : allResults;
    final Widget title;
    if (selectedExams != null) {
      final gpa = calcGPA(selectedExams);
      if (isSelecting) {
        title = [
          i18n.lessonSelected(selectedExams.length).text(textAlign: TextAlign.center).expanded(),
          i18n.gpaResult(gpa).text(textAlign: TextAlign.center).expanded(),
        ].row();
      } else {
        title = [
          selectedSemester.localized().text(textAlign: TextAlign.center).expanded(),
          i18n.gpaResult(gpa).text(textAlign: TextAlign.center).expanded(),
        ].row();
      }
    } else {
      title = MiniApp.examResult.l10nName().text();
    }

    return Scaffold(
      appBar: AppBar(
        title: title,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSelecting = !isSelecting;
                  if (isSelecting) {
                    $showEvaluationBtn.value = false;
                  } else {
                    $showEvaluationBtn.value = true;
                    multiselect.clearSelection();
                  }
                });
              },
              icon: Icon(isSelecting ? Icons.check_box_outlined : Icons.check_box_outline_blank)),
        ],
      ),
      body: [
        _buildHeader(),
        allResults == null
            ? const LoadingPlaceholder.drop().expanded()
            : NotificationListener<UserScrollNotification>(
                // TODO: How can I extract this to a more general component?
                onNotification: (notification) {
                  final ScrollDirection direction = notification.direction;
                  if (isSelecting) return true;
                  if (direction == ScrollDirection.reverse) {
                    $showEvaluationBtn.value = false;
                  } else if (direction == ScrollDirection.forward) {
                    $showEvaluationBtn.value = true;
                  }
                  return true;
                },
                child: Expanded(child: allResults.isNotEmpty ? _buildExamResultList(allResults) : _buildNoResult())),
      ].column(),
      floatingActionButton: context.auth.credential == null ? null : buildEvaluationBtn(context),
    );
  }

  Widget buildEvaluationBtn(BuildContext ctx) {
    // If the user is currently offline, don't let them see the evaluation button.
    return $showEvaluationBtn >>
        (ctx, showBtn) {
          return AnimatedSlideDown(
              upWhen: showBtn,
              child: FloatingActionButton.extended(
                icon: const Icon(Icons.assessment_outlined),
                onPressed: () async {
                  if (UniversalPlatform.isDesktop) {
                    await guardLaunchUrl(ctx, evaluationUri);
                    return;
                  }
                  await context.push("/teacherEval");
                  if (!mounted) return;
                  eventBus.fire(LessonEvaluatedEvent());
                  await Future.delayed(const Duration(milliseconds: 1000));
                  onRefresh();
                },
                label: i18n.lessonEvaluationBtn.text(),
              ));
        };
  }

  Widget _buildHeader() {
    return [
      Container(
        margin: const EdgeInsets.only(left: 15),
        child: SemesterSelector(
          onNewYearSelect: (year) {
            setState(() => selectedYear = year);
            onRefresh();
          },
          onNewSemesterSelect: (semester) {
            setState(() => selectedSemester = semester);
            onRefresh();
          },
          initialYear: selectedYear,
          initialSemester: selectedSemester,
        ),
      ),
    ].column();
  }

  Widget _buildExamResultList(List<ExamResult> all) {
    return MultiselectScope<ExamResult>(
      key: _multiselectKey,
      controller: multiselect,
      dataSource: all,
      // Set this to true if you want automatically
      // clear selection when user tap back button
      clearSelectionOnPop: true,
      // When you update [dataSource] then selected indexes will update
      // so that the same elements in new [dataSource] are selected
      keepSelectedItemsBetweenUpdates: true,
      initialSelectedIndexes: null,
      // Callback that call on selection changing
      onSelectionChanged: (indexes, items) {
        setState(() {});
      },
      child: GridView.builder(
        itemCount: all.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 750,
          mainAxisExtent: 60,
        ),
        itemBuilder: (ctx, index) => ScoreItem(all[index], index: index, isSelectingMode: isSelecting),
      ),
    );
  }

  Widget _buildNoResult() {
    return LeavingBlank(
      icon: Icons.inbox_outlined,
      desc: i18n.noResult,
    );
  }

  @override
  void dispose() {
    super.dispose();
    multiselect.dispose();
  }
}
