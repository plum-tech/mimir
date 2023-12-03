import 'package:flutter/material.dart';
import 'package:sit/credentials/widgets/oa_scope.dart';
import 'package:sit/design/animation/progress.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/design/widgets/fab.dart';
import 'package:sit/design/widgets/multi_select.dart';
import 'package:sit/school/utils.dart';
import 'package:sit/school/widgets/selector.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/settings/settings.dart';

import '../entity/result.ug.dart';
import '../init.dart';
import '../widgets/ug.dart';
import '../utils.dart';
import '../i18n.dart';

class ExamResultUgPage extends StatefulWidget {
  const ExamResultUgPage({super.key});

  @override
  State<ExamResultUgPage> createState() => _ExamResultUgPageState();
}

class _ExamResultUgPageState extends State<ExamResultUgPage> {
  List<ExamResultUg>? resultList;
  bool isFetching = false;
  final controller = ScrollController();
  bool isSelecting = false;
  final $loadingProgress = ValueNotifier(0.0);
  final multiselect = MultiselectController();
  late SemesterInfo initial = () {
    final now = DateTime.now();
    return Settings.school.examResult.lastSemesterInfo ??
        (
          year: now.month >= 9 ? now.year : now.year - 1,
          semester: Semester.all,
        );
  }();
  late SemesterInfo selected = initial;

  @override
  void initState() {
    super.initState();
    refresh(initial);
  }

  @override
  void dispose() {
    multiselect.dispose();
    super.dispose();
  }

  Future<void> refresh(SemesterInfo info) async {
    if (!mounted) return;
    setState(() {
      resultList = ExamResultInit.ugStorage.getResultList(info);
      isFetching = true;
    });
    try {
      final resultList = await ExamResultInit.ugService.fetchResultList(info, onProgress: (p) {
        $loadingProgress.value = p;
      });
      await ExamResultInit.ugStorage.setResultList(info, resultList);
      // Prevents the former query replace new query.
      if (info == selected) {
        if (!mounted) return;
        setState(() {
          this.resultList = resultList;
          isFetching = false;
        });
      }
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      setState(() {
        isFetching = false;
      });
    } finally {
      $loadingProgress.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final resultList = this.resultList;
    return Scaffold(
      body: MultiselectScope<ExamResultUg>(
        controller: multiselect,
        dataSource: resultList ?? const [],
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
        child: CustomScrollView(
          controller: controller,
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                title: buildTitle(),
                centerTitle: true,
                background: buildSemesterSelector(),
              ),
              bottom: isFetching
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(4),
                      child: $loadingProgress >> (ctx, value) => AnimatedProgressBar(value: value),
                    )
                  : null,
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
                  itemBuilder: (item, i) => ExamResultUgSelectableCard(
                    resultList[i],
                    index: i,
                    isSelectingMode: isSelecting,
                  ),
                ),
          ],
        ),
      ),
      floatingActionButton: AutoHideFAB.extended(
        controller: controller,
        alwaysShow: isSelecting,
        onPressed: () {
          setState(() {
            isSelecting = !isSelecting;
            if (isSelecting == false) {
              multiselect.clearSelection();
            }
          });
        },
        label: Text(isSelecting ? i18n.unselect : i18n.select),
        icon: Icon(isSelecting ? Icons.check_box_outlined : Icons.check_box_outline_blank),
      ),
    );
  }

  Widget buildSemesterSelector() {
    return SemesterSelector(
      showEntireYear: true,
      initial: initial,
      baseYear: getAdmissionYearFromStudentId(context.auth.credentials?.account),
      onSelected: (newSelection) {
        setState(() {
          selected = newSelection;
        });
        Settings.school.examResult.lastSemesterInfo = newSelection;
        refresh(newSelection);
      },
    );
  }

  Widget buildTitle() {
    final resultList = this.resultList;
    final style = context.textTheme.headlineSmall;
    final selectedExams = isSelecting ? multiselect.getSelectedItems().cast<ExamResultUg>() : resultList;
    if (selectedExams != null) {
      final gpa = calcGPA(selectedExams.where((exam) => exam.hasScore));
      if (isSelecting) {
        return [
          i18n.lessonSelected(selectedExams.length).text(textAlign: TextAlign.center, style: style).expanded(),
          i18n.gpaResult(gpa).text(textAlign: TextAlign.center, style: style).expanded(),
        ].row();
      } else {
        return [
          selected.semester.localized().text(textAlign: TextAlign.center, style: style).expanded(),
          i18n.gpaResult(gpa).text(textAlign: TextAlign.center, style: style).expanded(),
        ].row();
      }
    } else {
      return i18n.title.text(style: style);
    }
  }
}
