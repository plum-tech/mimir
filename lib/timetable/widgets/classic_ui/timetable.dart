import 'package:flutter/widgets.dart';
import 'package:mimir/design/animation/animated.dart';
import 'package:rettulf/rettulf.dart';

import '../../entity/course.dart';
import '../../entity/entity.dart';
import '../../entity/pos.dart';
import 'daily.dart';
import 'weekly.dart';

export 'daily.dart';
export 'weekly.dart';

class TimetableViewer extends StatefulWidget {
  final SitTimetable timetable;

  final ValueNotifier<DisplayMode> $displayMode;

  final ValueNotifier<TimetablePos> $currentPos;

  const TimetableViewer({
    required this.timetable,
    required this.$displayMode,
    required this.$currentPos,
    super.key,
  });

  @override
  State<TimetableViewer> createState() => _TimetableViewerState();
}

class _TimetableViewerState extends State<TimetableViewer> {
  SitTimetable get timetable => widget.timetable;

  @override
  Widget build(BuildContext context) {
    return buildTimetableBody(context);
  }

  Widget buildTimetableBody(BuildContext ctx) {
    return widget.$displayMode >>
        (ctx, mode) => (mode == DisplayMode.daily
                    ? DailyTimetable(
                        $currentPos: widget.$currentPos,
                        timetable: timetable,
                      )
                    : WeeklyTimetable(
                        $currentPos: widget.$currentPos,
                        timetable: timetable,
                      ))
                .animatedSwitched(
              d: const Duration(milliseconds: 300),
            );
  }
}
