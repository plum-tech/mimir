import 'package:flutter/material.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/school/widgets/course.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/result.pg.dart';
import '../i18n.dart';

class ExamResultPgCard extends StatelessWidget {
  final bool elevated;
  final ExamResultPg result;

  const ExamResultPgCard(
    this.result, {
    super.key,
    required this.elevated,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return ListTile(
      isThreeLine: true,
      leading: CourseIcon(courseName: result.courseName),
      titleTextStyle: textTheme.titleMedium,
      title: Text(result.courseName),
      subtitleTextStyle: textTheme.bodyMedium,
      subtitle: [
        '${result.courseType} ${result.teacher}'.text(),
        '${result.examType} | ${i18n.credit}: ${result.credit}'.text(),
      ].column(caa: CrossAxisAlignment.start),
      trailing: result.score.toString().text(
            style: TextStyle(
              fontSize: textTheme.bodyLarge?.fontSize,
              color: result.passed ? null : context.$red$,
            ),
          ),
    ).inAnyCard(clip: Clip.hardEdge, type: elevated ? CardType.plain : CardType.filled);
  }
}
