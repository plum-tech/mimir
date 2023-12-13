import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/list_tile.dart';
import 'package:sit/design/widgets/navigation.dart';
import 'package:sit/school/exam_result/entity/result.ug.dart';
import '../i18n.dart';

class ExamResultUgDetailsPage extends StatefulWidget {
  final ExamResultUg result;

  const ExamResultUgDetailsPage(this.result, {super.key});

  @override
  State<ExamResultUgDetailsPage> createState() => _ExamResultDetailsPageState();
}

class _ExamResultDetailsPageState extends State<ExamResultUgDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final score = result.score;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            pinned: true,
            title: result.courseName.text(),
          ),
          SliverList.list(children: [
            if (score != null)
              DetailListTile(
                leading: const Icon(Icons.score),
                title: "Score",
                subtitle: result.score.toString(),
              )
            else
              PageNavigationTile(
                leading: const Icon(Icons.warning),
                title: i18n.lessonNotEvaluated.text(),
                subtitle: "Score is available after evaluation".text(),
                path: '/teacher-eval',
              ),
            if (result.teachers.isNotEmpty)
              DetailListTile(
                leading: Icon(result.teachers.length > 1 ? Icons.people : Icons.person),
                title: "Teachers", // plural
                subtitle: result.teachers.join(", "),
              ),
            DetailListTile(
              leading: const Icon(Icons.category),
              title: "Course category",
              subtitle: result.courseCat.toString(),
            ),
            DetailListTile(
              leading: const Icon(Icons.school),
              title: i18n.credit,
              subtitle: result.credit.toString(),
            ),
          ]),
        ],
      ),
    );
  }
}
