import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

class YearMonthSelector extends StatefulWidget {
  final List<int> years;
  final List<int> months;
  final bool enableAllYears;
  final bool enableAllMonths;

  const YearMonthSelector({
    super.key,
    required this.years,
    required this.months,
    this.enableAllYears = false,
    this.enableAllMonths = false,
  });

  @override
  State<YearMonthSelector> createState() => _YearMonthSelectorState();
}

class _YearMonthSelectorState extends State<YearMonthSelector> {
  late int selectedYear;
  late int selectedMonth;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  Widget buildMonthYearSelector() {
    final years = widget.years;
    final months = widget.months;
    // TODO: 支持查看全年统计, 此时 chart line 也需要修改.
    // TODO: 年月不超过当前日期.
    final yearWidgets = years.map((e) => PopupMenuItem<int>(value: e, child: Text(e.toString()))).toList();
    final monthWidgets = months.map((e) => PopupMenuItem<int>(value: e, child: Text(e.toString()))).toList();

    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          PopupMenuButton(
            onSelected: (int value) => setState(() => selectedMonth = value),
            child: Text(' $selectedMonth 月', style: titleStyle),
            itemBuilder: (_) => monthWidgets,
          ),
        ],
      ),
    );
  }

  Widget buildYearSelector() {
    // 生成经历过的学期并逆序（方便用户选择）
    // 保证显示上初始选择年份、实际加载的年份、selectedYear 变量一致.
    return DropdownMenu<int>(
      label: "Year".text(),
      initialSelection: selectedYear,
      onSelected: (int? selected) {
        if (selected != null && selected != selectedYear) {
          setState(() => selectedYear = selected);
        }
      },
      dropdownMenuEntries: widget.years
          .map((year) => DropdownMenuEntry<int>(
                value: year,
                label: "$year–${year + 1}",
              ))
          .toList(),
    );
  }
}
