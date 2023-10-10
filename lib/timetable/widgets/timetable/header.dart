import 'package:flutter/material.dart';
import 'package:sit/school/entity/school.dart';
import 'package:rettulf/rettulf.dart';

import '../../i18n.dart';

class TimetableHeader extends StatefulWidget {
  /// 当前显示的周次
  final int currentWeek;

  /// 当前初始选中的日 (1-7)
  final int selectedDay;

  /// 点击的回调
  final Function(int)? onDayTap;

  final DateTime startDate;

  const TimetableHeader({
    super.key,
    required this.currentWeek,
    required this.selectedDay,
    required this.startDate,
    this.onDayTap,
  });

  @override
  State<StatefulWidget> createState() => _TimetableHeaderState();
}

class _TimetableHeaderState extends State<TimetableHeader> {
  int get selectedDay => widget.selectedDay;

  @override
  void initState() {
    super.initState();
  }

  /// 布局标题栏下方的时间选择行
  ///
  /// 将该行分为 2 + 7 * 3 一共 23 个小份, 左侧的周数占 2 份, 每天的日期占 3 份.
  @override
  Widget build(BuildContext context) {
    return [
      for (int i = 1; i <= 7; ++i) buildDayNameHeader(i),
    ].row(maa: MainAxisAlignment.spaceEvenly);
  }

  ///每天的列
  Widget buildDayNameHeader(int day) {
    final date = reflectWeekDayNumberToDate(week: widget.currentWeek, day: day, startDate: widget.startDate);
    final onDayTap = widget.onDayTap;
    return Expanded(
      flex: 3,
      child: InkWell(
        onTap: onDayTap != null
            ? () {
                widget.onDayTap?.call(day);
              }
            : null,
        child: buildDayHeader(day),
      ),
    );
  }

  Widget buildDayHeader(int day) {
    final date = reflectWeekDayNumberToDate(week: widget.currentWeek, day: day, startDate: widget.startDate);
    final isSelected = day == selectedDay;
    final side = getBorderSide(context);
    return AnimatedContainer(
      decoration: BoxDecoration(
        color: isSelected ? context.colorScheme.secondaryContainer : null,
        border: Border(bottom: side),
      ),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.fastLinearToSlowEaseIn,
      child: [
        i18n.weekdayShort(index: day - 1).text(
              textAlign: TextAlign.center,
              style: context.textTheme.titleSmall,
            ),
        '${date.month}/${date.day}'.text(
          textAlign: TextAlign.center,
          style: context.textTheme.labelSmall,
        ),
      ].column().padOnly(t: 5, b: 5),
    );
  }
}

BorderSide getBorderSide(BuildContext ctx) => BorderSide(color: ctx.colorScheme.primary.withOpacity(0.4), width: 0.8);
