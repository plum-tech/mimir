import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/adaptive/swipe.dart';
import 'package:sit/utils/save.dart';

import '../entity/patch.dart';
import '../entity/timetable.dart';
import '../i18n.dart';
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
  var navIndex = 0;
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
              title: "Timetable patch".text(),
              actions: [
                PlatformTextButton(
                  onPressed: onPreview,
                  child: i18n.preview.text(),
                ),
                PlatformTextButton(
                  onPressed: onSave,
                  child: i18n.save.text(),
                ),
              ],
            ),
            SliverList.list(children: [
              ListTile(
                title: "Add a patch".text(),
              ),
              buildPatchButtons(),
              const Divider(),
            ]),
            SliverList.builder(
              itemCount: patches.length,
              itemBuilder: (ctx, i) {
                final patch = patches[i];
                return SwipeToDismiss(
                  childKey: ValueKey(patch),
                  right: SwipeToDismissAction(
                    icon: Icon(context.icons.delete),
                    action: () async {
                      setState(() {
                        patches.removeAt(i);
                      });
                      markChanged();
                    },
                  ),
                  child: patch.build(context, widget.timetable, (newPatch) {
                    setState(() {
                      patches[i] = newPatch;
                    });
                    markChanged();
                  }),
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: navIndex,
          onDestinationSelected: (newIndex) {
            setState(() {
              navIndex = newIndex;
            });
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.dashboard_customize_outlined),
              selectedIcon: const Icon(Icons.dashboard_customize),
              label: "Patch",
            ),
            NavigationDestination(
              icon: const Icon(Icons.browse_gallery_outlined),
              selectedIcon: const Icon(Icons.browse_gallery),
              label: "Gallery",
            ),
          ],
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

  SitTimetable buildTimetable() {
    return widget.timetable.copyWith(
      patches: List.of(patches),
    );
  }

  Widget buildPatchButtons() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: TimetablePatchType.values
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
