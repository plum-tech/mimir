import 'package:flutter/material.dart';
import 'package:mimir/design/animation/animated.dart';
import 'package:mimir/design/colors.dart';
import 'package:mimir/design/widgets/multi_select.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/school/entity/school.dart';

import '../i18n.dart';
import '../entity/result.dart';
import '../init.dart';

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
  List<ExamResultDetails>? details;

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

    return ListTile(
      selected: selected,
      leading: buildLeading().animatedSwitched(
        d: const Duration(milliseconds: 300),
      ),
      titleTextStyle: textTheme.titleMedium,
      title: Text(result.courseName),
      subtitleTextStyle: textTheme.bodyMedium,
      subtitle: getSubtitle().text(),
      trailing: result.hasScore
          ? result.score.toString().text(style: TextStyle(fontSize: textTheme.bodyLarge?.fontSize))
          : i18n.lessonNotEvaluated.text(style: TextStyle(fontSize: textTheme.bodyLarge?.fontSize)),
      onTap: !widget.isSelectingMode
          ? null
          : () {
              controller.select(widget.index);
            },
    );
  }

  String getSubtitle() {
    final courseType = result.courseId[0] != 'G' ? i18n.compulsory : i18n.elective;
    return '$courseType | ${i18n.credit}: ${result.credit}';
  }

  // TODO: Where to display this?
  Widget _buildScoreDetailView(List<ExamResultDetails> scoreDetails) {
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
