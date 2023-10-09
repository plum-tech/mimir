import 'package:flutter/material.dart';
import 'package:sit/settings/settings.dart';
import 'package:rettulf/rettulf.dart';
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
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              title: i18n.timetable.title.text(style: context.textTheme.headlineSmall),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              buildAutoUseImportedToggle(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget buildAutoUseImportedToggle() {
    return ListTile(
      title: i18n.timetable.autoUseImportedTitle.text(),
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
}
