import 'package:flutter/material.dart';
import 'package:mimir/credential/widgets/oa_scope.dart';
import 'package:mimir/school/utils.dart';
import 'package:mimir/school/widgets/selector.dart';
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
  final service = ExamArrangeInit.service;

  /// 四位年份
  late int selectedYear;

  /// 要查询的学期
  late Semester selectedSemester;
  List<ExamEntry>? examList;
  late SchoolYear initialYear;
  late Semester initialSemester;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    initialYear = now.month >= 9 ? now.year : now.year - 1;
    initialSemester = now.month >= 3 && now.month <= 7 ? Semester.term2 : Semester.term1;
    selectedYear = initialYear;
    selectedSemester = initialSemester;
    refresh(year: initialYear, semester: initialSemester);
  }

  Future<void> refresh({
    required SchoolYear year,
    required Semester semester,
  }) async {
    if (!mounted) return;
    setState(() {
      examList = ExamArrangeInit.storage.getExamList(year: year, semester: semester);
      isLoading = true;
    });
    try {
      final examList = await service.getExamList(year: year, semester: semester);
      ExamArrangeInit.storage.setExamList(examList, year: year, semester: semester);
      if (year == selectedYear && semester == selectedSemester) {
        if (!mounted) return;
        setState(() {
          this.examList = examList;
          isLoading = false;
        });
      }
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final examList = this.examList;
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
            bottom: isLoading
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(4),
                    child: LinearProgressIndicator(),
                  )
                : null,
          ),
          if (examList != null)
            if (examList.isEmpty)
              SliverFillRemaining(
                child: LeavingBlank(
                  icon: Icons.inbox_outlined,
                  desc: i18n.noExamsTip,
                ),
              )
            else
              SliverList.builder(
                itemCount: examList.length,
                itemBuilder: (ctx, i) => ExamCard(exam: examList[i]),
              ),
        ],
      ),
    );
  }

  Widget buildSemesterSelector() {
    return SemesterSelector(
      initialYear: initialYear,
      initialSemester: initialSemester,
      baseYear: getAdmissionYearFromStudentId(context.auth.credentials?.account),
      onSelected: (year, semester) {
        setState(() {
          selectedYear = year;
          selectedSemester = semester;
        });
        refresh(year: selectedYear, semester: selectedSemester);
      },
    );
  }
}
