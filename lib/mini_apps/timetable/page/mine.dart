import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/mini_apps/symbol.dart';
import 'package:mimir/mini_apps/timetable/storage/timetable.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/entity.dart';
import '../events.dart';
import '../using.dart';
import 'preview.dart';

class MyTimetableListPage extends StatefulWidget {
  const MyTimetableListPage({super.key});

  @override
  State<MyTimetableListPage> createState() => _MyTimetableListPageState();
}

class _MyTimetableListPageState extends State<MyTimetableListPage> {
  final storage = TimetableInit.timetableStorage;

  Future<void> goImport() async {
    await context.push("/app/timetable/import");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.mine.title.text(),
        actions: [
          IconButton(
            onPressed: showStyleToggle,
            icon: const Icon(Icons.color_lens_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goImport,
        elevation: 10,
        child: const Icon(Icons.add_outlined),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: buildTimetables(context),
      ),
    );
  }

  Future<void> showStyleToggle() async {
    final useOldSchoolInit = storage.useOldSchoolColors ?? false;
    final useNewUIInit = storage.useNewUI ?? false;
    final $useOldSchool = ValueNotifier(useOldSchoolInit);
    final $useNewUI = ValueNotifier(useNewUIInit);
    await context.show$Dialog$(
        make: (ctx) => $Dialog$(
              primary: $Action$(
                  text: i18n.close,
                  isDefault: true,
                  onPressed: () {
                    ctx.navigator.pop(true);
                  }),
              make: (ctx) {
                return [
                  [
                    ListTile(
                      title: "Use Old School Palette".text(style: const TextStyle(fontSize: 15)),
                      trailing: $useOldSchool >>
                          (ctx, use) => CupertinoSwitch(
                              value: use,
                              onChanged: (newV) {
                                $useOldSchool.value = newV;
                              }),
                    ),
                    ListTile(
                      title: "Use Timetable New-UI".text(style: const TextStyle(fontSize: 15)),
                      trailing: $useNewUI >>
                          (ctx, use) => CupertinoSwitch(
                              value: use,
                              onChanged: (newV) {
                                $useNewUI.value = newV;
                              }),
                    ),
                  ].column(),
                  "Excuse me, a new personalization system is coming soon!"
                      .text(style: const TextStyle(fontStyle: FontStyle.italic))
                ].column(mas: MainAxisSize.min);
              },
            ));
    if ($useOldSchool.value != useOldSchoolInit || $useNewUI.value != useNewUIInit) {
      storage.useOldSchoolColors = $useOldSchool.value;
      storage.useNewUI = $useNewUI.value;
      if (!mounted) return;
      eventBus.fire(TimetableStyleChangeEvent());
    }
  }

  Widget _buildEmptyBody(BuildContext ctx) {
    return LeavingBlank(icon: Icons.calendar_month_rounded, desc: i18n.mine.emptyTip, onIconTap: goImport);
  }

  Widget buildTimetables(BuildContext ctx) {
    final timetables = storage.getAllSitTimetables();
    if (timetables.isEmpty) {
      return _buildEmptyBody(ctx);
    }
    return ListView(
      children: [
        for (final timetable in timetables)
          TimetableEntry(
            timetable: timetable,
            onDeleted: () {
              // Refresh Mine page and show other timetables.
              setState(() {});
              if (!storage.hasAnyTimetable) {
                // If no timetable exists, go out.
                ctx.navigator.pop();
              }
            },
          ),
      ],
    );
  }
}

class TimetableEntry extends StatefulWidget {
  final SitTimetable timetable;
  final void Function()? onDeleted;

  const TimetableEntry({super.key, required this.timetable, this.onDeleted});

  @override
  State<TimetableEntry> createState() => _TimetableEntryState();
}

class _TimetableEntryState extends State<TimetableEntry> {
  SitTimetable get timetable => widget.timetable;
  final storage = TimetableInit.timetableStorage;

  @override
  Widget build(BuildContext ctx) {
    final isSelected = storage.currentTimetableId == timetable.id;
    final item = buildTimetableItemCard(ctx, isSelected);
    return CupertinoContextMenu.builder(
      actions: [
        CupertinoContextMenuAction(
          trailingIcon: CupertinoIcons.doc_text,
          onPressed: () async {
            Navigator.of(ctx).pop();
            /*    final changed = await ctx
                .showSheet((context) => TimetableEditor(meta: meta).padOnly(b: MediaQuery.of(ctx).viewInsets.bottom));

            if (changed == true) {
              setState(() {});
            }*/
          },
          child: i18n.mine.edit.text(),
        ),
        if (!isSelected)
          CupertinoContextMenuAction(
            trailingIcon: CupertinoIcons.checkmark,
            onPressed: () {
              Navigator.of(ctx).pop();
              storage.currentTimetableId = timetable.id;
              setState(() {});
            },
            child: i18n.mine.setToDefault.text(),
          ),
        CupertinoContextMenuAction(
          trailingIcon: CupertinoIcons.time,
          onPressed: () async {
            Navigator.of(ctx).pop();
/*            final date = await pickDate(context, initial: meta.startDate);
            if (date != null) {
              meta.startDate = DateTime(date.year, date.month, date.day, 8, 20);
              storage.addTableMeta(meta.name, meta);
            }*/
          },
          child: i18n.edit.setStartDate.text(),
        ),
        CupertinoContextMenuAction(
          trailingIcon: CupertinoIcons.eye,
          onPressed: () async {
            Navigator.of(ctx).pop();
            Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx) => TimetablePreviewPage(timetable: timetable)));
          },
          child: i18n.mine.preview.text(),
        ),
        CupertinoContextMenuAction(
          trailingIcon: CupertinoIcons.delete,
          onPressed: () async {
            Navigator.of(ctx).pop();
            // Have to wait until the animation has been suspended because flutter is buggy without check `mounted` in _CupertinoContextMenuState.
            await showDeleteTimetableRequest(ctx);
          },
          isDestructiveAction: true,
          child: i18n.mine.delete.text(),
        ),
      ],
      builder: (ctx, animation) {
        return item;
      },
    );
  }

  Widget buildTimetableItemCard(BuildContext ctx, bool isSelected) {
    final year = '${timetable.schoolYear} - ${timetable.schoolYear + 1}';
    final semester = Semester.values[timetable.semester].localized();
    final bodyTextStyle = ctx.textTheme.titleSmall;
    return [
      [
        [
          timetable.name.text(style: ctx.textTheme.titleMedium).expanded(),
          if (isSelected) const Icon(Icons.check, color: Colors.green),
        ].row(maa: MainAxisAlignment.spaceBetween),
        [
          year.text(style: bodyTextStyle),
          semester.text(style: bodyTextStyle),
        ].row(maa: MainAxisAlignment.spaceEvenly).padV(5),
      ].column().padSymmetric(v: 10, h: 20).inCard(elevation: 8),
      [
        const Icon(CupertinoIcons.doc_text),
        if (timetable.description.isNotEmpty)
          timetable.description.text(style: bodyTextStyle).padAll(10).expanded()
        else
          i18n.mine.noDesc.text(style: bodyTextStyle?.copyWith(fontStyle: FontStyle.italic)).padAll(10).expanded(),
      ].row(maa: MainAxisAlignment.spaceBetween).padAll(10),
      i18n.startDate(ctx.formatYmdNum(timetable.startDate)).text(style: bodyTextStyle).padFromLTRB(20, 20, 20, 10),
    ].column().scrolled().padAll(4).inCard(elevation: 5);
  }

  Future<void> showDeleteTimetableRequest(BuildContext ctx) async {
    final confirm = await ctx.showRequest(
        title: i18n.mine.deleteRequest,
        desc: i18n.mine.deleteRequestDesc,
        yes: i18n.delete,
        no: i18n.cancel,
        highlight: true);
    if (confirm == true) {
      storage.deleteTimetableOf(timetable.id);
      widget.onDeleted?.call();
    }
  }
}
