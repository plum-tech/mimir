import 'package:flutter/widgets.dart';

import '../entity/display.dart';
import '../entity/pos.dart';
import '../entity/timetable.dart';
import "classic_ui/board.dart" as classic_ui;
import "new_ui/board.dart" as new_ui;
import 'style.dart';

class TimetableViewer extends StatelessWidget {
  final ScrollController? scrollController;
  final SitTimetable timetable;

  final ValueNotifier<DisplayMode> $displayMode;

  final ValueNotifier<TimetablePos> $currentPos;

  const TimetableViewer({
    super.key,
    required this.timetable,
    required this.$displayMode,
    required this.$currentPos,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (TimetableStyle.of(context).useNewUI) {
      return new_ui.TimetableViewer(
        timetable: timetable,
        $displayMode: $displayMode,
        $currentPos: $currentPos,
        scrollController: scrollController,
      );
    } else {
      return classic_ui.TimetableViewer(
        timetable: timetable,
        $displayMode: $displayMode,
        $currentPos: $currentPos,
        scrollController: scrollController,
      );
    }
  }
}
