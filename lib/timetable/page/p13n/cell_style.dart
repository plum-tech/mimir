import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/settings/settings.dart';

import '../../entity/cell_style.dart';
import '../../widgets/style.dart';
import '../../i18n.dart';
import 'palette.dart';

class TimetableCellStyleEditor extends StatefulWidget {
  const TimetableCellStyleEditor({super.key});

  @override
  State<TimetableCellStyleEditor> createState() => _TimetableCellStyleEditorState();
}

class _TimetableCellStyleEditorState extends State<TimetableCellStyleEditor> {
  var cellStyle = Settings.timetable.cellStyle ?? const CourseCellStyle();

  @override
  Widget build(BuildContext context) {
    final old = Settings.timetable.cellStyle;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: i18n.p13n.cell.title.text(),
            actions: [
              PlatformTextButton(
                onPressed: old == buildCellStyle() ? null : onSave,
                child: i18n.save.text(),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: TimetableStyleProv(
              cellStyle: buildCellStyle(),
              child: const TimetableP13nLivePreview(),
            ),
          ),
          SliverList.list(children: [
            buildTeachersToggle(),
            buildGrayOutPassedLesson(),
            buildHarmonizeWithThemeColor(),
            buildAlpha(),
          ]),
        ],
      ),
    );
  }

  void onSave() {
    final cellStyle = buildCellStyle();
    Settings.timetable.cellStyle = cellStyle;
    if (!mounted) return;
    context.pop(cellStyle);
  }

  CourseCellStyle buildCellStyle() {
    return CourseCellStyle(
      showTeachers: cellStyle.showTeachers,
      grayOutTakenLessons: cellStyle.grayOutTakenLessons,
      harmonizeWithThemeColor: cellStyle.harmonizeWithThemeColor,
      alpha: cellStyle.alpha,
    );
  }

  Widget buildTeachersToggle() {
    return ListTile(
      leading: const Icon(Icons.person_pin),
      title: i18n.p13n.cell.showTeachers.text(),
      subtitle: i18n.p13n.cell.showTeachersDesc.text(),
      trailing: Switch.adaptive(
        value: cellStyle.showTeachers,
        onChanged: (newV) {
          setState(() {
            cellStyle = cellStyle.copyWith(showTeachers: newV);
          });
        },
      ),
    );
  }

  Widget buildGrayOutPassedLesson() {
    return ListTile(
      leading: const Icon(Icons.timelapse),
      title: i18n.p13n.cell.grayOut.text(),
      subtitle: i18n.p13n.cell.grayOutDesc.text(),
      trailing: Switch.adaptive(
        value: cellStyle.grayOutTakenLessons,
        onChanged: (newV) {
          setState(() {
            cellStyle = cellStyle.copyWith(grayOutTakenLessons: newV);
          });
        },
      ),
    );
  }

  Widget buildHarmonizeWithThemeColor() {
    return ListTile(
      leading: const Icon(Icons.format_color_fill),
      title: i18n.p13n.cell.harmonize.text(),
      subtitle: i18n.p13n.cell.harmonizeDesc.text(),
      trailing: Switch.adaptive(
        value: cellStyle.harmonizeWithThemeColor,
        onChanged: (newV) {
          setState(() {
            cellStyle = cellStyle.copyWith(harmonizeWithThemeColor: newV);
          });
        },
      ),
    );
  }

  Widget buildAlpha() {
    final value = cellStyle.alpha;
    return ListTile(
      isThreeLine: true,
      leading: const Icon(Icons.invert_colors),
      title: i18n.p13n.cell.alpha.text(),
      trailing: "${(value * 100).toInt()}%".toString().text(),
      subtitle: Slider(
        min: 0.0,
        max: 1.0,
        divisions: 255,
        label: (value * 255).toInt().toString(),
        value: value,
        onChanged: (double value) {
          setState(() {
            cellStyle = cellStyle.copyWith(alpha: value);
          });
        },
      ),
    );
  }
}
