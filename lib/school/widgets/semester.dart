import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/school.dart';
import "../i18n.dart";

class SemesterSelector extends StatefulWidget {
  final int? baseYear;
  final SemesterInfo? initial;

  /// 是否显示整个学年
  final bool showEntireYear;
  final void Function(SemesterInfo newSelection)? onSelected;

  const SemesterSelector({
    super.key,
    required this.baseYear,
    this.onSelected,
    this.initial,
    this.showEntireYear = false,
  });

  @override
  State<StatefulWidget> createState() => _SemesterSelectorState();
}

class _SemesterSelectorState extends State<SemesterSelector> {
  late final DateTime now;

  /// 四位年份
  late int selectedYear;

  /// 要查询的学期
  late Semester selectedSemester;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    selectedYear = widget.initial?.year ?? (now.month >= 9 ? now.year : now.year - 1);
    if (widget.showEntireYear) {
      selectedSemester = widget.initial?.semester ?? Semester.all;
    } else {
      selectedSemester =
          widget.initial?.semester ?? (now.month >= 3 && now.month <= 7 ? Semester.term2 : Semester.term1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return [
      buildYearSelector().padH(4),
      buildSemesterSelector().padH(4),
    ].row(caa: CrossAxisAlignment.start, mas: MainAxisSize.min).padSymmetric(v: 5).center();
  }

  List<int> _generateYearList() {
    final endYear = now.month >= 9 ? now.year : now.year - 1;
    List<int> yearItems = [];
    for (var year = widget.baseYear ?? now.year; year <= endYear; year++) {
      yearItems.add(year);
    }
    return yearItems;
  }

  Widget buildYearSelector() {
    // 生成经历过的学期并逆序（方便用户选择）
    final List<int> yearList = _generateYearList().reversed.toList();

    // 保证显示上初始选择年份、实际加载的年份、selectedYear 变量一致.
    return DropdownMenu<int>(
      label: i18n.course.schoolYear.text(),
      initialSelection: selectedYear,
      onSelected: (int? newSelection) {
        if (newSelection != null && newSelection != selectedYear) {
          setState(() => selectedYear = newSelection);
          widget.onSelected?.call(SemesterInfo(year: newSelection, semester: selectedSemester));
        }
      },
      dropdownMenuEntries: yearList
          .map((year) => DropdownMenuEntry<int>(
                value: year,
                label: "$year–${year + 1}",
              ))
          .toList(),
    );
  }

  Widget buildSemesterSelector() {
    List<Semester> semesters = widget.showEntireYear
        ? const [Semester.all, Semester.term1, Semester.term2]
        : const [Semester.term1, Semester.term2];
    // 保证显示上初始选择学期、实际加载的学期、selectedSemester 变量一致.
    return DropdownMenu<Semester>(
      label: i18n.course.semester.text(),
      initialSelection: selectedSemester,
      onSelected: (Semester? newSelection) {
        if (newSelection != null && newSelection != selectedSemester) {
          setState(() => selectedSemester = newSelection);
          widget.onSelected?.call(SemesterInfo(year: selectedYear, semester: newSelection));
        }
      },
      dropdownMenuEntries: semesters
          .map((semester) => DropdownMenuEntry<Semester>(
                value: semester,
                label: semester.l10n(),
              ))
          .toList(),
    );
  }
}
