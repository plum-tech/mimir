import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:reorderables/reorderables.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/menu.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/adaptive/swipe.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/timetable/widgets/patch/shared.dart';
import 'package:sit/utils/save.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../entity/patch.dart';
import '../../entity/timetable.dart';
import '../../i18n.dart';
import '../preview.dart';

class TimetablePatchSetEditorPage extends StatefulWidget {
  final SitTimetable timetable;
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
  var anyChanged = false;

  void markChanged() => anyChanged |= true;

  @override
  Widget build(BuildContext context) {
    assert(widget.patchSet.patches.isNotEmpty);
    return PromptSaveBeforeQuitScope(
      canSave: anyChanged,
      onSave: onSave,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              title: TextScroll(widget.patchSet.name),
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
                  desc: "No patches",
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
    return TimetablePatchSet(name: widget.patchSet.name, patches: List.of(patches));
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

  Widget buildPatchEntry(TimetablePatch patch, int index, SitTimetable timetable) {
    return WithSwipeAction(
      childKey: ValueKey(patch),
      right: SwipeAction.delete(
        icon: context.icons.delete,
        action: () {
          removePatch(index);
        },
      ),
      child: TimetablePatchWidget<TimetablePatch>(
        leading: Card.filled(
          margin: EdgeInsets.zero,
          child: Icon(patch.type.icon).padAll(8),
        ),
        patch: patch,
        timetable: timetable,
        edit: (patch) async {
          return await patch.type.create(context, timetable, patch);
        },
        onChanged: (newPatch) {
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

  SitTimetable buildTimetable() {
    return widget.timetable.copyWith(
      patches: List.of(widget.timetable.patches)
        ..removeLast()
        ..add(buildPatchSet()),
    );
  }
}
