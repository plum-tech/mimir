import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:reorderables/reorderables.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/adaptive/menu.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/adaptive/swipe.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/timetable/page/patch_prefab.dart';
import 'package:sit/timetable/widgets/patch/shared.dart';
import 'package:sit/utils/save.dart';

import '../entity/patch.dart';
import '../entity/timetable.dart';
import '../i18n.dart';
import '../widgets/patch/patch_set.dart';
import 'preview.dart';

class TimetablePatchEditorPage extends StatefulWidget {
  final SitTimetable timetable;

  const TimetablePatchEditorPage({
    super.key,
    required this.timetable,
  });

  @override
  State<TimetablePatchEditorPage> createState() => _TimetablePatchEditorPageState();
}

class _TimetablePatchEditorPageState extends State<TimetablePatchEditorPage> {
  late var patches = List.of(widget.timetable.patches);
  var anyChanged = false;

  void markChanged() => anyChanged |= true;

  @override
  Widget build(BuildContext context) {
    return PromptSaveBeforeQuitScope(
      canSave: anyChanged,
      onSave: onSave,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              title: i18n.patch.title.text(),
              actions: [
                PlatformTextButton(
                  onPressed: onSave,
                  child: i18n.save.text(),
                ),
                buildMoreActions(),
              ],
            ),
            if (patches.isEmpty)
              SliverFillRemaining(
                child: LeavingBlank(
                  icon: Icons.dashboard_customize,
                  desc: "No patches here, how about opening prefabs?",
                  onIconTap: openPrefab,
                ),
              )
            else
              ReorderableSliverList(
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    final patch = patches.removeAt(oldIndex);
                    patches.insert(newIndex, patch);
                  });
                  markChanged();
                },
                delegate: ReorderableSliverChildBuilderDelegate(
                  childCount: patches.length,
                  (context, i) {
                    final patch = patches[i];
                    final timetable = widget.timetable.copyWith(patches: patches.sublist(0, i + 1));
                    return buildPatchEntry(patch, i, timetable);
                  },
                ),
              ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          padding: EdgeInsets.zero,
          child: buildPatchButtons(),
        ),
      ),
    );
  }

  void onSave() {
    context.pop(List.of(patches));
  }

  Future<void> onPreview() async {
    await previewTimetable(context, timetable: buildTimetable());
  }

  Widget buildMoreActions() {
    return PullDownMenuButton(
      itemBuilder: (BuildContext context) {
        return [
          PullDownItem(
            icon: context.icons.preview,
            title: i18n.preview,
            onTap: onPreview,
          ),
          PullDownItem(
            icon: Icons.dashboard_customize,
            title: "Prefabs",
            onTap: openPrefab,
          ),
          PullDownItem.delete(
            icon: context.icons.clear,
            title: i18n.clear,
            onTap: patches.isNotEmpty
                ? () {
                    setState(() {
                      patches.clear();
                    });
                    markChanged();
                  }
                : null,
          ),
        ];
      },
    );
  }

  Future<void> openPrefab() async {
    final patchSet = await context.show$Sheet$<TimetablePatchSet>(
      (context) => const TimetablePatchPrefabPage(),
    );
    if (patchSet == null) return;
    if (!mounted) return;
    setState(() {
      patches.add(patchSet);
    });
    markChanged();
  }

  Widget buildPatchEntry(TimetablePatchEntry entry, int index, SitTimetable timetable) {
    return switch (entry) {
      TimetablePatchSet() => TimetablePatchSetCard(
          patchSet: entry,
          timetable:timetable,
          onDeleted: () {
            removePatch(index);
          },
        ),
      TimetablePatch() => SwipeToDismiss(
          childKey: ValueKey(entry),
          right: SwipeToDismissAction(
            icon: Icon(context.icons.delete),
            action: () {
              removePatch(index);
            },
          ),
          child: entry.build(
            context: context,
            timetable: timetable,
            onChanged: (newPatch) {
              setState(() {
                patches[index] = newPatch;
              });
              markChanged();
            },
          ),
        ),
    };
  }

  void removePatch(int index) {
    setState(() {
      patches.removeAt(index);
    });
    markChanged();
  }

  SitTimetable buildTimetable() {
    return widget.timetable.copyWith(
      patches: List.of(patches),
    );
  }

  Widget buildPatchButtons() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: TimetablePatchType.creatable
          .map((type) => ActionChip(
                avatar: Icon(context.icons.add),
                label: type.l10n().text(),
                onPressed: () async {
                  final patch = await type.onCreate(context, widget.timetable);
                  if (patch == null) return;
                  setState(() {
                    patches.add(patch);
                  });
                },
              ).padOnly(r: 8))
          .toList(),
    ).sized(h: 40);
  }
}
