import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/course.dart';
import '../entity/timetable.dart';
import '../widgets/style.dart';
import '../entity/pos.dart';
import '../widgets/new_ui/timetable.dart' as new_ui;
import '../widgets/classic_ui/timetable.dart' as classic_ui;

///
/// There is no need to persist a preview after activity destroyed.
class TimetablePreviewPage extends StatefulWidget {
  final SitTimetable timetable;

  const TimetablePreviewPage({super.key, required this.timetable});

  @override
  State<StatefulWidget> createState() => _TimetablePreviewPageState();
}

class _TimetablePreviewPageState extends State<TimetablePreviewPage> {
  final ValueNotifier<DisplayMode> $displayMode = ValueNotifier(DisplayMode.weekly);
  late final ValueNotifier<TimetablePos> $currentPos = ValueNotifier(widget.timetable.locate(DateTime.now()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: widget.timetable.name.text(
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.swap_horiz_rounded),
              onPressed: () {
                $displayMode.value = $displayMode.value.toggle();
              },
            )
          ],
        ),
        body: TimetableStyleProv(
          builder: (ctx) => buildBody(ctx),
        ));
  }

  Widget buildBody(BuildContext ctx) {
    if (TimetableStyle.of(ctx).useNewUI) {
      return new_ui.TimetableViewer(
        timetable: widget.timetable,
        $currentPos: $currentPos,
        $displayMode: $displayMode,
      );
    } else {
      return classic_ui.TimetableViewer(
        timetable: widget.timetable,
        $currentPos: $currentPos,
        $displayMode: $displayMode,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    $displayMode.dispose();
    $currentPos.dispose();
  }
}
