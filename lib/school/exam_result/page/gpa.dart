import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/animation/progress.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/design/widgets/grouped.dart';
import 'package:sit/design/widgets/multi_select.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/school/exam_result/entity/gpa.dart';
import 'package:sit/school/exam_result/entity/result.ug.dart';
import 'package:sit/school/exam_result/init.dart';
import 'package:sit/school/exam_result/page/details.gpa.dart';
import 'package:sit/utils/error.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:text_scroll/text_scroll.dart';

import '../aggregated.dart';
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
      final (semester2Results: _, :all) = await ExamResultAggregated.fetchAndCacheExamResultUgEachSemester(
        onProgress: (p) {
          if (!mounted) return;
          $loadingProgress.value = p;
        },
      );
      if (!mounted) return;
      setState(() {
        gpaItems = buildGpaItems(all);
        isFetching = false;
      });
    } catch (error, stackTrace) {
      handleRequestError(context, error, stackTrace);
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
              title: buildTitle(),
              actions: [
                PlatformTextButton(
                  onPressed: () {
                    multiselect.clearSelection();
                  },
                  child: Text(i18n.done),
                )
              ],
              bottom: isFetching
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(4),
                      child: $loadingProgress >> (ctx, value) => AnimatedProgressBar(value: value),
                    )
                  : null,
            ),
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
                  )),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        child: buildCourseCatChoices().sized(h: 40),
      ),
    );
  }

  Widget buildTitle() {
    return $selected >>
        (ctx, selected) => selected.isEmpty
            ? i18n.gpa.title.text()
            : TextScroll(_buildGpaText(
                items: selected,
                showSelectedCount: false,
              ));
  }

  Widget buildCourseCatChoices() {
    return $selected >>
        (ctx, selected) {
          return ListView(
            scrollDirection: Axis.horizontal,
            physics: const RangeMaintainingScrollPhysics(),
            children: [
              ActionChip(
                label: i18n.gpa.selectAll.text(),
                onPressed: selected.length != gpaItems?.list.length
                    ? () {
                        multiselect.selectAll();
                      }
                    : null,
              ).padH(4),
              ActionChip(
                label: i18n.gpa.invert.text(),
                onPressed: () {
                  multiselect.invertSelection();
                },
              ).padH(4),
              ActionChip(
                label: i18n.gpa.exceptGenEd.text(),
                onPressed: selected.any((item) => item.courseCat == CourseCat.genEd)
                    ? () {
                        multiselect.setSelectedIndexes(selected
                            .where((item) => item.courseCat != CourseCat.genEd)
                            .map((item) => item.index)
                            .toList());
                      }
                    : null,
              ).padH(4),
              ActionChip(
                label: i18n.gpa.exceptFailed.text(),
                onPressed: selected.any((item) => !item.passed)
                    ? () {
                        multiselect.setSelectedIndexes(
                            selected.where((item) => item.passed).map((item) => item.index).toList());
                      }
                    : null,
              ).padH(4),
            ],
          );
        };
  }
}

class ExamResultGroupBySemester extends StatefulWidget {
  final SemesterInfo semester;
  final List<ExamResultGpaItem> items;

  const ExamResultGroupBySemester({
    super.key,
    required this.semester,
    required this.items,
  });

  @override
  State<ExamResultGroupBySemester> createState() => _ExamResultGroupBySemesterState();
}

class _ExamResultGroupBySemesterState extends State<ExamResultGroupBySemester> {
  @override
  Widget build(BuildContext context) {
    final scope = MultiselectScope.controllerOf<ExamResultGpaItem>(context);
    final selectedIndicesSet = scope.selectedIndexes.toSet();
    final indicesOfGroup = widget.items.map((item) => item.index).toSet();
    final intersection = selectedIndicesSet.intersection(indicesOfGroup);
    final selectedItems = intersection.map((i) => scope[i]).toList();
    final isGroupNoneSelected = intersection.isEmpty;
    final isGroupAllSelected = intersection.length == indicesOfGroup.length;
    return GroupedSection(
        headerBuilder: (context, expanded, toggleExpand, defaultTrailing) {
          return ListTile(
            leading: Icon(expanded ? Icons.expand_less : Icons.expand_more),
            title: widget.semester.l10n().text(),
            subtitle: _buildGpaText(items: selectedItems).text(),
            titleTextStyle: context.textTheme.titleMedium,
            onTap: toggleExpand,
            trailing: PlatformIconButton(
              icon: Icon(
                isGroupNoneSelected
                    ? context.icons.checkBoxBlankOutlineRounded
                    : isGroupAllSelected
                        ? context.icons.checkBoxCheckedOutlineRounded
                        : context.icons.checkBoxIndeterminateOutlineRounded,
              ),
              onPressed: () {
                for (final item in widget.items) {
                  if (isGroupAllSelected) {
                    scope.unselect(item.index);
                  } else {
                    scope.select(item.index);
                  }
                }
              },
            ),
          );
        },
        itemCount: widget.items.length,
        itemBuilder: (ctx, i) {
          final item = widget.items[i];
          final selected = scope.isSelectedIndex(item.index);
          return ExamResultGpaTile(
            item,
            selected: selected,
            onTap: () {
              scope.toggle(item.index);
            },
            onLongPress: () async {
              await ctx.show$Sheet$((ctx) => ExamResultGpaItemDetailsPage(item));
            },
          ).inFilledCard(clip: Clip.hardEdge);
        });
  }
}

class ExamResultGpaTile extends StatelessWidget {
  final ExamResultGpaItem item;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool selected;

  const ExamResultGpaTile(
    this.item, {
    super.key,
    this.onTap,
    this.onLongPress,
    required this.selected,
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
      leading: Icon(selected ? context.icons.checkBoxCheckedOutlineRounded : context.icons.checkBoxBlankOutlineRounded)
          .padAll(8),
      titleTextStyle: textTheme.titleMedium,
      title: Text(result.courseName),
      subtitleTextStyle: textTheme.bodyMedium,
      subtitle: [
        '${i18n.course.credit}: ${result.credit}'.text(),
        if (result.teachers.isNotEmpty) result.teachers.join(", ").text(),
      ].column(caa: CrossAxisAlignment.start, mas: MainAxisSize.min),
      leadingAndTrailingTextStyle: textTheme.labelSmall?.copyWith(
        fontSize: textTheme.bodyLarge?.fontSize,
        color: item.passed ? null : context.$red$,
      ),
      trailing: score.toString().text(),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}

String _buildGpaText({
  required List<ExamResultGpaItem> items,
  bool showSelectedCount = true,
}) {
  if (items.isEmpty) {
    return i18n.gpa.lessonSelected(items.length);
  }
  final validItems = items.map((item) {
    final maxScore = item.maxScore;
    if (maxScore == null) return null;
    return (score: maxScore, credit: item.credit);
  }).whereNotNull();
  final (:gpa, :credit) = calcGPA(validItems);
  var text = "${i18n.gpa.credit(credit)} ${i18n.gpa.gpaResult(gpa)}";
  if (showSelectedCount) {
    text = "${i18n.gpa.lessonSelected(items.length)} $text";
  }
  return text;
}
