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
  List<ExamResult>? resultList;
  bool isLoading = false;
  final controller = ScrollController();

  bool isSelecting = false;
  final multiselect = MultiselectController();
  final _multiselectKey = GlobalKey(debugLabel: "Multiselect");

  late SchoolYear initialYear;
  late Semester initialSemester;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    initialYear = now.month >= 9 ? now.year : now.year - 1;
    initialSemester = Semester.all;
    selectedYear = initialYear;
    selectedSemester = initialSemester;
    refresh(year: initialYear, semester: initialSemester);
  }

  @override
  void dispose() {
    multiselect.dispose();
    super.dispose();
  }

  Future<void> refresh({
    required SchoolYear year,
    required Semester semester,
  }) async {
    if (!mounted) return;
    setState(() {
      resultList = ExamResultInit.storage.getResultList(year: year, semester: semester);
      isLoading = true;
    });
    try {
      final resultList = await ExamResultInit.service.getResultList(year: year, semester: semester);
      ExamResultInit.storage.setResultList(resultList, year: year, semester: semester);
      // Prevents the former query replace new query.
      if (year == selectedYear && semester == selectedSemester) {
        if (!mounted) return;
        setState(() {
          this.resultList = resultList;
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
    final allResults = this.resultList;
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
              bottom: isLoading
                  ? const PreferredSize(
                      preferredSize: Size.fromHeight(4),
                      child: LinearProgressIndicator(),
                    )
                  : null,
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

  Widget buildTitle() {
    final allResults = this.resultList;
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
