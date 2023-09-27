import 'package:flutter/widgets.dart';
import 'package:mimir/design/animation/animated.dart';
import 'package:rettulf/rettulf.dart';

import '../../entity/display.dart';
import '../../entity/pos.dart';
import '../../entity/timetable.dart';
import 'daily.dart';
import 'weekly.dart';

class TimetableBoard extends StatelessWidget {
  final ScrollController? scrollController;
  final SitTimetable timetable;

  final ValueNotifier<DisplayMode> $displayMode;

  final ValueNotifier<TimetablePos> $currentPos;

  const TimetableBoard({
    super.key,
    required this.timetable,
    required this.$displayMode,
    required this.$currentPos,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
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
}
