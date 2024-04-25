import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file/open_file.dart';
import 'package:rettulf/rettulf.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/files.dart';
import 'package:sit/settings/settings.dart';

import "../i18n.dart";
import '../widgets/style.dart';
import '../widgets/timetable/background.dart';
import '../widgets/timetable/weekly.dart';
import '../entity/timetable_entity.dart';

typedef TimetableScreenshotConfig = ({
  String signature,
  bool grayOutTakenLessons,
  bool enableBackground,
});

class TimetableScreenshotConfigEditor extends StatefulWidget {
  final SitTimetableEntity timetable;
  final bool initialGrayOut;

  const TimetableScreenshotConfigEditor({
    super.key,
    required this.timetable,
    this.initialGrayOut = false,
  });

  @override
  State<TimetableScreenshotConfigEditor> createState() => _TimetableScreenshotConfigEditorState();
}

class _TimetableScreenshotConfigEditorState extends State<TimetableScreenshotConfigEditor> {
  late final $signature = TextEditingController(text: widget.timetable.signature);
  late bool grayOutTakenLessons = widget.initialGrayOut;
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
            buildGrayOut(),
            buildEnableBackground(),
          ]),
        ],
      ),
    );
  }

  Widget buildScreenshotAction() {
    return PlatformTextButton(
      child: i18n.screenshot.take.text(),
      onPressed: () async {
        Settings.lastSignature = $signature.text;
        context.pop<TimetableScreenshotConfig>((
          signature: $signature.text.trim(),
          grayOutTakenLessons: grayOutTakenLessons == true,
          enableBackground: enableBackground,
        ));
      },
    );
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

  Widget buildGrayOut() {
    return ListTile(
      leading: const Icon(Icons.timelapse),
      title: i18n.p13n.cell.grayOut.text(),
      subtitle: i18n.p13n.cell.grayOutDesc.text(),
      trailing: Switch.adaptive(
        value: grayOutTakenLessons == true,
        onChanged: (newV) {
          setState(() {
            grayOutTakenLessons = newV;
          });
        },
      ),
    );
  }

  Widget buildEnableBackground() {
    return ListTile(
      leading: const Icon(Icons.image_outlined),
      title: i18n.screenshot.enableBackground.text(),
      subtitle: i18n.screenshot.enableBackgroundDesc.text(),
      trailing: Switch.adaptive(
        value: enableBackground,
        onChanged: (newV) {
          setState(() {
            enableBackground = newV;
          });
        },
      ),
    );
  }
}

class TimetableWeeklyScreenshotFilm extends StatelessWidget {
  final TimetableScreenshotConfig config;
  final SitTimetableEntity timetable;
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
    if (config.enableBackground && background.enabled) {
      return [
        Positioned.fill(
          child: TimetableBackground(
            background: background,
            fade: false,
          ),
        ),
        buildBody(context, style),
      ].stack();
    }
    return buildBody(context, style);
  }

  Widget buildBody(BuildContext context, TimetableStyleData style) {
    final today = DateTime.now();
    return [
      buildTitle().text(style: context.textTheme.titleLarge).padSymmetric(v: 10),
      TimetableOneWeek(
        fullSize: fullSize,
        timetable: timetable,
        weekIndex: weekIndex,
        cellBuilder: ({required context, required lesson, required timetable}) {
          return StyledCourseCell(
            style: style,
            timetable: timetable,
            course: lesson.course,
            grayOut: config.grayOutTakenLessons ? lesson.type.endTime.isBefore(today) : false,
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

Future<void> takeTimetableScreenshot({
  required BuildContext context,
  required SitTimetableEntity timetable,
  required int weekIndex,
}) async {
  final config = await context.show$Sheet$<TimetableScreenshotConfig>(
    (ctx) => TimetableScreenshotConfigEditor(
      timetable: timetable,
      initialGrayOut: TimetableStyle.of(context).cellStyle.grayOutTakenLessons,
    ),
  );
  if (config == null) return;
  if (!context.mounted) return;
  var fullSize = context.mediaQuery.size;
  fullSize = Size(fullSize.width, fullSize.height);
  final screenshotController = ScreenshotController();
  final screenshot = await screenshotController.captureFromLongWidget(
    InheritedTheme.captureAll(
      context,
      ProviderScope(
        child: MediaQuery(
          data: MediaQueryData(size: fullSize),
          child: Material(
            child: TimetableStyleProv(
              child: TimetableWeeklyScreenshotFilm(
                config: config,
                timetable: timetable,
                weekIndex: weekIndex,
                fullSize: fullSize,
              ),
            ),
          ),
        ),
      ),
    ),
    delay: const Duration(milliseconds: 100),
    context: context,
    pixelRatio: View.of(context).devicePixelRatio,
  );
  final imgFi = Files.timetable.screenshotFile;
  await imgFi.writeAsBytes(screenshot);

  await OpenFile.open(imgFi.path, type: "image/png", uti: "public.png");
}
