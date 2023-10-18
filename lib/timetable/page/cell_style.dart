import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/settings/settings.dart';

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
            title: "Cell style".text(),
          ),
          SliverList.list(children: [
            buildTeachersToggle(),
            buildGrayOutPassedLesson(),
            buildHarmonizeWithThemeColor(),
          ]),
          const SliverToBoxAdapter(
            child: Divider(),
          ),
          SliverToBoxAdapter(
            child: buildPreview(),
          ),
        ],
      ),
    );
  }

  Widget buildPreview() {
    return const Placeholder();
  }

  Widget buildTeachersToggle() {
    return StatefulBuilder(builder: (context, setState) {
      return ListTile(
        leading: const Icon(Icons.person_pin),
        title: "Teachers".text(),
        subtitle: "Show teachers in cell".text(),
        trailing: Switch.adaptive(
          value: Settings.timetable.cell.showTeachers,
          onChanged: (newV) {
            setState(() {
              Settings.timetable.cell.showTeachers = newV;
            });
          },
        ),
      );
    });
  }

  Widget buildGrayOutPassedLesson() {
    return StatefulBuilder(builder: (context, setState) {
      return ListTile(
        leading: const Icon(Icons.timelapse),
        title: "Gray out passed lessons".text(),
        subtitle: "Before today".text(),
        trailing: Switch.adaptive(
          value: Settings.timetable.cell.grayOutPassedLessons,
          onChanged: (newV) {
            setState(() {
              Settings.timetable.cell.grayOutPassedLessons = newV;
            });
          },
        ),
      );
    });
  }

  Widget buildHarmonizeWithThemeColor() {
    return StatefulBuilder(builder: (context, setState) {
      return ListTile(
        leading: const Icon(Icons.format_color_fill),
        title: "Harmonize with theme color".text(),
        subtitle: "Mix the cell color with theme color".text(),
        trailing: Switch.adaptive(
          value: Settings.timetable.cell.harmonizeWithThemeColor,
          onChanged: (newV) {
            setState(() {
              Settings.timetable.cell.harmonizeWithThemeColor = newV;
            });
          },
        ),
      );
    });
  }
}

class TimetableEditCellStyleTile extends StatelessWidget {
  const TimetableEditCellStyleTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.style_outlined),
      title: "Edit cell style".text(),
      subtitle: "How course cell looks like".text(),
      trailing: const Icon(Icons.open_in_new),
      onTap: () async {
        await context.show$Sheet$((ctx) => const TimetableCellStyleEditor());
      },
    );
  }
}
