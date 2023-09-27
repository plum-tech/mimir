import 'package:flutter/widgets.dart';
import 'package:mimir/design/animation/animated.dart';
import 'package:rettulf/rettulf.dart';

import '../../entity/display.dart';
import '../../entity/timetable.dart';
import '../../entity/pos.dart';
import '../../events.dart';
import 'daily.dart';
import 'header.dart';
import 'weekly.dart';

class TimetableBoard extends StatelessWidget {
  final SitTimetable timetable;

  final ValueNotifier<DisplayMode> $displayMode;

  final ValueNotifier<TimetablePos> $currentPos;
  final ScrollController? scrollController;

  const TimetableBoard({
    super.key,
    required this.timetable,
    required this.$displayMode,
    required this.$currentPos,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return [
      buildTimetableBody(context),
      buildTableHeader(context),
    ].stack();
  }

  Widget buildTimetableBody(BuildContext ctx) {
    return $displayMode >>
        (ctx, mode) => (mode == DisplayMode.daily
                    ? DailyTimetable(
                        $currentPos: $currentPos,
                        timetable: timetable,
                        scrollController: scrollController,
                      )
                    : WeeklyTimetable(
                        $currentPos: $currentPos,
                        timetable: timetable,
                        scrollController: scrollController,
                      ))
                .animatedSwitched(
              duration: const Duration(milliseconds: 300),
            );
  }

  Widget buildTableHeader(BuildContext ctx) {
    return $currentPos >>
        (ctx, cur) => TimetableHeader(
            currentWeek: cur.week,
            selectedDay: cur.day,
            startDate: timetable.startDate,
            onDayTap: (selectedDay) {
              if ($displayMode.value == DisplayMode.daily) {
                eventBus.fire(JumpToPosEvent(TimetablePos(week: cur.week, day: selectedDay)));
              } else {
                $currentPos.value = TimetablePos(week: cur.week, day: selectedDay);
              }
            });
  }
}
