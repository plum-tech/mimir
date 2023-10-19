import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

import '../entity/display.dart';
import '../entity/timetable.dart';
import '../widgets/style.dart';
import '../entity/pos.dart';
import '../widgets/timetable/board.dart';

class TimetablePreviewPage extends StatefulWidget {
  final SitTimetable timetable;
  final TimetableStyleData? style;

  const TimetablePreviewPage({
    super.key,
    required this.timetable,
    this.style,
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
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded),
            onPressed: () {
              $displayMode.value = $displayMode.value.toggle();
            },
          )
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final style = widget.style;
    if (style != null) {
      return TimetableStyle(data: style, child: buildBoard());
    } else {
      return TimetableStyleProv(builder: (ctx, style) => buildBoard());
    }
  }

  Widget buildBoard() {
    return TimetableBoard(
      timetable: timetable,
      $displayMode: $displayMode,
      $currentPos: $currentPos,
    );
  }
}
