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
import 'package:sit/utils/format.dart';
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
    addPatch(patchSet);
  }

  Widget buildPatchEntry(TimetablePatchEntry entry, int index, SitTimetable timetable) {
    return switch (entry) {
      TimetablePatchSet() => TimetablePatchEntryDroppable(
          patch: entry,
          onMerged: (other) {
            removePatch(patches.indexOf(other));
            patches[index] = entry.copyWith(patches: List.of(entry.patches)..add(other));
            markChanged();
          },
          builder: (dropping) => TimetablePatchSetCard(
            selected: dropping,
            patchSet: entry,
            timetable: timetable,
            onDeleted: () {
              removePatch(index);
            },
            onUnpacked: () {
              removePatch(index);
              patches.insertAll(index, entry.patches);
              markChanged();
            },
          ),
        ),
      TimetablePatch() => WithSwipeAction(
          childKey: ValueKey(entry),
          right: SwipeAction.delete(
            icon: Icon(context.icons.delete),
            action: () {
              removePatch(index);
            },
          ),
          child: TimetablePatchEntryDroppable(
            patch: entry,
            onMerged: (other) {
              final patchSet = TimetablePatchSet(
                name: allocValidFileName(
                  "New patch set",
                  all: patches.whereType<TimetablePatchSet>().map((set) => set.name).toList(),
                ),
                patches: [entry, other],
              );
              patches.insert(index, patchSet);
              removePatch(patches.indexOf(entry));
              removePatch(patches.indexOf(other));
              markChanged();
            },
            builder: (dropping) => TimetablePatchWidget<TimetablePatch>(
              selected: dropping,
              leading: TimetablePatchDraggable(
                patch: entry,
                child: Card.filled(
                  margin: EdgeInsets.zero,
                  child: Icon(entry.type.icon).padAll(8),
                ),
              ),
              patch: entry,
              timetable: timetable,
              create: () async {
                return await entry.type.onCreate(context, timetable);
              },
              onChanged: (newPatch) {
                setState(() {
                  patches[index] = newPatch;
                });
                markChanged();
              },
            ),
          ),
        ),
    };
  }

  void addPatch(TimetablePatchEntry patch) {
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
      patches: List.of(patches),
    );
  }

  Widget buildPatchButtons() {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 8),
      children: TimetablePatchType.creatable
          .map((type) => ActionChip(
                avatar: Icon(type.icon),
                label: type.l10n().text(),
                onPressed: () async {
                  final patch = await type.onCreate(context, widget.timetable);
                  if (patch == null) return;
                  addPatch(patch);
                },
              ).padOnly(r: 8))
          .toList(),
    ).sized(h: 40);
  }
}

class TimetablePatchEntryDroppable extends StatefulWidget {
  final TimetablePatchEntry patch;
  final void Function(TimetablePatch other) onMerged;
  final Widget Function(bool dropping) builder;

  const TimetablePatchEntryDroppable({
    super.key,
    required this.patch,
    required this.builder,
    required this.onMerged,
  });

  @override
  State<TimetablePatchEntryDroppable> createState() => _TimetablePatchEntryDroppableState();
}

class _TimetablePatchEntryDroppableState extends State<TimetablePatchEntryDroppable> {
  @override
  Widget build(BuildContext context) {
    return DragTarget<TimetablePatch>(
      builder: (context, candidateItems, rejectedItems) {
        return widget.builder(candidateItems.isNotEmpty);
      },
      onWillAcceptWithDetails: (details) {
        return details.data != widget.patch;
      },
      onAcceptWithDetails: (details) {
        widget.onMerged(details.data);
      },
    );
  }
}

class TimetablePatchDraggable extends StatefulWidget {
  final TimetablePatch patch;
  final Widget child;

  const TimetablePatchDraggable({
    super.key,
    required this.patch,
    required this.child,
  });

  @override
  State<TimetablePatchDraggable> createState() => _TimetablePatchDraggableState();
}

class _TimetablePatchDraggableState extends State<TimetablePatchDraggable> {
  var dragging = false;

  @override
  Widget build(BuildContext context) {
    final patch = widget.patch;
    return LongPressDraggable<TimetablePatch>(
      data: patch,
      feedback: Card.filled(
        child: [
          Icon(patch.type.icon),
          patch.type.l10n().text(),
        ].column(maa: MainAxisAlignment.center).sizedAll(80),
      ),
      onDragStarted: () {
        setState(() {
          dragging = true;
        });
      },
      onDragEnd: (details) {
        setState(() {
          dragging = false;
        });
      },
      child: AnimatedOpacity(
        opacity: dragging ? 0.25 : 1.0,
        duration: Durations.short3,
        child: widget.child,
      ),
    );
  }
}
