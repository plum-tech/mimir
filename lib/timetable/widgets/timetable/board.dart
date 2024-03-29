import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/files.dart';
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
    if (background.enabled) {
      return [
        Positioned.fill(
          child: TimetableBackground(background: background),
        ),
        buildBoard(),
      ].stack();
    }
    return buildBoard();
  }

  Widget buildBoard() {
    return $displayMode >>
        (ctx, mode) => AnimatedSwitcher(
              duration: Durations.short4,
              child: mode == DisplayMode.daily
                  ? DailyTimetable(
                      $currentPos: $currentPos,
                      timetable: timetable,
                    )
                  : WeeklyTimetable(
                      $currentPos: $currentPos,
                      timetable: timetable,
                    ),
            );
  }
}

class TimetableBackground extends StatefulWidget {
  final BackgroundImage background;

  const TimetableBackground({
    super.key,
    required this.background,
  });

  @override
  State<TimetableBackground> createState() => _TimetableBackgroundState();
}

class _TimetableBackgroundState extends State<TimetableBackground> with SingleTickerProviderStateMixin {
  late final AnimationController $opacity;

  @override
  void initState() {
    super.initState();
    $opacity = AnimationController(vsync: this, value: 0);
  }

  @override
  void dispose() {
    $opacity.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TimetableBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    $opacity.animateTo(
      widget.background.opacity,
      duration: Durations.medium1,
    );
  }

  @override
  void didChangeDependencies() {
    $opacity.animateTo(
      widget.background.opacity,
      duration: Durations.medium1,
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bk = widget.background;
    return Image.file(
      key: ValueKey(bk.path),
      Files.timetable.backgroundFile,
      opacity: $opacity,
      filterQuality: bk.antialias ? FilterQuality.low : FilterQuality.none,
      repeat: bk.repeat ? ImageRepeat.repeat : ImageRepeat.noRepeat,
    );
  }
}
