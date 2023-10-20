import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/timetable/entity/background.dart';
import 'package:sit/timetable/widgets/style.dart';

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
    final style = TimetableStyle.of(context);
    final background = style.background;
    if (background != null) {
      return [
        buildBackground(background).center(),
        buildBoard(),
      ].stack();
    }
    return buildBoard();
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

  Widget buildBackground(BackgroundImage bk) {
    return Image.file(File(bk.path));
  }
}
