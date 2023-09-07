import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:mimir/design/widgets/dialog.dart';
import 'package:mimir/design/widgets/multiplatform.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/route.dart';
import 'package:mimir/timetable/storage/timetable.dart';
import 'package:path/path.dart' show join;
import 'package:rettulf/rettulf.dart';
import 'package:share_plus/share_plus.dart';

import '../entity/meta.dart';
import '../i18n.dart';
import '../entity/entity.dart';
import '../init.dart';
import '../utils.dart';
import '../widgets/meta_editor.dart';

class MyTimetableListPage extends StatefulWidget {
  const MyTimetableListPage({super.key});

  @override
  State<MyTimetableListPage> createState() => _MyTimetableListPageState();
}

class _MyTimetableListPageState extends State<MyTimetableListPage> {
  final storage = TimetableInit.storage;

  Future<void> goImport() async {
    final id2timetable = await context.push<({String id, SitTimetable timetable})>("/timetable/import");
    if (id2timetable != null) {
      final (:id, timetable: _) = id2timetable;
      storage.usedTimetableId ??= id;
      if (!mounted) return;
      setState(() {});
    }
  }

  Future<void> importFromFile() async {
    try {
      final id2timetable = await importTimetableFromFile();
      if (id2timetable != null) {
        final (:id, timetable: _) = id2timetable;
        storage.usedTimetableId ??= id;
      }
      if (!mounted) return;
      setState(() {});
    } catch (err) {
      if (!mounted) return;
      context.showSnackBar("Format Error. Please select a timetable file.".text());
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
        onPressed: isLoginGuarded(context) ? importFromFile : goImport,
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
        make: (ctx) => Material(
            child: [
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
        ].column(mas: MainAxisSize.min)),
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
    final selectedId = storage.usedTimetableId;
    if (timetables.isEmpty) {
      return _buildEmptyBody(ctx);
    }
    return ListView(
      children: [
        for (final (:id, :timetable) in timetables)
          TimetableEntry(
            id: id,
            timetable: timetable,
            moreAction: buildActionPopup(id, timetable, selectedId == id),
            actions: (
              use: (timetable) {
                storage.usedTimetableId = id;
                setState(() {});
              },
              preview: (timetable) {
                ctx.push("/timetable/preview/$id", extra: timetable);
              }
            ),
          ),
      ],
    );
  }

  Widget buildActionPopup(String id, SitTimetable timetable, bool isSelected) {
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
                storage.setSitTimetableById(newTimetable, id: id);
                if (!mounted) return;
                setState(() {});
              }
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.output_outlined),
            title: i18n.mine.exportFile.text(),
            onTap: () async {
              ctx.pop();
              final content = jsonEncode(timetable.toJson());
              final year = '${timetable.schoolYear}–${timetable.schoolYear + 1}';
              final semester = timetable.semester.localized();
              final fileName = "$year-$semester.timetable";
              final timetableFi = File(join(R.tmpDir, fileName));
              await timetableFi.writeAsString(content);
              await Share.shareXFiles(
                [XFile(timetableFi.path)],
              );
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
                storage.deleteTimetableOf(id);
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
  final String id;
  final SitTimetable timetable;
  final Widget? moreAction;
  final TimetableActions actions;

  const TimetableEntry({
    super.key,
    required this.id,
    required this.timetable,
    required this.moreAction,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = TimetableInit.storage.usedTimetableId == id;
    final year = '${timetable.schoolYear}–${timetable.schoolYear + 1}';
    final semester = timetable.semester.localized();
    final textTheme = context.textTheme;
    final widget = [
      timetable.name.text(style: textTheme.titleLarge),
      "$year, $semester".text(style: textTheme.titleMedium),
      "${i18n.startWith} ${context.formatYmdText(timetable.startDate)}".text(style: textTheme.bodyLarge),
      OverflowBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          [
            if (isSelected)
              FilledButton.icon(
                icon: const Icon(Icons.check),
                label: i18n.mine.used.text(),
                onPressed: null,
              )
            else
              FilledButton(
                onPressed: () {
                  actions.use(timetable);
                },
                child: i18n.mine.use.text(),
              ),
            if (!isSelected)
              OutlinedButton(
                onPressed: () {
                  actions.preview(timetable);
                },
                child: i18n.mine.preview.text(),
              )
          ].wrap(spacing: 12),
          if (moreAction != null) moreAction!,
        ],
      ),
    ].column(caa: CrossAxisAlignment.start).padSymmetric(v: 10, h: 20);
    return isSelected ? widget.inFilledCard() : widget.inOutlinedCard();
  }
}
