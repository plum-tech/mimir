import 'package:flutter/material.dart';

import '../entity/course.dart';
import '../entity/entity.dart';
import '../user_widget/style.dart';
import '../user_widget/interface.dart';
import '../using.dart';
import '../user_widget/new_ui/timetable.dart' as new_ui;
import '../user_widget/classic_ui/timetable.dart' as classic_ui;

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
  late final ValueNotifier<TimetablePosition> $currentPos = ValueNotifier(
    TimetablePosition.locate(widget.timetable.startDate, DateTime.now()),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${i18n.timetablePreviewTitle} ${widget.timetable.name}',
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
