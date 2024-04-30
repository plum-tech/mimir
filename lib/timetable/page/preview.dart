import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:text_scroll/text_scroll.dart';

import '../entity/display.dart';
import '../entity/timetable.dart';
import '../entity/timetable_entity.dart';
import '../entity/pos.dart';
import '../widgets/style.dart';
import '../widgets/timetable/board.dart';

class TimetablePreviewPage extends StatefulWidget {
  final SitTimetable? timetable;
  final SitTimetableEntity? entity;

  const TimetablePreviewPage({
    super.key,
    this.timetable,
    this.entity,
  });

  @override
  State<StatefulWidget> createState() => _TimetablePreviewPageState();
}

class _TimetablePreviewPageState extends State<TimetablePreviewPage> {
  SitTimetable get timetable => widget.timetable ?? widget.entity!.type;

  final $displayMode = ValueNotifier(DisplayMode.weekly);
  late final $currentPos = ValueNotifier(timetable.locate(DateTime.now()));
  final scrollController = ScrollController();
  late SitTimetableEntity entity = widget.entity ?? timetable.resolve();

  @override
  void dispose() {
    $displayMode.dispose();
    $currentPos.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TimetablePreviewPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.timetable != oldWidget.timetable || widget.entity != oldWidget.entity) {
      entity = widget.entity ?? timetable.resolve();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextScroll(timetable.name),
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
        timetable: entity,
        $displayMode: $displayMode,
        $currentPos: $currentPos,
      ),
    );
  }
}

Future<void> previewTimetable(
  BuildContext context, {
  SitTimetable? timetable,
  SitTimetableEntity? entity,
}) async {
  assert(timetable != null || entity != null);
  await context.showSheet(
    (context) => TimetableStyleProv(
      child: TimetablePreviewPage(
        timetable: timetable,
        entity: entity,
      ),
    ),
  );
}
