import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/patch.dart';

class TimetablePatchEditorPage extends StatefulWidget {
  final List<TimetablePatch> patches;

  const TimetablePatchEditorPage({
    super.key,
    required this.patches,
  });

  @override
  State<TimetablePatchEditorPage> createState() => _TimetablePatchEditorPageState();
}

class _TimetablePatchEditorPageState extends State<TimetablePatchEditorPage> {
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
