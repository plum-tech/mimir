import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/timetable/entity/timetable.dart';
import "../i18n.dart";
import '../widgets/style.dart';
import '../widgets/timetable/weekly.dart';

typedef TimetableScreenshotConfig = ({
  String signature,
  bool grayOutPassedLessons,
});

class TimetableScreenshotConfigEditor extends StatefulWidget {
  final SitTimetableEntity timetable;
  final bool initialGrayOutPassedLessons;

  const TimetableScreenshotConfigEditor({
    super.key,
    required this.timetable,
    this.initialGrayOutPassedLessons = false,
  });

  @override
  State<TimetableScreenshotConfigEditor> createState() => _TimetableScreenshotConfigEditorState();
}

class _TimetableScreenshotConfigEditorState extends State<TimetableScreenshotConfigEditor> {
  final $signature = TextEditingController(text: "");
  late bool grayOutPassedLessons = widget.initialGrayOutPassedLessons;

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
            buildGrayOutPassedLessons(),
          ]),
        ],
      ),
    );
  }

  Widget buildScreenshotAction() {
    return CupertinoButton(
      child: i18n.screenshot.screenshot.text(),
      onPressed: () async {
        context.pop<TimetableScreenshotConfig>((
          signature: $signature.text.trim(),
          grayOutPassedLessons: grayOutPassedLessons == true,
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

  Widget buildGrayOutPassedLessons() {
    return ListTile(
      leading: const Icon(Icons.timelapse),
      title: "Gray out passed lessons".text(),
      subtitle: "Before today".text(),
      trailing: Switch.adaptive(
        value: grayOutPassedLessons == true,
        onChanged: (newV) {
          setState(() {
            grayOutPassedLessons = newV;
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
    final cellStyle = TimetableStyle.of(context).cell;
    final today = DateTime.now();
    return [
      buildTitle().text(style: context.textTheme.titleLarge).padSymmetric(v: 10),
      TimetableOneWeek(
        fullSize: fullSize,
        timetable: timetable,
        weekIndex: weekIndex,
        cellBuilder: ({required context, required lesson, required course, required timetable}) {
          return CourseCell(
            lesson: lesson,
            course: course,
            style: cellStyle,
            grayOut: config.grayOutPassedLessons ? lesson.endTime.isBefore(today) : false,
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
