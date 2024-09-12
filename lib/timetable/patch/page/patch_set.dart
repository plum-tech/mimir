import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:reorderables/reorderables.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/adaptive/editor.dart';
import 'package:mimir/design/adaptive/menu.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/design/adaptive/swipe.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:mimir/timetable/patch/widget/shared.dart';
import 'package:mimir/utils/save.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../entity/timetable.dart';
import '../../i18n.dart';
import '../../page/preview.dart';
import '../entity/patch.dart';

class TimetablePatchSetEditorPage extends StatefulWidget {
  final Timetable timetable;
  final TimetablePatchSet patchSet;

  const TimetablePatchSetEditorPage({
    super.key,
    required this.timetable,
    required this.patchSet,
  });

  @override
  State<TimetablePatchSetEditorPage> createState() => _TimetablePatchSetEditorPageState();
}

class _TimetablePatchSetEditorPageState extends State<TimetablePatchSetEditorPage> {
  late var patches = List.of(widget.patchSet.patches);
  late var name = widget.patchSet.name;
  var anyChanged = false;

  void markChanged() => anyChanged |= true;

  @override
  Widget build(BuildContext context) {
    assert(widget.patchSet.patches.isNotEmpty);
    return PromptSaveBeforeQuitScope(
      changed: anyChanged,
      onSave: onSave,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              title: TextScroll(name),
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
                  desc: i18n.patch.noPatches,
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
          child: AddPatchButtons(
            timetable: widget.timetable,
            addPatch: addPatch,
          ),
        ),
      ),
    );
  }

  void onSave() {
    context.pop(buildPatchSet());
  }

  TimetablePatchSet buildPatchSet() {
    return TimetablePatchSet(
      name: name,
      patches: List.of(patches),
    );
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
            icon: context.icons.edit,
            title: i18n.rename,
            onTap: () async {
              final newName = await Editor.showStringEditor(
                context,
                desc: i18n.patch.patchSetName,
                initial: name,
              );
              if (newName == null) return;
              if (name != newName) {
                setState(() {
                  name = newName;
                });
                markChanged();
              }
            },
          ),
        ];
      },
    );
  }

  Widget buildPatchEntry(TimetablePatch patch, int index, Timetable timetable) {
    return WithSwipeAction(
      childKey: ValueKey(patch),
      right: SwipeAction.delete(
        icon: context.icons.delete,
        action: () {
          removePatch(index);
        },
      ),
      child: TimetablePatchWidget<TimetablePatch>(
        patch: patch,
        timetable: timetable,
        onEdit: () async {
          final newPatch = await patch.type.create(context, timetable, patch);
          if (newPatch == null) return;
          setState(() {
            patches[index] = newPatch;
          });
          markChanged();
        },
      ),
    );
  }

  void addPatch(TimetablePatch patch) {
    setState(() {
      patches.add(patch);
    });
    markChanged();
  }

  void removePatch(int index) {
    setState(() {
      patches.removeAt(index);
    });
    markChanged();
  }

  Timetable buildTimetable() {
    return widget.timetable.copyWith(
      patches: List.of(widget.timetable.patches)
        ..removeLast()
        ..add(buildPatchSet()),
    );
  }
}

class TimetablePatchSetPatchesPreview extends StatelessWidget {
  final TimetablePatchSet patchSet;

  const TimetablePatchSetPatchesPreview(
    this.patchSet, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return patchSet.patches.map((patch) => Icon(patch.type.icon)).toList().wrap(spacing: 4);
  }
}
