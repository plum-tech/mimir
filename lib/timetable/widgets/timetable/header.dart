import 'package:flutter/material.dart';
import 'package:sit/school/entity/school.dart';
import 'package:rettulf/rettulf.dart';

import '../../i18n.dart';

BorderSide getBorderSide(BuildContext ctx) => BorderSide(color: ctx.colorScheme.primary.withOpacity(0.4), width: 0.8);

class TimetableHeader extends StatelessWidget {
  final int weekIndex;
  final int? selectedDayIndex;
  final Function(int dayIndex)? onDayTap;
  final DateTime startDate;

  const TimetableHeader({
    super.key,
    required this.weekIndex,
    required this.startDate,
    this.selectedDayIndex,
    this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final onDayTap = this.onDayTap;
    return [
      for (int dayIndex = 0; dayIndex < 7; dayIndex++)
        Expanded(
          child: InkWell(
            onTap: onDayTap != null
                ? () {
                    onDayTap.call(dayIndex);
                  }
                : null,
            child: HeaderCell(
              weekIndex: weekIndex,
              dayIndex: dayIndex,
              startDate: startDate,
              backgroundColor: dayIndex == selectedDayIndex ? context.colorScheme.secondaryContainer : null,
            ),
          ),
        ),
    ].row(maa: MainAxisAlignment.spaceEvenly);
  }
}

class HeaderCell extends StatelessWidget {
  final int weekIndex;
  final int dayIndex;
  final DateTime startDate;
  final Color? backgroundColor;

  const HeaderCell({
    super.key,
    required this.weekIndex,
    required this.dayIndex,
    required this.startDate,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final side = getBorderSide(context);
    return AnimatedContainer(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(bottom: side),
      ),
      duration: const Duration(milliseconds: 100),
      child: HeaderCellTextBox(
        weekIndex: weekIndex,
        dayIndex: dayIndex,
        startDate: startDate,
      ),
    );
  }
}

class HeaderCellTextBox extends StatelessWidget {
  final int weekIndex;
  final int dayIndex;
  final DateTime startDate;

  const HeaderCellTextBox({
    super.key,
    required this.weekIndex,
    required this.dayIndex,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    final date = reflectWeekDayIndexToDate(weekIndex: weekIndex, dayIndex: dayIndex, startDate: startDate);
    return [
      i18n.weekdayShort(index: dayIndex).text(
            textAlign: TextAlign.center,
            style: context.textTheme.titleSmall,
          ),
      '${date.month}/${date.day}'.text(
        textAlign: TextAlign.center,
        style: context.textTheme.labelSmall,
      ),
    ].column().padOnly(t: 5, b: 5);
  }
}

class EmptyHeaderCellTextBox extends StatelessWidget {
  const EmptyHeaderCellTextBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return [
      "".text(
        textAlign: TextAlign.center,
        style: context.textTheme.titleSmall,
      ),
      "".text(
        textAlign: TextAlign.center,
        style: context.textTheme.labelSmall,
      ),
    ].column().padOnly(t: 5, b: 5);
  }
}
