import 'package:flutter/material.dart';
import 'package:mimir/credential/widgets/oa_scope.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:mimir/design/widgets/fab.dart';
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
  List<ExamResult>? allResults;
  final controller = ScrollController();

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
      this.allResults = null;
    });
    ExamResultInit.resultService.getResultList(SchoolYear(selectedYear), selectedSemester).then((value) {
      if (!mounted) return;
      setState(() {
        this.allResults = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final allResults = this.allResults;
    return Scaffold(
      body: MultiselectScope<ExamResult>(
        key: _multiselectKey,
        controller: multiselect,
        dataSource: allResults ?? const [],
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
        child: CustomScrollView(
          controller: controller,
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                title: buildTitle(),
                centerTitle: true,
                background: buildSemesterSelector(),
              ),
              bottom: allResults != null
                  ? null
                  : const PreferredSize(
                      preferredSize: Size.fromHeight(4),
                      child: LinearProgressIndicator(),
                    ),
            ),
            if (allResults != null)
              if (allResults.isEmpty)
                SliverFillRemaining(
                  child: LeavingBlank(
                    icon: Icons.inbox_outlined,
                    desc: i18n.noResultsTip,
                  ),
                )
              else
                SliverList.builder(
                  itemCount: allResults.length,
                  itemBuilder: (item, i) => ExamResultTile(
                    allResults[i],
                    index: i,
                    isSelectingMode: isSelecting,
                  ),
                ),
          ],
        ),
      ),
      floatingActionButton: AutoHideFAB.extended(
        controller: controller,
        alwaysShow: isSelecting,
        onPressed: () {
          setState(() {
            isSelecting = !isSelecting;
            if (isSelecting == false) {
              multiselect.clearSelection();
            }
          });
        },
        label: Text(isSelecting ? i18n.unselect : i18n.select),
        icon: Icon(isSelecting ? Icons.check_box_outlined : Icons.check_box_outline_blank),
      ),
    );
  }

  Widget buildSemesterSelector() {
    return SemesterSelector(
      showEntireYear: true,
      initialYear: selectedYear,
      initialSemester: selectedSemester,
      baseYear: getAdmissionYearFromStudentId(context.auth.credentials?.account),
      onYearSelected: (year) {
        setState(() => selectedYear = year);
        onRefresh();
      },
      onSemesterSelected: (semester) {
        setState(() => selectedSemester = semester);
        onRefresh();
      },
    );
  }

  Widget buildTitle() {
    final allResults = this.allResults;
    final style = context.textTheme.headlineSmall;
    final selectedExams = isSelecting ? multiselect.getSelectedItems().cast<ExamResult>() : allResults;
    if (selectedExams != null) {
      final gpa = calcGPA(selectedExams.where((exam) => exam.hasScore));
      if (isSelecting) {
        return [
          i18n.lessonSelected(selectedExams.length).text(textAlign: TextAlign.center, style: style).expanded(),
          i18n.gpaResult(gpa).text(textAlign: TextAlign.center, style: style).expanded(),
        ].row();
      } else {
        return [
          selectedSemester.localized().text(textAlign: TextAlign.center, style: style).expanded(),
          i18n.gpaResult(gpa).text(textAlign: TextAlign.center, style: style).expanded(),
        ].row();
      }
    } else {
      return i18n.title.text(style: style);
    }
  }
}
