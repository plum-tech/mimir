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

class ExamArrangementPage extends StatefulWidget {
  const ExamArrangementPage({super.key});

  @override
  State<StatefulWidget> createState() => _ExamArrangementPageState();
}

class _ExamArrangementPageState extends State<ExamArrangementPage> {
  final service = ExamArrangeInit.examService;

  /// 四位年份
  late int selectedYear;

  /// 要查询的学期
  late Semester selectedSemester;
  List<ExamEntry>? _exams;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    selectedYear = (now.month >= 9 ? now.year : now.year - 1);
    selectedSemester = (now.month >= 3 && now.month <= 7) ? Semester.term2 : Semester.term1;
    refresh();
  }

  void refresh() {
    setState(() {
      // To display the loading placeholder.
      _exams = null;
    });
    service
        .getExamList(
      SchoolYear(selectedYear),
      selectedSemester,
    )
        .then((value) {
      if (value != null) {
        value.sort(ExamEntry.comparator);
        setState(() {
          _exams = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final exams = _exams ?? const [];
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 180,
          flexibleSpace: FlexibleSpaceBar(
            title: i18n.title.text(),
            centerTitle: true,
            background: buildSemesterSelector(),
          ),
          bottom: _exams != null
              ? null
              : const PreferredSize(
                  preferredSize: Size.fromHeight(4),
                  child: LinearProgressIndicator(),
                ),
        ),
        if (_exams != null)
          if (exams.isEmpty)
            SliverToBoxAdapter(
              child: LeavingBlank(
                icon: Icons.inbox_outlined,
                desc: i18n.noExamThisSemester,
              ),
            )
          else
            ...exams.map((exam) => SliverToBoxAdapter(
                child: ExamCard(exam: exam).padSymmetric(v: 8, h: 16).inCard(elevation: 5).padAll(8))),
      ],
    );
  }

  Widget buildSemesterSelector() {
    return SemesterSelector(
      initialYear: selectedYear,
      initialSemester: selectedSemester,
      baseYear: getAdmissionYearFromStudentId(context.auth.credentials?.account),
      onNewYearSelect: (year) {
        setState(() {
          selectedYear = year;
          refresh();
        });
      },
      onNewSemesterSelect: (semester) {
        setState(() {
          selectedSemester = semester;
          refresh();
        });
      },
    );
  }
}
