import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/patch.dart';
import '../i18n.dart';

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
  late var patches = List.of(widget.patches);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: "Timetable patch".text(),
            actions: [
              PlatformTextButton(
                onPressed: onSave,
                child: i18n.save.text(),
              ),
            ],
          ),
          SliverList.builder(
            itemCount: patches.length,
            itemBuilder: (ctx, i) {

            },
          ),
        ],
      ),
    );
  }

  void onSave() {

  }
}
