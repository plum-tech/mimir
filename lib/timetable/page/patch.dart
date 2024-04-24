import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/patch.dart';

class TimetablePatchesPage extends StatefulWidget {
  final List<TimetablePatch> patches;

  const TimetablePatchesPage({
    super.key,
    required this.patches,
  });

  @override
  State<TimetablePatchesPage> createState() => _TimetablePatchesPageState();
}

class _TimetablePatchesPageState extends State<TimetablePatchesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: "Timetable patch".text(),
            actions: [],
          ),
          SliverList.list(children: []),
        ],
      ),
    );
  }
}
