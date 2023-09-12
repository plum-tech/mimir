import 'package:flutter/material.dart';
import 'package:mimir/credential/widgets/oa_scope.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:mimir/design/widgets/multi_select.dart';
import 'package:mimir/school/utils.dart';
import 'package:mimir/school/widgets/school.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/school/entity/school.dart';

import '../entity/result.dart';
import '../init.dart';
import '../widgets/item.dart';
import '../utils.dart';
import '../i18n.dart';

class ExamResultPage extends StatefulWidget {
  const ExamResultPage({super.key});

  @override
  State<ExamResultPage> createState() => _ExamResultPageState();
}

class _ExamResultPageState extends State<ExamResultPage> {
  /// 四位年份
  late int selectedYear;

  /// 要查询的学期
  late Semester selectedSemester;

  /// 成绩列表
  List<ExamResult>? _allResults;

  bool isSelecting = false;
  final multiselect = MultiselectController();
  final _multiselectKey = GlobalKey(debugLabel: "Multiselect");

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedYear = (now.month >= 9 ? now.year : now.year - 1);
    selectedSemester = Semester.all;
    onRefresh();
  }

  @override
  void dispose() {
    multiselect.dispose();
    super.dispose();
  }

  void onRefresh() {
    if (!mounted) return;
    setState(() {
      _allResults = null;
    });
    ExamResultInit.resultService.getResultList(SchoolYear(selectedYear), selectedSemester).then((value) {
      if (!mounted) return;
      setState(() {
        _allResults = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final allResults = _allResults;
    return Scaffold(
      appBar: AppBar(
        title: buildTitle(),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSelecting = !isSelecting;
                  if (isSelecting == false) {
                    multiselect.clearSelection();
                  }
                });
              },
              icon: Icon(isSelecting ? Icons.check_box_outlined : Icons.check_box_outline_blank)),
        ],
        bottom: allResults != null
            ? null
            : const PreferredSize(
                preferredSize: Size.fromHeight(4),
                child: LinearProgressIndicator(),
              ),
      ),
      body: [
        SemesterSelector(
          showEntireYear: true,
          initialYear: selectedYear,
          initialSemester: selectedSemester,
          baseYear: getAdmissionYearFromStudentId(context.auth.credentials?.account),
          onNewYearSelect: (year) {
            setState(() => selectedYear = year);
            onRefresh();
          },
          onNewSemesterSelect: (semester) {
            setState(() => selectedSemester = semester);
            onRefresh();
          },
        ),
        (allResults == null ? const SizedBox() : _buildExamResultList(allResults)).expanded(),
      ].column(),
    );
  }

  Widget buildTitle() {
    final allResults = _allResults;
    final selectedExams = isSelecting ? multiselect.getSelectedItems().cast<ExamResult>() : allResults;
    if (selectedExams != null) {
      final gpa = calcGPA(selectedExams.where((exam) => exam.hasScore));
      if (isSelecting) {
        return [
          i18n.lessonSelected(selectedExams.length).text(textAlign: TextAlign.center).expanded(),
          i18n.gpaResult(gpa).text(textAlign: TextAlign.center).expanded(),
        ].row();
      } else {
        return [
          selectedSemester.localized().text(textAlign: TextAlign.center).expanded(),
          i18n.gpaResult(gpa).text(textAlign: TextAlign.center).expanded(),
        ].row();
      }
    } else {
      return i18n.title.text();
    }
  }

  Widget _buildExamResultList(List<ExamResult> all) {
    if (all.isEmpty) {
      return LeavingBlank(
        icon: Icons.inbox_outlined,
        desc: i18n.noResult,
      );
    }
    return MultiselectScope<ExamResult>(
      key: _multiselectKey,
      controller: multiselect,
      dataSource: all,
      // Set this to true if you want automatically
      // clear selection when user tap back button
      clearSelectionOnPop: true,
      // When you update [dataSource] then selected indexes will update
      // so that the same elements in new [dataSource] are selected
      keepSelectedItemsBetweenUpdates: true,
      initialSelectedIndexes: null,
      // Callback that call on selection changing
      onSelectionChanged: (indexes, items) {
        setState(() {});
      },
      child: GridView.builder(
        itemCount: all.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 750,
          mainAxisExtent: 60,
        ),
        itemBuilder: (ctx, index) => ScoreItem(all[index], index: index, isSelectingMode: isSelecting),
      ),
    );
  }
}
