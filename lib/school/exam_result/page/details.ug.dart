import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/list_tile.dart';
import 'package:sit/design/widgets/navigation.dart';
import 'package:sit/l10n/extension.dart';
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
    final time = result.time;
    final items =
        result.items.where((e) => e.score != null && !(e.scoreType == "总评" && e.score == result.score)).toList();
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
            DetailListTile(
              leading: const Icon(Icons.class_),
              title: "Exam type",
              subtitle: result.examType.toString(),
            ),
            DetailListTile(
              leading: const Icon(Icons.view_timeline_outlined),
              title: "Semester",
              subtitle: result.semesterInfo.l10n(),
            ),
            if (time != null)
              DetailListTile(
                leading: const Icon(Icons.access_time),
                title: "Time",
                subtitle: context.formatYmdhmNum(time),
              ),
            DetailListTile(
              leading: const Icon(Icons.numbers),
              title: "Course code",
              subtitle: result.courseCode.toString(),
            ),
            if (result.classCode.isNotEmpty)
              DetailListTile(
                leading: const Icon(Icons.group),
                title: "Class code",
                subtitle: result.classCode.toString(),
              ),
            DetailListTile(
              leading: const Icon(Icons.category),
              title: "Course category",
              subtitle: result.courseCat.toString(),
            ),
            if (result.teachers.isNotEmpty)
              DetailListTile(
                leading: Icon(result.teachers.length > 1 ? Icons.people : Icons.person),
                title: "Teachers", // plural
                subtitle: result.teachers.join(", "),
              ),
          ]),
          const SliverToBoxAdapter(
            child: Divider(),
          ),
          SliverGrid.extent(
            maxCrossAxisExtent: 240,
            children: items
                .map((item) => ListTile(
                      title: "${item.scoreType} ${item.percentage}".text(),
                      subtitle: item.score.toString().text(),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
