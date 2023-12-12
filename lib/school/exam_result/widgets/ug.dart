import 'package:flutter/material.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/multi_select.dart';
import 'package:sit/school/widgets/course.dart';
import 'package:sit/utils/format.dart';
import 'package:rettulf/rettulf.dart';

import '../i18n.dart';
import '../entity/result.ug.dart';

class ExamResultUgSelectableCard extends StatelessWidget {
  final ExamResultUg result;
  final int index;
  final bool isSelectingMode;
  final bool elevated;

  const ExamResultUgSelectableCard(
    this.result, {
    super.key,
    required this.index,
    required this.isSelectingMode,
    required this.elevated,
  });

  @override
  Widget build(BuildContext context) {
    final controller = MultiselectScope.controllerOf(context);
    final selected = controller.isSelected(index);
    return ExamResultUgCard(
      result,
      selected: selected,
      showDetails: !isSelectingMode,
      iconOverride: !result.passed
          ? null
          : isSelectingMode
              ? Icon(selected ? Icons.check_box_outlined : Icons.check_box_outline_blank)
              : null,
      elevated: elevated,
      onTap: !result.passed
          ? null
          : !isSelectingMode
              ? null
              : () {
                  controller.select(index);
                },
    );
  }
}

class ExamResultUgCard extends StatelessWidget {
  final ExamResultUg result;
  final VoidCallback? onTap;
  final Widget? iconOverride;
  final bool selected;
  final bool showDetails;
  final bool elevated;

  const ExamResultUgCard(
    this.result, {
    super.key,
    this.onTap,
    this.iconOverride,
    this.selected = false,
    this.showDetails = true,
    required this.elevated,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final courseType = result.courseId[0] == 'G' ? i18n.elective : i18n.compulsory;
    final resultItems =
        result.items.where((e) => !e.score.isNaN && !(e.scoreType == "总评" && e.score == result.score)).toList();
    return ListTile(
      selected: selected,
      isThreeLine: true,
      leading: iconOverride ?? CourseIcon(courseName: result.courseName),
      titleTextStyle: textTheme.titleMedium,
      title: Text(result.courseName),
      subtitleTextStyle: textTheme.bodyMedium,
      subtitle: [
        '$courseType | ${i18n.credit}: ${result.credit}'.text(),
        AnimatedSize(
          duration: Durations.short4,
          curve: Curves.fastEaseInToSlowEaseOut.flipped,
          child: showDetails ? ExamResultItemChipGroup(resultItems) : const SizedBox(),
        ),
      ].column(caa: CrossAxisAlignment.start),
      leadingAndTrailingTextStyle: textTheme.labelSmall?.copyWith(
        fontSize: textTheme.bodyLarge?.fontSize,
        color: result.passed ? null : context.$red$,
      ),
      trailing: result.hasScore
          ? result.score.toString().text()
          : i18n.lessonNotEvaluated.text(style: TextStyle(fontSize: textTheme.bodyLarge?.fontSize)),
      onTap: onTap,
    ).inAnyCard(clip: Clip.hardEdge, type: elevated ? CardType.plain : CardType.filled);
  }
}

class ExamResultItemChip extends StatelessWidget {
  final ExamResultItem item;
  final bool selected;

  const ExamResultItemChip(
    this.item, {
    super.key,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final itemStyle = context.textTheme.labelSmall;
    return Chip(
      elevation: 4,
      labelStyle: selected ? itemStyle?.copyWith(color: context.colorScheme.primary) : itemStyle,
      label: buildItemText(item).text(),
      labelPadding: EdgeInsets.zero,
    );
  }

  String buildItemText(ExamResultItem item) {
    final score = formatWithoutTrailingZeros(item.score);
    if (item.percentage.isEmpty || item.percentage == "0%") {
      return '${item.scoreType}: $score';
    }
    return '${item.scoreType}${item.percentage}: $score';
  }
}

class ExamResultItemChipGroup extends StatelessWidget {
  final List<ExamResultItem> items;
  final bool selected;

  const ExamResultItemChipGroup(
    this.items, {
    super.key,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return items.map((e) => ExamResultItemChip(e)).toList().wrap(spacing: 4);
  }
}
