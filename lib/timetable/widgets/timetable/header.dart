import 'package:flutter/material.dart';
import 'package:sit/l10n/time.dart';
import 'package:sit/school/entity/format.dart';
import 'package:rettulf/rettulf.dart';

BorderSide getTimetableBorderSide(BuildContext ctx) =>
    BorderSide(color: ctx.colorScheme.primary.withOpacity(0.4), width: 0.8);

class TimetableHeader extends StatelessWidget {
  final int weekIndex;
  final Weekday? selectedWeekday;
  final Function(Weekday dayIndex)? onDayTap;
  final DateTime startDate;

  const TimetableHeader({
    super.key,
    required this.weekIndex,
    required this.startDate,
    this.selectedWeekday,
    this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final onDayTap = this.onDayTap;

    return Weekday.monday
        .genSequenceStartWithThis()
        .map((weekday) {
          return Expanded(
            child: InkWell(
              onTap: onDayTap != null
                  ? () {
                      onDayTap.call(weekday);
                    }
                  : null,
              child: HeaderCell(
                weekIndex: weekIndex,
                weekday: weekday,
                startDate: startDate,
                backgroundColor: weekday == selectedWeekday ? context.colorScheme.secondaryContainer : null,
              ),
            ),
          );
        })
        .toList()
        .row(maa: MainAxisAlignment.spaceEvenly);
  }
}

class HeaderCell extends StatelessWidget {
  final int weekIndex;
  final Weekday weekday;
  final DateTime startDate;
  final Color? backgroundColor;

  const HeaderCell({
    super.key,
    required this.weekIndex,
    required this.weekday,
    required this.startDate,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final side = getTimetableBorderSide(context);
    return AnimatedContainer(
      duration: Durations.short2,
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(bottom: side),
      ),
      child: HeaderCellTextBox(
        weekIndex: weekIndex,
        weekday: weekday,
        startDate: startDate,
      ),
    );
  }
}

class HeaderCellTextBox extends StatelessWidget {
  final int weekIndex;
  final Weekday weekday;
  final DateTime startDate;

  const HeaderCellTextBox({
    super.key,
    required this.weekIndex,
    required this.weekday,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    final date = reflectWeekDayIndexToDate(
      weekIndex: weekIndex,
      weekday: weekday,
      startDate: startDate,
    );
    return [
      weekday.l10nShort().text(
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
