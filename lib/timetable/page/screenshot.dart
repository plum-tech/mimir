import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/timetable/entity/timetable.dart';
import "../i18n.dart";
import '../widgets/timetable/weekly.dart';

typedef TimetableScreenshotConfig = ({
  String signature,
});

class TimetableScreenshotConfigEditor extends StatefulWidget {
  final SitTimetableEntity timetable;

  const TimetableScreenshotConfigEditor({
    super.key,
    required this.timetable,
  });

  @override
  State<TimetableScreenshotConfigEditor> createState() => _TimetableScreenshotConfigEditorState();
}

class _TimetableScreenshotConfigEditorState extends State<TimetableScreenshotConfigEditor> {
  final $signature = TextEditingController(text: "");

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
          SliverAppBar(
            floating: true,
            title: i18n.screenshot.title.text(),
            actions: [
              buildScreenshotAction(),
            ],
          ),
          SliverList.list(children: [
            buildSignatureInput(),
          ]),
        ],
      ),
    );
  }

  Widget buildScreenshotAction() {
    return CupertinoButton(
      child: i18n.screenshot.screenshot.text(),
      onPressed: () async {
        context.pop<TimetableScreenshotConfig>((signature: $signature.text.trim(),));
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
