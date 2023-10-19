import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/settings/settings.dart';

import '../widgets/style.dart';
import '../i18n.dart';
import 'p13n.dart';

class TimetableCellStyleEditor extends StatefulWidget {
  const TimetableCellStyleEditor({super.key});

  @override
  State<TimetableCellStyleEditor> createState() => _TimetableCellStyleEditorState();
}

class _TimetableCellStyleEditorState extends State<TimetableCellStyleEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: i18n.p13n.cell.title.text(),
          ),
          SliverToBoxAdapter(
            child: TimetableStyleProv(
              builder: (ctx, style) {
                return TimetableP13nLivePreview(style: style.cell, palette: style.platte);
              },
            ),
          ),
          SliverList.list(children: [
            buildTeachersToggle(),
            buildGrayOutPassedLesson(),
            buildHarmonizeWithThemeColor(),
          ]),
        ],
      ),
    );
  }

  CourseCellStyle buildStyle() {
    return CourseCellStyle(
      showTeachers: Settings.timetable.cell.showTeachers,
      grayOutTakenLessons: Settings.timetable.cell.grayOutTakenLessons,
      harmonizeWithThemeColor: Settings.timetable.cell.harmonizeWithThemeColor,
    );
  }

  Widget buildTeachersToggle() {
    return ListTile(
      leading: const Icon(Icons.person_pin),
      title: i18n.p13n.cell.showTeachersTitle.text(),
      subtitle: i18n.p13n.cell.showTeachersDesc.text(),
      trailing: Switch.adaptive(
        value: Settings.timetable.cell.showTeachers,
        onChanged: (newV) {
          setState(() {
            Settings.timetable.cell.showTeachers = newV;
          });
        },
      ),
    );
  }

  Widget buildGrayOutPassedLesson() {
    return ListTile(
      leading: const Icon(Icons.timelapse),
      title: i18n.p13n.cell.grayOutTitle.text(),
      subtitle: i18n.p13n.cell.grayOutDesc.text(),
      trailing: Switch.adaptive(
        value: Settings.timetable.cell.grayOutTakenLessons,
        onChanged: (newV) {
          setState(() {
            Settings.timetable.cell.grayOutTakenLessons = newV;
          });
        },
      ),
    );
  }

  Widget buildHarmonizeWithThemeColor() {
    return ListTile(
      leading: const Icon(Icons.format_color_fill),
      title: i18n.p13n.cell.harmonizeTitle.text(),
      subtitle: i18n.p13n.cell.harmonizeDesc.text(),
      trailing: Switch.adaptive(
        value: Settings.timetable.cell.harmonizeWithThemeColor,
        onChanged: (newV) {
          setState(() {
            Settings.timetable.cell.harmonizeWithThemeColor = newV;
          });
        },
      ),
    );
  }
}
