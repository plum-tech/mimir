import 'package:flutter/material.dart';
import 'package:mimir/timetable/init.dart';
import 'package:rettulf/rettulf.dart';

class TimetableP13nPage extends StatefulWidget {
  const TimetableP13nPage({super.key});

  @override
  State<TimetableP13nPage> createState() => _TimetableP13nPageState();
}

class _TimetableP13nPageState extends State<TimetableP13nPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: "Personalization".text(),
        ),
        SliverToBoxAdapter(
          child: buildNewUiSwitch(),
        )
      ],
    );
  }

  Widget buildNewUiSwitch() {
    return ListTile(
      title: "Use Timetable New-UI".text(),
      trailing: TimetableInit.storage.$useNewUI >>
          (ctx, _) => Switch.adaptive(
              value: TimetableInit.storage.useNewUI ?? false,
              onChanged: (newV) {
                TimetableInit.storage.useNewUI = newV;
              }),
    );
  }
}
