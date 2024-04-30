import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';

import '../patch.dart';
import '../widgets/patch/prefab.dart';

class TimetablePatchPrefabPage extends StatefulWidget {
  const TimetablePatchPrefabPage({
    super.key,
  });

  @override
  State<TimetablePatchPrefabPage> createState() => _TimetablePatchPrefabPageState();
}

class _TimetablePatchPrefabPageState extends State<TimetablePatchPrefabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            pinned: true,
            snap: false,
            floating: false,
            title: "Patch prefabs".text(),
          ),
          SliverList.builder(
            itemCount: BuiltinTimetablePatchSets.all.length,
            itemBuilder: (ctx, i) {
              final patchSet = BuiltinTimetablePatchSets.all[i];
              return TimetablePatchSetGalleryCard(
                patchSet: patchSet,
                onAdd: () {
                  context.pop(patchSet);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
