import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/entity/platte.dart';
import 'package:sit/timetable/platte.dart';
import 'package:sit/timetable/widgets/timetable/weekly.dart';
import 'package:sit/utils/color.dart';

import '../widgets/style.dart';
import '../i18n.dart';

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
                return TimetableCellStylePreview(style: style.cell, palette: style.platte);
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

class TimetableCellStylePreview extends StatelessWidget {
  final CourseCellStyle style;
  final TimetablePalette palette;

  const TimetableCellStylePreview({
    required this.style,
    required this.palette,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, box) {
      final height = box.maxHeight.isFinite ? box.maxHeight : context.mediaQuery.size.height / 2;
      return buildView(context, fullSize: Size(box.maxWidth, height));
    });
  }

  Widget buildView(
    BuildContext context, {
    required Size fullSize,
  }) {
    final cellSize = Size(fullSize.width / 5, fullSize.height / 3);
    final themeColor = context.colorScheme.primary;
    Widget buildCell({
      required int id,
      required String name,
      required String place,
      required List<String> teachers,
      bool grayOut = false,
    }) {
      var color = palette.safeGetColor(id).byTheme(context.theme);
      if (style.harmonizeWithThemeColor) {
        color = color.harmonizeWith(themeColor);
      }
      if (grayOut) {
        color = color.monochrome();
      }
      return SizedBox.fromSize(
        size: cellSize,
        child: TweenAnimationBuilder(
          tween: ColorTween(begin: color, end: color),
          duration: const Duration(milliseconds: 300),
          builder: (ctx, value, child) => CourseCell(
            courseName: name,
            color: value!,
            place: place,
            teachers: style.showTeachers ? teachers : null,
          ),
        ),
      );
    }

    Widget livePreview(int index, {bool grayOut = false}) {
      final data = i18n.p13n.cell.livePreview(index);
      return buildCell(
        id: index,
        name: data.name,
        place: data.place,
        teachers: data.teachers,
        grayOut: grayOut,
      );
    }

    final grayOut = style.grayOutTakenLessons;
    return [
      livePreview(0, grayOut: grayOut),
      livePreview(1, grayOut: grayOut),
      livePreview(2),
      livePreview(3),
    ].row(maa: MainAxisAlignment.spaceEvenly);
  }
}

class TimetableEditCellStyleTile extends StatelessWidget {
  const TimetableEditCellStyleTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.style_outlined),
      title: i18n.p13n.cell.entranceTitle.text(),
      subtitle: i18n.p13n.cell.entranceDesc.text(),
      trailing: const Icon(Icons.open_in_new),
      onTap: () async {
        await context.show$Sheet$((ctx) => const TimetableCellStyleEditor());
      },
    );
  }
}
