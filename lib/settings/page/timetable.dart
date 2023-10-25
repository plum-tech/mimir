import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/settings/settings.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/timetable/page/background.dart';
import 'package:sit/timetable/page/cell_style.dart';
import '../i18n.dart';

class TimetableSettingsPage extends StatefulWidget {
  const TimetableSettingsPage({
    super.key,
  });

  @override
  State<TimetableSettingsPage> createState() => _TimetableSettingsPageState();
}

class _TimetableSettingsPageState extends State<TimetableSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              title: i18n.timetable.title.text(style: context.textTheme.headlineSmall),
            ),
          ),
          SliverList.list(
            children: [
              buildAutoUseImportedToggle(),
              const Divider(),
              buildCellStyle(),
              buildP13n(),
              buildBackground(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildAutoUseImportedToggle() {
    return ListTile(
      title: i18n.timetable.autoUseImported.text(),
      subtitle: i18n.timetable.autoUseImportedDesc.text(),
      leading: const Icon(Icons.auto_mode_outlined),
      trailing: Switch.adaptive(
        value: Settings.timetable.autoUseImported,
        onChanged: (newV) {
          setState(() {
            Settings.timetable.autoUseImported = newV;
          });
        },
      ),
    );
  }

  Widget buildP13n() {
    return ListTile(
      leading: const Icon(Icons.color_lens_outlined),
      title: i18n.timetable.palette.text(),
      subtitle: i18n.timetable.paletteDesc.text(),
      trailing: const Icon(Icons.open_in_new),
      onTap: () async {
        await context.push("/timetable/p13n");
      },
    );
  }

  Widget buildCellStyle() {
    return ListTile(
      leading: const Icon(Icons.view_comfortable_outlined),
      title: i18n.timetable.cellStyle.text(),
      subtitle: i18n.timetable.cellStyleDesc.text(),
      trailing: const Icon(Icons.open_in_new),
      onTap: () async {
        await context.show$Sheet$((ctx) => const TimetableCellStyleEditor());
      },
    );
  }

  Widget buildBackground() {
    return ListTile(
      leading: const Icon(Icons.image_outlined),
      title: i18n.timetable.background.text(),
      subtitle: i18n.timetable.backgroundDesc.text(),
      trailing: const Icon(Icons.open_in_new),
      onTap: () async {
        await context.show$Sheet$((ctx) => const TimetableBackgroundEditor());
      },
    );
  }
}
