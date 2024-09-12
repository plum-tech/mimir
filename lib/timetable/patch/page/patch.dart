import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/animation/animated.dart';
import 'package:reorderables/reorderables.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/adaptive/foundation.dart';
import 'package:mimir/design/adaptive/menu.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/design/adaptive/swipe.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:mimir/timetable/patch/widget/shared.dart';
import 'package:mimir/utils/format.dart';
import 'package:mimir/utils/save.dart';

import '../builtin.dart';
import '../entity/patch.dart';
import 'patch_prefab.dart';
import '../../entity/timetable.dart';
import '../../i18n.dart';
import '../widget/patch_set.dart';
import '../../page/preview.dart';
import 'patch_set.dart';
import 'qrcode.dart';

class TimetablePatchEditorPage extends StatefulWidget {
  final Timetable timetable;
  final TimetablePatchEntry? initialEditing;

  const TimetablePatchEditorPage({
    super.key,
    required this.timetable,
    this.initialEditing,
  });

  @override
  State<TimetablePatchEditorPage> createState() => _TimetablePatchEditorPageState();
}

class _TimetablePatchEditorPageState extends State<TimetablePatchEditorPage> {
  late var patches = List.of(widget.timetable.patches);
  final initialEditingKey = GlobalKey(debugLabel: "Initial editing");
  final controller = ScrollController();
  var anyChanged = false;
  TimetablePatchSet? recommended;

  void markChanged() => anyChanged |= true;

  @override
  void initState() {
    super.initState();
    final initialEditing = widget.initialEditing;
    if (initialEditing != null) {
      WidgetsBinding.instance.endOfFrame.then((_) async {
        if (!mounted) return;
        final index = patches.indexOf(initialEditing);
        final ctx = initialEditingKey.currentContext;
        if (index >= 0 && ctx != null) {
          if (!ctx.mounted) return;
          await Scrollable.ensureVisible(ctx);
          if (initialEditing is TimetablePatch) {
            editPatch(index, initialEditing);
          } else if (initialEditing is TimetablePatchSet) {
            editPatchSet(index, initialEditing);
          }
        }
      });
    }
    evaluateRecommendation();
  }

  Future<void> evaluateRecommendation() async {
    if (patches.isNotEmpty) return;
    await Future.delayed(Durations.extralong4);
    final recommendations =
        BuiltinTimetablePatchSets.all.where((set) => set.recommended?.call(widget.timetable) == true).toList();
    setState(() {
      recommended = recommendations.firstOrNull;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recommended = this.recommended;
    return PromptSaveBeforeQuitScope(
      changed: anyChanged,
      onSave: onSave,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            CustomScrollView(
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
                      desc: i18n.patch.noPatches,
                      action: FilledButton(
                        onPressed: openPrefab,
                        child: i18n.patch.addPrefab.text(),
                      ),
                    ),
                  )
                else
                  ReorderableSliverList(
                    controller: controller,
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
            AnimatedShowUp(
              when: recommended != null,
              builder: (ctx) => TimetablePatchEntryRecommendationCard(
                recommended!,
                onClose: () {
                  setState(() {
                    this.recommended = null;
                  });
                },
                onAdded: () {
                  addPatch(recommended);
                  setState(() {
                    this.recommended = null;
                  });
                },
              ),
            ).align(at: Alignment.bottomCenter),
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
    context.pop(buildTimetable());
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
            title: i18n.patch.prefabs,
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
    final patchSet = await context.showSheet<TimetablePatchSet>(
      (context) => const TimetablePatchPrefabPage(),
    );
    if (patchSet == null) return;
    if (!mounted) return;
    addPatch(patchSet);
  }

  Widget buildPatchEntry(TimetablePatchEntry entry, int index, Timetable timetable) {
    return WithSwipeAction(
      key: widget.initialEditing == entry ? initialEditingKey : null,
      childKey: ValueKey(entry),
      right: SwipeAction.delete(
        icon: context.icons.delete,
        action: () {
          removePatch(index);
        },
      ),
      child: switch (entry) {
        TimetablePatchSet() => TimetablePatchEntryDroppable(
            patch: entry,
            onMerged: (other) {
              removePatch(patches.indexOf(other));
              patches[index] = entry.copyWith(patches: List.of(entry.patches)..add(other));
              markChanged();
            },
            builder: (dropping) => TimetablePatchSetWidget(
              selected: dropping,
              patchSet: entry,
              timetable: timetable,
              optimizedForTouch: true,
              onDeleted: () {
                removePatch(index);
              },
              onUnpacked: () {
                removePatch(index);
                patches.insertAll(index, entry.patches);
                markChanged();
              },
              onEdit: () async {
                await editPatchSet(index, entry);
              },
            ).padSymmetric(v: 4),
          ),
        TimetablePatch() => TimetablePatchEntryDroppable(
            patch: entry,
            onMerged: (other) {
              final patchSet = TimetablePatchSet(
                name: allocValidFileName(
                  i18n.patch.defaultName,
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
              selected: dropping || widget.initialEditing == entry,
              optimizedForTouch: true,
              leading: (ctx, child) => TimetablePatchDraggable(
                patch: entry,
                child: child,
              ),
              patch: entry,
              timetable: timetable,
              onDeleted: () {
                removePatch(index);
              },
              onEdit: () async {
                await editPatch(index, entry);
              },
            ),
          ),
      },
    );
  }

  Future<void> editPatchSet(int index, TimetablePatchSet patchSet) async {
    final newPatchSet = await context.showSheet<TimetablePatchSet>(
      (ctx) => TimetablePatchSetEditorPage(
        timetable: widget.timetable,
        patchSet: patchSet,
      ),
    );
    if (newPatchSet == null) return;
    setState(() {
      patches[index] = newPatchSet;
    });
    markChanged();
  }

  Future<void> editPatch(int index, TimetablePatch patch) async {
    final newPatch = await patch.type.create(context, widget.timetable, patch);
    if (newPatch == null) return;
    setState(() {
      patches[index] = newPatch;
    });
    markChanged();
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

  Timetable buildTimetable() {
    return widget.timetable.copyWith(
      patches: List.of(patches),
      lastModified: DateTime.now(),
    );
  }
}

class TimetablePatchEntryRecommendationCard extends StatelessWidget {
  final TimetablePatchEntry patch;
  final VoidCallback? onClose;
  final VoidCallback? onAdded;

  const TimetablePatchEntryRecommendationCard(
    this.patch, {
    super.key,
    this.onClose,
    this.onAdded,
  });

  @override
  Widget build(BuildContext context) {
    final onClose = this.onClose;
    return [
      Card.outlined(
        child: [
          ListTile(
            title: i18n.recommendation.text(style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: onClose == null
                ? null
                : PlatformIconButton(
                    icon: Icon(context.icons.close),
                    onPressed: onClose,
                  ),
          ),
          if (patch is TimetablePatch)
            buildPatch(context, patch as TimetablePatch).padH(8)
          else if (patch is TimetablePatchSet)
            buildPatchSet(context, patch as TimetablePatchSet).padH(8),
          FilledButton.tonalIcon(
            icon: Icon(context.icons.add),
            label: i18n.add.text(),
            onPressed: onAdded,
          ).padAll(8),
        ].column(caa: CrossAxisAlignment.end),
      ),
    ].column(mas: MainAxisSize.min).padAll(8);
  }

  Widget buildPatch(BuildContext context, TimetablePatch patch) {
    return ListTile(
      leading: PatchIcon(icon: patch.type.icon),
      title: patch.type.l10n().text(),
      subtitle: patch.l10n().text(),
    );
  }

  Widget buildPatchSet(BuildContext context, TimetablePatchSet set) {
    return ListTile(
      title: set.name.text(),
      subtitle: TimetablePatchSetPatchesPreview(set),
      onTap: () async {
        await context.showSheet(
          (ctx) => TimetablePatchViewerPage(
            patch: set,
            actions: [
              PlatformTextButton(
                onPressed: onAdded == null
                    ? null
                    : () {
                        context.pop();
                        onAdded?.call();
                      },
                child: i18n.add.text(),
              )
            ],
          ),
          dismissible: false,
        );
      },
    );
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
        final willAccept = details.data != widget.patch;
        if (willAccept) {
          HapticFeedback.selectionClick();
        }
        return willAccept;
      },
      onAcceptWithDetails: (details) {
        widget.onMerged(details.data);
        HapticFeedback.mediumImpact();
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
    return Draggable<TimetablePatch>(
      data: patch,
      feedback: widget.child,
      onDragStarted: () async {
        setState(() {
          dragging = true;
        });
        await HapticFeedback.selectionClick();
      },
      onDragEnd: (details) async {
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

class ReadonlyTimetablePatchEntryWidget extends StatelessWidget {
  final TimetablePatchEntry entry;
  final bool enableQrCode;

  const ReadonlyTimetablePatchEntryWidget({
    super.key,
    required this.entry,
    this.enableQrCode = true,
  });

  @override
  Widget build(BuildContext context) {
    final entry = this.entry;
    return switch (entry) {
      TimetablePatchSet() => TimetablePatchSetWidget(
          patchSet: entry,
          enableQrCode: enableQrCode,
        ),
      TimetablePatch() => TimetablePatchWidget<TimetablePatch>(
          enableQrCode: enableQrCode,
          patch: entry,
        ),
    };
  }
}
