import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:mimir/design/widgets/multi_select.dart';
import 'package:mimir/school/widgets/course.dart';
import 'package:mimir/utils/format.dart';
import 'package:rettulf/rettulf.dart';

import '../i18n.dart';
import '../entity/result.dart';

class ExamResultSelectableCard extends StatelessWidget {
  final ExamResult result;
  final int index;
  final bool isSelectingMode;

  const ExamResultSelectableCard(
    this.result, {
    super.key,
    required this.index,
    required this.isSelectingMode,
  });

  @override
  Widget build(BuildContext context) {
    final controller = MultiselectScope.controllerOf(context);
    final selected = controller.isSelected(index);
    return ExamResultCard(
      result,
      selected: selected,
      iconOverride: isSelectingMode ? Icon(selected ? Icons.check_box_outlined : Icons.check_box_outline_blank) : null,
      detailsOverride: isSelectingMode ? const SizedBox() : null,
      onTap: !isSelectingMode
          ? null
          : () {
              controller.select(index);
            },
    );
  }
}

class ExamResultCard extends StatelessWidget {
  final ExamResult result;
  final VoidCallback? onTap;
  final Widget? iconOverride;
  final Widget? detailsOverride;
  final bool selected;

  const ExamResultCard(
    this.result, {
    super.key,
    this.onTap,
    this.iconOverride,
    this.detailsOverride,
    this.selected = false,
  });

  static const iconSize = 45.0;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final courseType = result.courseId[0] == 'G' ? i18n.elective : i18n.compulsory;
    final resultItems =
        result.items.where((e) => !e.score.isNaN && !(e.scoreType == "总评" && e.score == result.score)).toList();
    return ListTile(
      selected: selected,
      leading: iconOverride?.sized(w: iconSize, h: iconSize) ??
          CourseIcon(courseName: result.courseName).sized(w: iconSize, h: iconSize),
      titleTextStyle: textTheme.titleMedium,
      title: Text(result.courseName),
      subtitleTextStyle: textTheme.bodyMedium,
      subtitle: [
        '$courseType | ${i18n.credit}: ${result.credit}'.text(),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastEaseInToSlowEaseOut.flipped,
          child: detailsOverride ?? ExamResultItemChipGroup(resultItems),
        ),
      ].column(caa: CrossAxisAlignment.start),
      trailing: result.hasScore
          ? result.score.toString().text(style: TextStyle(fontSize: textTheme.bodyLarge?.fontSize))
          : i18n.lessonNotEvaluated.text(style: TextStyle(fontSize: textTheme.bodyLarge?.fontSize)),
      onTap: onTap,
    ).inOutlinedCard();
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
