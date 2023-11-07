import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/widgets/entry_card.dart';
import 'package:sit/design/widgets/fab.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/route.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/page/export.dart';
import 'package:sit/timetable/platte.dart';
import 'package:sit/timetable/widgets/course.dart';

import '../i18n.dart';
import '../entity/timetable.dart';
import '../init.dart';
import '../utils.dart';
import 'editor.dart';

class MyTimetableListPage extends StatefulWidget {
  const MyTimetableListPage({super.key});

  @override
  State<MyTimetableListPage> createState() => _MyTimetableListPageState();
}

class _MyTimetableListPageState extends State<MyTimetableListPage> {
  final $timetableList = TimetableInit.storage.timetable.$any;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    $timetableList.addListener(refresh);
  }

  @override
  void dispose() {
    $timetableList.removeListener(refresh);
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  /// Import a new timetable.
  /// Updates the selected timetable id.
  /// If [TimetableSettings.autoUseImported] is enabled, the newly-imported will be used.
  Future<void> goImport() async {
    final ({int id, SitTimetable timetable})? result;
    if (isLoginGuarded(context)) {
      result = await importFromFile();
    } else {
      result = await importFromSchoolServer();
    }

    if (result != null) {
      if (Settings.timetable.autoUseImported) {
        TimetableInit.storage.timetable.selectedId = result.id;
      } else {
        // use this timetable if no one else
        TimetableInit.storage.timetable.selectedId ??= result.id;
      }
    }
  }

  Future<({int id, SitTimetable timetable})?> importFromSchoolServer() async {
    return await context.push<({int id, SitTimetable timetable})>("/timetable/import");
  }

  Future<({int id, SitTimetable timetable})?> importFromFile() async {
    try {
      return await importTimetableFromFile();
    } catch (err, stackTrace) {
      // TODO: Handle permission error
      debugPrint(err.toString());
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return null;
      context.showSnackBar(content: "Format Error. Please select a timetable file.".text());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final timetables = TimetableInit.storage.timetable.getRows();
    final selectedId = TimetableInit.storage.timetable.selectedId;
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            floating: true,
            title: i18n.mine.title.text(),
            actions: [
              if (!Settings.focusTimetable)
                IconButton(
                  icon: const Icon(Icons.color_lens_outlined),
                  onPressed: () {
                    context.push("/timetable/p13n");
                  },
                ),
            ],
          ),
          if (timetables.isEmpty)
            SliverFillRemaining(
              child: LeavingBlank(
                icon: Icons.calendar_month_rounded,
                desc: i18n.mine.emptyTip,
                onIconTap: goImport,
              ),
            )
          else
            SliverList.builder(
              itemCount: timetables.length,
              itemBuilder: (ctx, i) {
                final (:id, row: timetable) = timetables[i];
                return buildTimetableCard(
                  id,
                  timetable,
                  selected: selectedId == id,
                ).padH(6);
              },
            ),
          const SliverFillRemaining(),
        ],
      ),
      floatingActionButton: AutoHideFAB.extended(
        controller: scrollController,
        onPressed: goImport,
        label: Text(isLoginGuarded(context) ? i18n.import.fromFile : i18n.import.import),
        icon: const Icon(Icons.add_outlined),
      ),
    );
  }

  Widget buildTimetableCard(
    int id,
    SitTimetable timetable, {
    required bool selected,
  }) {
    final year = '${timetable.schoolYear}–${timetable.schoolYear + 1}';
    final semester = timetable.semester.localized();
    final textTheme = context.textTheme;

    return EntryCard(
      title: timetable.name,
      selected: selected,
      selectAction: (ctx) => EntrySelectAction(
        selectLabel: i18n.use,
        selectedLabel: i18n.used,
        action: () async {
          TimetableInit.storage.timetable.selectedId = id;
        },
      ),
      deleteAction: (ctx) => EntryDeleteAction(
        label: i18n.delete,
        action: () async {
          final confirm = await ctx.showRequest(
            title: i18n.mine.deleteRequest,
            desc: i18n.mine.deleteRequestDesc,
            yes: i18n.delete,
            no: i18n.cancel,
            highlight: true,
          );
          if (confirm != true) return;
          TimetableInit.storage.timetable.delete(id);
          if (TimetableInit.storage.timetable.isEmpty) {
            if (!ctx.mounted) return;
            ctx.pop();
          }
        },
      ),
      detailsAction: (ctx) => EntryDetailsAction(
        label: i18n.mine.details,
        icon: Icons.details,
      ),
      actions: (ctx) => [
        if (!selected)
          EntryAction(
            main: true,
            label: i18n.preview,
            icon: Icons.preview,
            cupertinoIcon: CupertinoIcons.eye,
            action: () async {
              if (!mounted) return;
              await ctx.push("/timetable/preview/$id", extra: timetable);
            },
          ),
        EntryAction(
          label: i18n.edit,
          icon: Icons.edit,
          cupertinoIcon: CupertinoIcons.pencil,
          type: EntryActionType.edit,
          oneShot: true,
          action: () async {
            final newTimetable = await ctx.show$Sheet$<SitTimetable>(
              (ctx) => TimetableEditor(timetable: timetable),
            );
            if (newTimetable != null) {
              TimetableInit.storage.timetable[id] = newTimetable;
            }
          },
        ),
        EntryAction(
          label: i18n.share,
          icon: Icons.output_outlined,
          cupertinoIcon: CupertinoIcons.share,
          type: EntryActionType.share,
          action: () async {
            await exportTimetableFileAndShare(timetable, context: ctx);
          },
        ),
        EntryAction(
          label: i18n.mine.exportCalendar,
          icon: Icons.calendar_month,
          cupertinoIcon: CupertinoIcons.calendar_badge_plus,
          action: () async {
            await onExportCalendar(timetable);
          },
        ),
      ],
      detailsBuilder: (ctx) {
        final palette = TimetableInit.storage.palette.selectedRow ?? BuiltinTimetablePalettes.classic;
        return CustomScrollView(
          slivers: [
            SliverList.list(children: [
              ListTile(
                leading: const Icon(Icons.drive_file_rename_outline),
                title: i18n.editor.name.text(),
                subtitle: timetable.name.text(),
              ),
              ListTile(
                leading: const Icon(Icons.date_range),
                title: i18n.startWith.text(),
                subtitle: context.formatYmdText(timetable.startDate).text(),
              ),
              ListTile(
                leading: const Icon(Icons.drive_file_rename_outline),
                title: i18n.signature.text(),
                subtitle: timetable.signature .text(),
              ),
              const Divider(),
            ]),
            SliverList.builder(
              itemCount: timetable.courseKey2Entity.length,
              itemBuilder: (ctx, i) {
                return TimetableCourseCard(
                  timetable.courseKey2Entity[i],
                  palette: palette,
                );
              },
            )
          ],
        );
      },
      itemBuilder: (ctx, animation) => [
        timetable.name.text(style: textTheme.titleLarge),
        "$year, $semester".text(style: textTheme.titleMedium),
        if (timetable.signature.isNotEmpty) timetable.signature.text(style: textTheme.titleMedium),
        "${i18n.startWith} ${context.formatYmdText(timetable.startDate)}".text(style: textTheme.bodyLarge),
      ],
    );
  }

  Future<void> onExportCalendar(SitTimetable timetable) async {
    final config = await context.show$Sheet$<TimetableExportCalendarConfig>(
        (context) => TimetableExportCalendarConfigEditor(timetable: timetable));
    if (config == null) return;
    if (!mounted) return;
    await exportTimetableAsICalendarAndOpen(
      context,
      timetable: timetable.resolve(),
      config: config,
    );
  }
}
