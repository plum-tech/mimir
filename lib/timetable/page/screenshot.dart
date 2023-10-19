import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/timetable/entity/timetable.dart';
import "../i18n.dart";
import '../widgets/style.dart';
import '../widgets/timetable/weekly.dart';

typedef TimetableScreenshotConfig = ({
  String signature,
  bool grayOutTakenLessons,
});

class TimetableScreenshotConfigEditor extends StatefulWidget {
  final SitTimetableEntity timetable;
  final bool initialGrayOutTakenLessons;

  const TimetableScreenshotConfigEditor({
    super.key,
    required this.timetable,
    this.initialGrayOutTakenLessons = false,
  });

  @override
  State<TimetableScreenshotConfigEditor> createState() => _TimetableScreenshotConfigEditorState();
}

class _TimetableScreenshotConfigEditorState extends State<TimetableScreenshotConfigEditor> {
  final $signature = TextEditingController(text: "");
  late bool grayOutTakenLessons = widget.initialGrayOutTakenLessons;

  @override
  void dispose() {
    $signature.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: i18n.screenshot.title.text(),
            actions: [
              buildScreenshotAction(),
            ],
          ),
          SliverList.list(children: [
            buildSignatureInput(),
            buildGrayOutTakenLessons(),
          ]),
        ],
      ),
    );
  }

  Widget buildScreenshotAction() {
    return PlatformTextButton(
      child: i18n.screenshot.screenshot.text(),
      onPressed: () async {
        context.pop<TimetableScreenshotConfig>((
          signature: $signature.text.trim(),
          grayOutTakenLessons: grayOutTakenLessons == true,
        ));
      },
    );
  }

  Widget buildSignatureInput() {
    return ListTile(
      isThreeLine: true,
      leading: const Icon(Icons.drive_file_rename_outline),
      title: i18n.screenshot.signature.text(),
      subtitle: TextField(
        controller: $signature,
        decoration: InputDecoration(
          hintText: i18n.screenshot.signaturePlaceholder,
        ),
      ),
    );
  }

  Widget buildGrayOutTakenLessons() {
    return ListTile(
      leading: const Icon(Icons.timelapse),
      title: i18n.p13n.cell.grayOutTitle.text(),
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
    final today = DateTime.now();
    final style = TimetableStyle.of(context);
    return [
      buildTitle().text(style: context.textTheme.titleLarge).padSymmetric(v: 10),
      TimetableOneWeek(
        fullSize: fullSize,
        timetable: timetable,
        weekIndex: weekIndex,
        cellBuilder: ({required context, required lesson, required timetable}) {
          return StyledCourseCell(
            style: style,
            course: lesson.course,
            grayOut: config.grayOutTakenLessons ? lesson.endTime.isBefore(today) : false,
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
