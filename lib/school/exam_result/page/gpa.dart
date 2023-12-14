import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/animation/progress.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/design/widgets/grouped.dart';
import 'package:sit/design/widgets/multi_select.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/school/exam_result/entity/result.ug.dart';
import 'package:sit/school/exam_result/init.dart';
import 'package:sit/school/widgets/course.dart';
import 'package:sit/utils/error.dart';
import '../i18n.dart';
import '../utils.dart';
import '../widgets/ug.dart';

class GpaCalculatorPage extends StatefulWidget {
  const GpaCalculatorPage({super.key});

  @override
  State<GpaCalculatorPage> createState() => _GpaCalculatorPageState();
}

class _GpaCalculatorPageState extends State<GpaCalculatorPage> {
  late ({List<({SemesterInfo semester, List<ExamResultUg> results})> groups, List<ExamResultUg> list})? results = () {
    final resultList = ExamResultInit.ugStorage.getResultList(SemesterInfo.all);

    if (resultList == null) return null;
    return (groups: groupExamResultList(resultList), list: resultList);
  }();

  final $loadingProgress = ValueNotifier(0.0);
  bool isFetching = false;
  final controller = ScrollController();
  bool isSelecting = false;
  final multiselect = MultiselectController<ExamResultUg>();

  @override
  void initState() {
    super.initState();
    fetchAll();
  }

  @override
  void dispose() {
    multiselect.dispose();
    $loadingProgress.dispose();
    super.dispose();
  }

  Future<void> fetchAll() async {
    setState(() {
      isFetching = true;
    });
    try {
      final results = await ExamResultInit.ugService.fetchResultList(
        SemesterInfo.all,
        onProgress: (p) {
          $loadingProgress.value = p;
        },
      );
      ExamResultInit.ugStorage.setResultList(SemesterInfo.all, results);
      if (!mounted) return;
      setState(() {
        this.results = (groups: groupExamResultList(results), list: results);
        isFetching = false;
      });
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
      if (!mounted) return;
      setState(() {
        isFetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final results = this.results;
    return Scaffold(
      body: MultiselectScope<ExamResultUg>(
        controller: multiselect,
        dataSource: results?.list ?? const [],
        onSelectionChanged: (indexes, items) {
          setState(() {});
        },
        child: CustomScrollView(
          controller: controller,
          slivers: [
            SliverAppBar(
              pinned: true,
              title: "GPA".text(),
              actions: [
                PlatformTextButton(
                  onPressed: () {
                    setState(() {
                      isSelecting = !isSelecting;
                      if (isSelecting == false) {
                        multiselect.clearSelection();
                      }
                    });
                  },
                  child: Text(isSelecting ? i18n.done : i18n.select),
                )
              ],
            ),
            SliverList.list(children: [
              buildCourseCatChoices(),
            ]),
            if (results != null)
              if (results.groups.isEmpty)
                SliverFillRemaining(
                  child: LeavingBlank(
                    icon: Icons.inbox_outlined,
                    desc: i18n.noResultsTip,
                  ),
                ),
            if (results != null)
              ...results.groups.map((e) => ExamResultGroupBySemester(
                    semester: e.semester,
                    resultList: e.results,
                    isSelecting: isSelecting,
                  )),
          ],
        ),
      ),
      bottomNavigationBar: isFetching
          ? PreferredSize(
              preferredSize: const Size.fromHeight(4),
              child: $loadingProgress >> (ctx, value) => AnimatedProgressBar(value: value),
            )
          : null,
    );
  }

  Widget buildTitle() {
    final results = this.results;
    final style = context.textTheme.headlineSmall;
    final selectedExams = isSelecting ? multiselect.getSelectedItems().cast<ExamResultUg>() : results;
    if (selectedExams != null) {
      return "".text();
      // TODO: the right way to calculate GPA
      // It will skip failed exams.
      // final validResults = selectedExams.where((exam) => exam.score != null).where((result) => result.passed);
      // final gpa = calcGPA(validResults);
      // return "${i18n.lessonSelected(selectedExams.length)} ${i18n.gpaResult(gpa)}".text();
    } else {
      return i18n.title.text(style: style);
    }
  }

  Widget buildCourseCatChoices() {
    return ListView(
      scrollDirection: Axis.horizontal,
      physics: const RangeMaintainingScrollPhysics(),
      children: [
        ChoiceChip(
          label: "All".text(),
          onSelected: (value) {},
          selected: false,
        ).padH(4),
        ChoiceChip(
          label: "Except public".text(),
          onSelected: (value) {},
          selected: false,
        ).padH(4),
      ],
    ).sized(h: 40);
  }
}

class ExamResultGroupBySemester extends StatefulWidget {
  final SemesterInfo semester;
  final List<ExamResultUg> resultList;
  final bool isSelecting;

  const ExamResultGroupBySemester({
    super.key,
    required this.semester,
    required this.resultList,
    required this.isSelecting,
  });

  @override
  State<ExamResultGroupBySemester> createState() => _ExamResultGroupBySemesterState();
}

class _ExamResultGroupBySemesterState extends State<ExamResultGroupBySemester> {
  @override
  Widget build(BuildContext context) {
    final scope = MultiselectScope.controllerOf<ExamResultUg>(context);
    return GroupedSection(
        headerBuilder: (expanded, toggleExpand, defaultTrailing) {
          return ListTile(
            title: widget.semester.l10n().text(),
            titleTextStyle: context.textTheme.titleMedium,
            onTap: toggleExpand,
            trailing: defaultTrailing,
          );
        },
        itemCount: widget.resultList.length,
        itemBuilder: (ctx, i) {
          final result = widget.resultList[i];
          final selected = scope.isSelectedItem(result);
          return ExamResultUgTile(
            result,
            selected: selected,
            iconOverride: widget.isSelecting
                ? Icon(selected ? Icons.check_box_outlined : Icons.check_box_outline_blank)
                    .sizedAll(CourseIcon.kDefaultSize)
                : null,
            onTap: widget.isSelecting
                ? () {
                    final scope = MultiselectScope.controllerOf<ExamResultUg>(context);
                    scope.selectItem(result);
                  }
                : null,
          ).inFilledCard(clip: Clip.hardEdge);
        });
  }
}
