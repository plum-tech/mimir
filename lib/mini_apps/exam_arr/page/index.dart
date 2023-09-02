import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/exam.dart';
import '../init.dart';
import '../widgets/exam.dart';
import '../using.dart';

class ExamArrangementPage extends StatefulWidget {
  const ExamArrangementPage({super.key});

  @override
  State<StatefulWidget> createState() => _ExamArrangementPageState();
}

class _ExamArrangementPageState extends State<ExamArrangementPage> {
  final service = ExamArrInit.examService;

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

  @override
  Widget build(BuildContext context) {
    final exams = _exams;
    return Scaffold(
        appBar: AppBar(title: MiniApp.examArr.l10nName().text()),
        body: [
          buildSemesterSelector(),
          exams == null ? Placeholders.loading().expanded() : buildExamEntries(exams).expanded(),
        ].column());
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

  Widget buildExamEntries(List<ExamEntry> exams) {
    if (exams.isEmpty) {
      return LeavingBlank.svgAssets(
        assetName: "assets/common/not_found.svg",
        desc: i18n.noExamThisSemester,
        width: 240,
        height: 240,
      );
    } else {
      return LiveGrid.options(
        itemCount: exams.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 750,
          mainAxisExtent: 260,
        ),
        options: commonLiveOptions,
        itemBuilder: (ctx, index, animation) =>
            ExamCard(exam: exams[index]).padSymmetric(v: 8, h: 16).inCard(elevation: 5).padAll(8).aliveWith(animation),
      );
    }
  }

  Widget buildSemesterSelector() {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      child: SemesterSelector(
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
        initialYear: selectedYear,
        initialSemester: selectedSemester,
        showEntireYear: false,
      ),
    );
  }
}
