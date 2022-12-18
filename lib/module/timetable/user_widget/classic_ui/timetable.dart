import 'package:flutter/widgets.dart';
import 'package:rettulf/rettulf.dart';

import '../../entity/course.dart';
import '../../entity/entity.dart';
import '../../using.dart';
import '../interface.dart';
import 'daily.dart';
import 'weekly.dart';

export 'daily.dart';
export 'weekly.dart';

class TimetableViewer extends StatefulWidget {
  final SitTimetable timetable;

  final ValueNotifier<DisplayMode> $displayMode;

  final ValueNotifier<TimetablePosition> $currentPos;

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
  /// 最大周数
  /// TODO 还没用上
  // static const int maxWeekCount = 20;
  SitTimetable get timetable => widget.timetable;

  @override
  void initState() {
    Log.info('TimetableViewer init');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildTimetableBody(context);
  }

  Widget buildTimetableBody(BuildContext ctx) {
    return widget.$displayMode <<
        (ctx, mode, _) => (mode == DisplayMode.daily
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
