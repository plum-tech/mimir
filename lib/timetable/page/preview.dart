import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:text_scroll/text_scroll.dart';

import '../entity/display.dart';
import '../entity/timetable.dart';
import '../entity/timetable_entity.dart';
import '../entity/pos.dart';
import '../widgets/timetable/board.dart';

class TimetablePreviewPage extends StatefulWidget {
  final SitTimetable timetable;

  const TimetablePreviewPage({
    super.key,
    required this.timetable,
  });

  @override
  State<StatefulWidget> createState() => _TimetablePreviewPageState();
}

class _TimetablePreviewPageState extends State<TimetablePreviewPage> {
  final $displayMode = ValueNotifier(DisplayMode.weekly);
  late final $currentPos = ValueNotifier(widget.timetable.locate(DateTime.now()));
  final scrollController = ScrollController();
  late SitTimetableEntity timetable;

  @override
  void dispose() {
    $displayMode.dispose();
    $currentPos.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    timetable = widget.timetable.resolve();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextScroll(widget.timetable.name),
        actions: [
          PlatformIconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: () {
              $displayMode.value = $displayMode.value.toggle();
            },
          )
        ],
      ),
      body: TimetableBoard(
        timetable: timetable,
        $displayMode: $displayMode,
        $currentPos: $currentPos,
      ),
    );
  }
}
