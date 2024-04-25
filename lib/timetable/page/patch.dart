import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/multiplatform.dart';

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
          SliverList.list(children: [
            buildAddPatchTile(),
            const Divider(),
          ]),
          SliverList.builder(
            itemCount: patches.length,
            itemBuilder: (ctx, i) {
              final patch = patches[i];
              return patch.build(context);
            },
          ),
        ],
      ),
    );
  }

  void onSave() {}

  Widget buildAddPatchTile() {
    return ListTile(
      isThreeLine: true,
      leading: Icon(context.icons.add),
      title: "Add a patch".text(),
      subtitle: ListView(
        scrollDirection: Axis.horizontal,
        children: TimetablePatchType.values
            .map((type) => ActionChip(
                  label: type.l10n().text(),
                  onPressed: () async {
                    final patch = await type.onCreate(context);
                    if (patch == null) return;
                    setState(() {
                      patches.add(patch);
                    });
                  },
                ).padOnly(r: 8))
            .toList(),
      ).sized(h: 40),
    );
  }
}
