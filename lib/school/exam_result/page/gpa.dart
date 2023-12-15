import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/animation/progress.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/design/widgets/grouped.dart';
import 'package:sit/design/widgets/multi_select.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/school/exam_result/entity/gpa.dart';
import 'package:sit/school/exam_result/entity/result.ug.dart';
import 'package:sit/school/exam_result/init.dart';
import 'package:sit/school/widgets/course.dart';
import 'package:sit/utils/error.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/school/exam_result/page/details.ug.dart';

import '../i18n.dart';
import '../utils.dart';

class GpaCalculatorPage extends StatefulWidget {
  const GpaCalculatorPage({super.key});

  @override
  State<GpaCalculatorPage> createState() => _GpaCalculatorPageState();
}

typedef _GpaGroups = ({
  List<({SemesterInfo semester, List<ExamResultGpaItem> items})> groups,
  List<ExamResultGpaItem> list
});

class _GpaCalculatorPageState extends State<GpaCalculatorPage> {
  late _GpaGroups? gpaItems = buildGpaItems(ExamResultInit.ugStorage.getResultList(SemesterInfo.all));

  final $loadingProgress = ValueNotifier(0.0);
  bool isFetching = false;
  final $selected = ValueNotifier(const <ExamResultGpaItem>[]);
  bool isSelecting = false;
  final multiselect = MultiselectController<ExamResultGpaItem>();

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

  _GpaGroups? buildGpaItems(List<ExamResultUg>? resultList) {
    if (resultList == null) return null;
    final gpaItems = extractExamResultGpaItems(resultList);
    final groups = groupExamResultGpaItems(gpaItems);
    return (groups: groups, list: gpaItems);
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
        gpaItems = buildGpaItems(results);
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
    final gpaItems = this.gpaItems;
    return Scaffold(
      body: MultiselectScope<ExamResultGpaItem>(
        controller: multiselect,
        dataSource: gpaItems?.list ?? const [],
        onSelectionChanged: (indexes, items) {
          $selected.value = items;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: $selected >> (ctx, selected) => buildTitle(selected),
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
              $selected >> (ctx, selected) => buildCourseCatChoices(selected),
            ]),
            if (gpaItems != null)
              if (gpaItems.groups.isEmpty)
                SliverFillRemaining(
                  child: LeavingBlank(
                    icon: Icons.inbox_outlined,
                    desc: i18n.noResultsTip,
                  ),
                ),
            if (gpaItems != null)
              ...gpaItems.groups.map((e) => ExamResultGroupBySemester(
                    semester: e.semester,
                    items: e.items,
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

  Widget buildTitle(List<ExamResultGpaItem> selected) {
    final gpaItems = this.gpaItems;
    final style = context.textTheme.headlineSmall;
    final selectedExams = isSelecting ? multiselect.getSelectedItems().cast<ExamResultUg>() : gpaItems;
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

  Widget buildCourseCatChoices(List<ExamResultGpaItem> selected) {
    final gpaItems = this.gpaItems;
    return ListView(
      scrollDirection: Axis.horizontal,
      physics: const RangeMaintainingScrollPhysics(),
      children: [
        ChoiceChip(
          label: "All".text(),
          onSelected: !isSelecting
              ? null
              : (value) {
                  if (gpaItems == null) return;
                  multiselect.setSelectedItems(gpaItems.list);
                },
          selected: !isSelecting ? false : multiselect.isSelectedAll(),
        ).padH(4),
        ChoiceChip(
          label: "Except genEd".text(),
          onSelected: !isSelecting
              ? null
              : (value) {
                  if (gpaItems == null) return;
                  multiselect
                      .setSelectedItems(gpaItems.list.where((result) => result.courseCat != CourseCat.genEd).toList());
                },
          selected: !isSelecting
              ? false
              : gpaItems == null
                  ? false
                  : multiselect.getSelectedItems().every((result) => result.courseCat != CourseCat.genEd),
        ).padH(4),
      ],
    ).sized(h: 40);
  }
}

class ExamResultGroupBySemester extends StatefulWidget {
  final SemesterInfo semester;
  final List<ExamResultGpaItem> items;
  final bool isSelecting;

  const ExamResultGroupBySemester({
    super.key,
    required this.semester,
    required this.items,
    required this.isSelecting,
  });

  @override
  State<ExamResultGroupBySemester> createState() => _ExamResultGroupBySemesterState();
}

class _ExamResultGroupBySemesterState extends State<ExamResultGroupBySemester> {
  @override
  Widget build(BuildContext context) {
    final scope = MultiselectScope.controllerOf<ExamResultGpaItem>(context);
    return GroupedSection(
        headerBuilder: (expanded, toggleExpand, defaultTrailing) {
          return ListTile(
            title: widget.semester.l10n().text(),
            titleTextStyle: context.textTheme.titleMedium,
            onTap: toggleExpand,
            trailing: defaultTrailing,
          );
        },
        itemCount: widget.items.length,
        itemBuilder: (ctx, i) {
          final item = widget.items[i];
          final selected = scope.isSelectedIndex(item.index);
          return ExamResultGpaTile(
            item,
            selected: selected,
            iconOverride: widget.isSelecting
                ? Icon(selected ? Icons.check_box_outlined : Icons.check_box_outline_blank)
                    .sizedAll(CourseIcon.kDefaultSize)
                : null,
            onTap: widget.isSelecting
                ? () {
                    scope.select(item.index);
                  }
                : null,
          ).inFilledCard(clip: Clip.hardEdge);
        });
  }
}

class ExamResultGpaTile extends StatelessWidget {
  final ExamResultGpaItem item;
  final VoidCallback? onTap;
  final Widget? iconOverride;
  final bool selected;

  const ExamResultGpaTile(
    this.item, {
    super.key,
    this.onTap,
    this.iconOverride,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final result = item.initial;
    assert(item.maxScore != null);
    final score = item.maxScore ?? 0.0;
    return ListTile(
      isThreeLine: true,
      selected: selected,
      leading: iconOverride ?? CourseIcon(courseName: result.courseName),
      titleTextStyle: textTheme.titleMedium,
      title: Text(result.courseName),
      subtitleTextStyle: textTheme.bodyMedium,
      subtitle: [
        '${result.courseCat}'.text(),
        if (result.teachers.isNotEmpty) result.teachers.join(", ").text(),
      ].column(caa: CrossAxisAlignment.start, mas: MainAxisSize.min),
      leadingAndTrailingTextStyle: textTheme.labelSmall?.copyWith(
        fontSize: textTheme.bodyLarge?.fontSize,
        color: result.passed ? null : context.$red$,
      ),
      trailing: score.toString().text(),
      onTap: onTap,
    );
  }
}
