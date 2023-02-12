import 'package:flutter/material.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/result.dart';
import '../init.dart';
import '../using.dart';

class ScoreItem extends StatefulWidget {
  final ExamResult result;
  final int index;
  final bool isSelectingMode;

  const ScoreItem(this.result, {super.key, required this.index, required this.isSelectingMode});

  @override
  State<ScoreItem> createState() => _ScoreItemState();
}

class _ScoreItemState extends State<ScoreItem> {
  ExamResult get result => widget.result;
  static const iconSize = 45.0;
  List<ExamResultDetail>? details;

  @override
  void initState() {
    super.initState();
    ExamResultInit.resultService.getResultDetail(result.innerClassId, result.schoolYear, result.semester).then((value) {
      if (details != value) {
        if (!mounted) return;
        setState(() {
          details = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final subtitleStyle = Theme.of(context).textTheme.bodyMedium;
    final scoreStyle = titleStyle?.copyWith(color: context.darkSafeThemeColor);
    final controller = MultiselectScope.controllerOf(context);
    final itemIsSelected = controller.isSelected(widget.index);
    final selecting = widget.isSelectingMode;
    Widget buildLeading() {
      if (selecting) {
        return MSHCheckbox(
          size: 30,
          duration: const Duration(milliseconds: 300),
          value: itemIsSelected,
          colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
            checkedColor: Colors.blue,
          ),
          style: MSHCheckboxStyle.stroke,
          onChanged: (selected) {
            setState(() {
              controller.select(widget.index);
            });
          },
        ).sized(key: const ValueKey("Checkbox"), w: iconSize, h: iconSize);
      } else {
        return Image.asset(
          CourseCategory.iconPathOf(courseName: result.course),
        ).sized(key: const ValueKey("Icon"), w: iconSize, h: iconSize);
      }
    }

    Widget buildTrailing() {
      // The value of exam result is NaN means this lesson requires evaluation.
      if (result.value.isNaN) {
        return i18n.lessonNotEvaluated.text(style: scoreStyle);
      } else {
        return Text(result.value.toString(), style: scoreStyle);
      }
    }

    final tile = ListTile(
      leading: buildLeading().animatedSwitched(
        d: const Duration(milliseconds: 300),
      ),
      title: Text(stylizeCourseName(result.course), style: titleStyle),
      subtitle: getSubtitle().text(style: subtitleStyle),
      trailing: buildTrailing(),
    );
    return tile;
  }

  String getSubtitle() {
    final courseType = result.courseId[0] != 'G' ? i18n.courseCompulsory : i18n.courseElective;
    return '$courseType | ${i18n.courseCredit}: ${result.credit}';
  }

  // TODO: Where to display this?
  Widget _buildScoreDetailView(List<ExamResultDetail> scoreDetails) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.blue, width: 3),
        ),
      ),
      child: Column(
        children: scoreDetails.map((e) => Text('${e.scoreType} (${e.percentage}): ${e.value}')).toList(),
      ),
    );
  }
}
