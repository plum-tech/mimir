import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/backend/stats/utils/stats.dart';
import 'package:mimir/design/widget/task_builder.dart';
import 'package:mimir/feature/feature.dart';
import 'package:mimir/timetable/widget/timetable/header.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/utils/screenshot.dart';

import "../i18n.dart";
import '../p13n/widget/style.dart';
import '../p13n/widget/wallpaper.dart';
import '../widget/timetable/weekly.dart';
import '../entity/timetable_entity.dart';

typedef TimetableScreenshotConfig = ({
  String signature,
  bool grayOutTakenLessons,
  bool enableBackground,
});

class TimetableScreenshotPage extends StatefulWidget {
  final TimetableEntity timetable;
  final int weekIndex;

  const TimetableScreenshotPage({
    super.key,
    required this.timetable,
    required this.weekIndex,
  });

  @override
  State<TimetableScreenshotPage> createState() => _TimetableScreenshotPageState();
}

class _TimetableScreenshotPageState extends State<TimetableScreenshotPage> {
  late final $signature = TextEditingController(text: widget.timetable.signature);
  late bool grayOutTakenLessons = Settings.timetable.cellStyle?.grayOutTakenLessons ?? false;
  var enableBackground = true;

  @override
  void dispose() {
    $signature.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: i18n.screenshot.title.text(),
            actions: [
              buildScreenshotAction(),
            ],
          ),
          SliverList.list(children: [
            buildSignatureInput(),
            buildGrayOutTakenLessons(),
            buildEnableBackground(),
          ]),
        ],
      ),
    );
  }

  Widget buildScreenshotAction() {
    return TaskBuilder(
      task: takeScreenshot,
      builder: (context, task, running) {
        return PlatformTextButton(
          onPressed: task,
          child: i18n.screenshot.take.text(),
        );
      },
    );
  }

  Future<void> takeScreenshot() async {
    Stats.feature(AppFeature.timetableScreenshot);
    final weekIndex = widget.weekIndex;
    final timetable = widget.timetable;
    final config = (
      signature: $signature.text.trim(),
      grayOutTakenLessons: grayOutTakenLessons == true,
      enableBackground: enableBackground,
    );
    Settings.lastSignature = $signature.text;
    final fi = await takeWidgetScreenshot(
      context: context,
      name: 'timetable.png',
      child: Builder(
        builder: (ctx) => Material(
          child: TimetableStyleProv(
            child: TimetableWeeklyScreenshotFilm(
              config: config,
              timetable: timetable,
              weekIndex: weekIndex,
              fullSize: ctx.mediaQuery.size,
            ),
          ),
        ),
      ),
    );

    await onScreenshotTaken(fi.path);
    if (!mounted) return;
    context.pop();
  }

  Widget buildSignatureInput() {
    return ListTile(
      isThreeLine: true,
      leading: const Icon(Icons.drive_file_rename_outline),
      title: i18n.signature.text(),
      subtitle: TextField(
        controller: $signature,
        decoration: InputDecoration(
          hintText: i18n.signaturePlaceholder,
        ),
      ),
    );
  }

  Widget buildGrayOutTakenLessons() {
    return SwitchListTile.adaptive(
      secondary: const Icon(Icons.timelapse),
      title: i18n.p13n.cell.grayOut.text(),
      subtitle: i18n.p13n.cell.grayOutDesc.text(),
      value: grayOutTakenLessons == true,
      onChanged: (newV) {
        setState(() {
          grayOutTakenLessons = newV;
        });
      },
    );
  }

  Widget buildEnableBackground() {
    return SwitchListTile.adaptive(
      secondary: const Icon(Icons.image_outlined),
      title: i18n.screenshot.enableBackground.text(),
      subtitle: i18n.screenshot.enableBackgroundDesc.text(),
      value: enableBackground,
      onChanged: (newV) {
        setState(() {
          enableBackground = newV;
        });
      },
    );
  }
}

class TimetableWeeklyScreenshotFilm extends StatelessWidget {
  final TimetableScreenshotConfig config;
  final TimetableEntity timetable;
  final int weekIndex;
  final Size fullSize;

  const TimetableWeeklyScreenshotFilm({
    super.key,
    required this.timetable,
    required this.weekIndex,
    required this.fullSize,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final style = TimetableStyle.of(context);
    final background = style.background;
    if (config.enableBackground) {
      return WithWallpaper(
        background: background,
        fade: false,
        child: buildBody(context, style),
      );
    }
    return buildBody(context, style);
  }

  Widget buildBody(BuildContext context, TimetableStyleData style) {
    return [
      Card.filled(
        color: getTimetableHeaderColor(context),
        child: buildTitle().text(style: context.textTheme.titleLarge).padAll(8),
      ).padSymmetric(v: 4),
      TimetableOneWeek(
        fullSize: fullSize,
        timetable: timetable,
        weekIndex: weekIndex,
        cellBuilder: ({required context, required lesson, required timetable}) {
          return StyledCourseCell(
            style: style,
            timetable: timetable,
            course: lesson.course,
            isLessonTaken: lesson.type.endTime.isBefore(DateTime.now()),
          );
        },
      ),
    ].column();
  }

  String buildTitle() {
    final week = i18n.weekOrderedName(number: weekIndex + 1);
    final signature = config.signature;
    if (signature.isNotEmpty) {
      return "$signature $week";
    }
    return week;
  }
}
