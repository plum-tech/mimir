import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../../entity/display.dart';
import '../../entity/pos.dart';
import '../../entity/timetable.dart';
import 'daily.dart';
import 'weekly.dart';

class TimetableBoard extends StatelessWidget {
  final SitTimetableEntity timetable;

  final ValueNotifier<DisplayMode> $displayMode;

  final ValueNotifier<TimetablePos> $currentPos;

  const TimetableBoard({
    super.key,
    required this.timetable,
    required this.$displayMode,
    required this.$currentPos,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: background
    return buildBoard();
    return [
      FlutterLogo(size: 512).center(),
      buildBoard(),
    ].stack();
  }

  Widget buildBoard() {
    return $displayMode >>
        (ctx, mode) => mode == DisplayMode.daily
            ? DailyTimetable(
                $currentPos: $currentPos,
                timetable: timetable,
              )
            : WeeklyTimetable(
                $currentPos: $currentPos,
                timetable: timetable,
              );
  }
}
