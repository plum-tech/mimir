import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../../using.dart';

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
    ].row();
  }

  ///每天的列
  Widget buildDayNameHeader(int day) {
    final onDayTap = widget.onDayTap;
    Widget res = buildDayHeader(context, day).on(
        tap: onDayTap == null
            ? null
            : () {
                widget.onDayTap?.call(day);
              });
    res = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: res,
    );
    return res.expanded();
  }

  Widget buildDayHeader(BuildContext ctx, int day) {
    final isSelected = day == selectedDay;
    final (:text, :bg) = ctx.makeTabHeaderTextBgColors(isSelected);

    return AnimatedSlide(
      offset: isSelected ? const Offset(0.01, -0.04) : Offset.zero,
      duration: const Duration(milliseconds: 100),
      child: AnimatedContainer(
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastLinearToSlowEaseIn,
        child: buildHeaderText(ctx, day, text),
      ).inCard(
        elevation: isSelected ? 25 : 8,
      ),
    );
  }

  Widget buildHeaderText(BuildContext ctx, int day, Color textColor) {
    final weekdayHeader = i18n.weekdayShort(index: day - 1);
    final date = convertWeekDayNumberToDate(week: widget.currentWeek, day: day, basedOn: widget.startDate);
    final name = '$weekdayHeader\n${date.month}/${date.day}';

    return LayoutBuilder(builder: (ctx, box) {
      final span = TextSpan(
        text: name,
      );
      final painter = TextPainter(
        text: span,
        maxLines: 2,
        textDirection: TextDirection.ltr,
      );
      painter.layout();
      final overflow = painter.size.width > box.maxWidth || painter.size.height > box.maxHeight;
      final String realText;
      if (overflow) {
        realText = weekdayHeader[0];
      } else {
        realText = name;
      }
      return realText
          .text(
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor),
          )
          .padOnly(t: 5, b: 5);
    });
  }
}
