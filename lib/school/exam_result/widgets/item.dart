import 'package:flutter/material.dart';
import 'package:mimir/design/animation/animated.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:mimir/design/widgets/multi_select.dart';
import 'package:mimir/utils/format.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/school/entity/school.dart';

import '../i18n.dart';
import '../entity/result.dart';

class ExamResultTile extends StatefulWidget {
  final ExamResult result;
  final int index;
  final bool isSelectingMode;

  const ExamResultTile(this.result, {super.key, required this.index, required this.isSelectingMode});

  @override
  State<ExamResultTile> createState() => _ExamResultTileState();
}

class _ExamResultTileState extends State<ExamResultTile> {
  ExamResult get result => widget.result;
  static const iconSize = 45.0;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final controller = MultiselectScope.controllerOf(context);
    final selected = controller.isSelected(widget.index);
    Widget buildLeading() {
      if (widget.isSelectingMode) {
        return Icon(selected ? Icons.check_box_outlined : Icons.check_box_outline_blank)
            .sized(key: const ValueKey("Checkbox"), w: iconSize, h: iconSize);
      } else {
        return Image.asset(
          CourseCategory.iconPathOf(courseName: result.courseName),
        ).sized(key: const ValueKey("Icon"), w: iconSize, h: iconSize);
      }
    }

    final courseType = result.courseId[0] != 'G' ? i18n.compulsory : i18n.elective;
    final resultItems =
        result.items.where((e) => !e.score.isNaN && !(e.scoreType == "总评" && e.score == result.score)).toList();
    final itemStyle = textTheme.labelSmall?.copyWith(color: selected ? context.colorScheme.primary : null);
    return ListTile(
      selected: selected,
      leading: buildLeading().animatedSwitched(
        duration: const Duration(milliseconds: 300),
      ),
      titleTextStyle: textTheme.titleMedium,
      title: Text(result.courseName),
      subtitleTextStyle: textTheme.bodyMedium,
      subtitle: [
        '$courseType | ${i18n.credit}: ${result.credit}'.text(),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastEaseInToSlowEaseOut.flipped,
          child: resultItems.isNotEmpty && !widget.isSelectingMode
              ? resultItems
                  .map((e) => Chip(
                        labelStyle: itemStyle,
                        label: buildItemText(e).text(),
                        labelPadding: EdgeInsets.zero,
                      ))
                  .toList()
                  .wrap(spacing: 4)
              : const SizedBox(),
        )
      ].column(caa: CrossAxisAlignment.start),
      trailing: result.hasScore
          ? result.score.toString().text(style: TextStyle(fontSize: textTheme.bodyLarge?.fontSize))
          : i18n.lessonNotEvaluated.text(style: TextStyle(fontSize: textTheme.bodyLarge?.fontSize)),
      onTap: !widget.isSelectingMode
          ? null
          : () {
              controller.select(widget.index);
            },
    ).inOutlinedCard();
  }

  String buildItemText(ExamResultItem item) {
    final score = formatWithoutTrailingZeros(item.score);
    if (item.percentage.isEmpty || item.percentage == "0%") {
      return '${item.scoreType}: $score';
    }
    return '${item.scoreType}${item.percentage}: $score';
  }
}
