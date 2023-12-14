import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/animation/progress.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/design/widgets/multi_select.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/school/exam_result/entity/result.ug.dart';
import 'package:sit/school/exam_result/init.dart';
import 'package:sit/utils/error.dart';
import '../i18n.dart';
import '../utils.dart';
import '../widgets/ug.dart';

class GpaCalculatorPage extends StatefulWidget {
  const GpaCalculatorPage({super.key});

  @override
  State<GpaCalculatorPage> createState() => _GpaCalculatorPageState();
}

class _GpaCalculatorPageState extends State<GpaCalculatorPage> {
  late List<({SemesterInfo semester, List<ExamResultUg> result})>? resultList = () {
    final resultList = ExamResultInit.ugStorage.getResultList(SemesterInfo.all);
    if (resultList == null) return null;
    return groupExamResultList(resultList);
  }();
  final $loadingProgress = ValueNotifier(0.0);
  bool isFetching = false;
  final controller = ScrollController();
  bool isSelecting = false;
  final multiselect = MultiselectController();

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
        resultList = groupExamResultList(results);
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
    final resultList = this.resultList;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: "GPA".text(),
          ),
          if (resultList != null)
            if (resultList.isEmpty)
              SliverFillRemaining(
                child: LeavingBlank(
                  icon: Icons.inbox_outlined,
                  desc: i18n.noResultsTip,
                ),
              )
            // else
            //   SliverList.builder(
            //     itemCount: resultList.length,
            //     itemBuilder: (item, i) => ExamResultUgCard(
            //       resultList[i],
            //       elevated: false,
            //     ),
            //   ),
        ],
      ),
      bottomNavigationBar: isFetching
          ? PreferredSize(
              preferredSize: const Size.fromHeight(4),
              child: $loadingProgress >> (ctx, value) => AnimatedProgressBar(value: value),
            )
          : null,
    );
  }

  Widget buildTitle() {
    final resultList = this.resultList;
    final style = context.textTheme.headlineSmall;
    final selectedExams = isSelecting ? multiselect.getSelectedItems().cast<ExamResultUg>() : resultList;
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
}
