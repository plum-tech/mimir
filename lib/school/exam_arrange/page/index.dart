import 'package:flutter/material.dart';
import 'package:mimir/credential/widgets/oa_scope.dart';
import 'package:mimir/school/utils.dart';
import 'package:mimir/school/widgets/school.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/school/entity/school.dart';

import '../../../design/widgets/common.dart';
import '../entity/exam.dart';
import '../init.dart';
import '../widgets/exam.dart';
import '../i18n.dart';

class ExamArrangePage extends StatefulWidget {
  const ExamArrangePage({super.key});

  @override
  State<StatefulWidget> createState() => _ExamArrangePageState();
}

class _ExamArrangePageState extends State<ExamArrangePage> {
  final service = ExamArrangeInit.examService;

  /// 四位年份
  late int selectedYear;

  /// 要查询的学期
  late Semester selectedSemester;
  List<ExamEntry>? exams;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    selectedYear = now.month >= 9 ? now.year : now.year - 1;
    selectedSemester = now.month >= 3 && now.month <= 7 ? Semester.term2 : Semester.term1;
    refresh();
  }

  Future<void> refresh() async {
    setState(() {
      // To display the loading placeholder.
      this.exams = null;
    });
    final exams = await service.getExamList(
      year: SchoolYear(selectedYear),
      semester: selectedSemester,
    );
    if (exams != null) {
      exams.sort(ExamEntry.comparator);
      setState(() {
        this.exams = exams;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final exams = this.exams;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: i18n.title.text(),
              centerTitle: true,
              background: buildSemesterSelector(),
            ),
            bottom: exams != null
                ? null
                : const PreferredSize(
                    preferredSize: Size.fromHeight(4),
                    child: LinearProgressIndicator(),
                  ),
          ),
          if (exams != null)
            if (exams.isEmpty)
              SliverFillRemaining(
                child: LeavingBlank(
                  icon: Icons.inbox_outlined,
                  desc: i18n.noExamsTip,
                ),
              )
            else
              SliverList.builder(
                itemCount: exams.length,
                itemBuilder: (ctx, i) => ExamCard(exam: exams[i]),
              ),
        ],
      ),
    );
  }

  Widget buildSemesterSelector() {
    return SemesterSelector(
      initialYear: selectedYear,
      initialSemester: selectedSemester,
      baseYear: getAdmissionYearFromStudentId(context.auth.credentials?.account),
      onYearSelected: (year) {
        setState(() {
          selectedYear = year;
          refresh();
        });
      },
      onSemesterSelected: (semester) {
        setState(() {
          selectedSemester = semester;
          refresh();
        });
      },
    );
  }
}
