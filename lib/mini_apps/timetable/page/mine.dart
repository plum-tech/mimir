import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/mini_apps/symbol.dart';
import 'package:mimir/mini_apps/timetable/storage/timetable.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/entity.dart';
import '../using.dart';
import '../widgets/meta_editor.dart';

class MyTimetableListPage extends StatefulWidget {
  const MyTimetableListPage({super.key});

  @override
  State<MyTimetableListPage> createState() => _MyTimetableListPageState();
}

class _MyTimetableListPageState extends State<MyTimetableListPage> {
  final storage = TimetableInit.storage;

  Future<void> goImport() async {
    final timetable = await context.push<SitTimetable>("/app/timetable/import");
    if (timetable != null) {
      storage.currentTimetableId ??= timetable.id;
      if (!mounted) return;
      setState(() {});
    }
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
    final useOldSchoolInit = storage.useOldSchoolPalette ?? false;
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
          },
        ),
        make: (ctx) => [
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
        ].column(mas: MainAxisSize.min),
      ),
    );
    if ($useOldSchool.value != useOldSchoolInit || $useNewUI.value != useNewUIInit) {
      if (!mounted) return;
      storage.useOldSchoolPalette = $useOldSchool.value;
      storage.useNewUI = $useNewUI.value;
    }
  }

  Widget _buildEmptyBody(BuildContext ctx) {
    return LeavingBlank(icon: Icons.calendar_month_rounded, desc: i18n.mine.emptyTip, onIconTap: goImport);
  }

  Widget buildTimetables(BuildContext ctx) {
    final timetables = storage.getAllSitTimetables();
    final selectedId = storage.currentTimetableId;
    if (timetables.isEmpty) {
      return _buildEmptyBody(ctx);
    }
    return ListView(
      children: [
        for (final timetable in timetables)
          TimetableEntry(
            timetable: timetable,
            moreAction: buildActionPopup(timetable, selectedId == timetable.id),
            actions: (
              use: (timetable) {
                storage.currentTimetableId = timetable.id;
                setState(() {});
              },
              preview: (timetable) {
                ctx.push("/app/timetable/preview/${timetable.id}", extra: timetable);
              }
            ),
          ),
      ],
    );
  }

  Widget buildActionPopup(SitTimetable timetable, bool isSelected) {
    return PopupMenuButton(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
      position: PopupMenuPosition.under,
      padding: EdgeInsets.zero,
      itemBuilder: (ctx) => <PopupMenuEntry>[
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.edit),
            title: i18n.mine.edit.text(),
            onTap: () async {
              ctx.pop();
              final newMeta = await ctx.showSheet<TimetableMeta>(
                (ctx) => MetaEditor(meta: timetable.meta).padOnly(b: MediaQuery.of(ctx).viewInsets.bottom),
                dismissible: false,
              );
              if (newMeta != null) {
                final newTimetable = timetable.copyWithMeta(newMeta);
                storage.setSitTimetableById(newTimetable, id: newTimetable.id);
                if (!mounted) return;
                setState(() {});
              }
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.delete, color: Colors.redAccent),
            title: i18n.mine.delete.text(style: const TextStyle(color: Colors.redAccent)),
            onTap: () async {
              ctx.pop();
              final confirm = await ctx.showRequest(
                title: i18n.mine.deleteRequest,
                desc: i18n.mine.deleteRequestDesc,
                yes: i18n.delete,
                no: i18n.cancel,
                highlight: true,
              );
              if (confirm == true) {
                storage.deleteTimetableOf(timetable.id);
                if (!mounted) return;
                if (!storage.hasAnyTimetable) {
                  // If no timetable exists, go out.
                  ctx.pop();
                }
                setState(() {});
              }
            },
          ),
        ),
      ],
    );
  }
}

typedef TimetableCallback = void Function(SitTimetable tiemtable);
typedef TimetableActions = ({TimetableCallback use, TimetableCallback preview});

class TimetableEntry extends StatelessWidget {
  final SitTimetable timetable;
  final Widget? moreAction;
  final TimetableActions actions;

  const TimetableEntry({
    super.key,
    required this.timetable,
    required this.moreAction,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = TimetableInit.storage.currentTimetableId == timetable.id;
    final year = '${timetable.schoolYear} - ${timetable.schoolYear + 1}';
    final semester = timetable.semester.localized();
    final bodyTextStyle = context.textTheme.bodyLarge;
    return [
      [
        timetable.name.text(style: context.textTheme.headlineSmall).expanded(),
        if (isSelected) const Icon(Icons.check, color: Colors.green),
      ].row(maa: MainAxisAlignment.spaceBetween),
      "$year $semester".text(style: context.textTheme.titleMedium),
      "${i18n.startWith} ${context.formatYmdText(timetable.startDate)}".text(style: bodyTextStyle),
      OverflowBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          [
            if (isSelected)
              FilledButton(onPressed: null, child: "Used".text())
            else
              FilledButton(
                  onPressed: () {
                    actions.use(timetable);
                  },
                  child: "Use".text()),
            if (!isSelected)
              OutlinedButton(
                  onPressed: () {
                    actions.preview(timetable);
                  },
                  child: "Preview".text()),
          ].wrap(spacing: 4),
          if (moreAction != null) moreAction!,
        ],
      ),
    ].column(caa: CrossAxisAlignment.start).padSymmetric(v: 10, h: 20).inCard(elevation: isSelected ? 10 : null);
  }
}
