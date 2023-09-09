import 'package:flutter/widgets.dart';
import 'package:mimir/design/animation/animated.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/course.dart';
import '../entity/pos.dart';
import '../entity/timetable.dart';
import "classic_ui/daily.dart" as classic_daily;
import "classic_ui/weekly.dart" as classic_weekly;
import "new_ui/daily.dart" as new_daily;
import "new_ui/weekly.dart" as new_weekly;
import 'style.dart';

class TimetableViewer extends StatefulWidget {
  final ScrollController? scrollController;
  final SitTimetable timetable;

  final ValueNotifier<DisplayMode> $displayMode;

  final ValueNotifier<TimetablePos> $currentPos;

  const TimetableViewer({
    required this.timetable,
    required this.$displayMode,
    required this.$currentPos,
    super.key,
    this.scrollController,
  });

  @override
  State<TimetableViewer> createState() => _TimetableViewerState();
}

class _TimetableViewerState extends State<TimetableViewer> {
  SitTimetable get timetable => widget.timetable;

  @override
  Widget build(BuildContext context) {
    if (TimetableStyle.of(context).useNewUI) {
      return widget.$displayMode >>
          (ctx, mode) => (mode == DisplayMode.daily
                      ? new_daily.DailyTimetable(
                          scrollController: widget.scrollController,
                          $currentPos: widget.$currentPos,
                          timetable: timetable,
                        )
                      : new_weekly.WeeklyTimetable(
                          scrollController: widget.scrollController,
                          $currentPos: widget.$currentPos,
                          timetable: timetable,
                        ))
                  .animatedSwitched(
                d: const Duration(milliseconds: 300),
              );
    } else {
      return widget.$displayMode >>
          (ctx, mode) => (mode == DisplayMode.daily
                      ? classic_daily.DailyTimetable(
                          scrollController: widget.scrollController,
                          $currentPos: widget.$currentPos,
                          timetable: timetable,
                        )
                      : classic_weekly.WeeklyTimetable(
                          scrollController: widget.scrollController,
                          $currentPos: widget.$currentPos,
                          timetable: timetable,
                        ))
                  .animatedSwitched(
                d: const Duration(milliseconds: 300),
              );
    }
  }
}
