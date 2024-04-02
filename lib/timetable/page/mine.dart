import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/adaptive/menu.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/widgets/entry_card.dart';
import 'package:sit/design/widgets/fab.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/route.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/page/ical.dart';
import 'package:sit/timetable/platte.dart';
import 'package:sit/timetable/widgets/course.dart';
import 'package:sit/utils/format.dart';
import 'package:text_scroll/text_scroll.dart';

import '../entity/platte.dart';
import '../i18n.dart';
import '../entity/timetable.dart';
import '../init.dart';
import '../utils.dart';
import '../widgets/focus.dart';
import '../widgets/style.dart';
import 'preview.dart';

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
    final timetable = await readTimetableFromFileWithPrompt(context);
    if (timetable == null) return null;
    final id = TimetableInit.storage.timetable.add(timetable);
    if (!mounted) return null;
    return (id: id, timetable: timetable);
  }

  @override
  Widget build(BuildContext context) {
    final timetables = TimetableInit.storage.timetable.getRows();
    final selectedId = TimetableInit.storage.timetable.selectedId;
    final actions = [
      if (Settings.focusTimetable)
        buildMoreActionsButton()
      else
        PlatformIconButton(
          icon: const Icon(Icons.color_lens_outlined),
          onPressed: () {
            context.push("/timetable/p13n");
          },
        ),
    ];
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          if (timetables.isEmpty)
            SliverAppBar(
              title: i18n.mine.title.text(),
              actions: actions,
            )
          else
            SliverAppBar.medium(
              title: i18n.mine.title.text(),
              actions: actions,
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
                return TimetableCard(
                  id: id,
                  timetable: timetable,
                  selected: selectedId == id,
                  allTimetableNames: timetables.map((t) => t.row.name).toList(),
                ).padH(6);
              },
            ),
        ],
      ),
      floatingActionButton: AutoHideFAB.extended(
        controller: scrollController,
        onPressed: goImport,
        label: Text(isLoginGuarded(context) ? i18n.import.fromFile : i18n.import.import),
        icon: Icon(context.icons.add),
      ),
    );
  }

  Widget buildMoreActionsButton() {
    final focusMode = Settings.focusTimetable;
    return PullDownMenuButton(
      itemBuilder: (ctx) => [
        PullDownItem(
          icon: Icons.palette_outlined,
          title: i18n.p13n.palette.title,
          onTap: () async {
            await context.push("/timetable/p13n");
          },
        ),
        PullDownItem(
          icon: Icons.view_comfortable_outlined,
          title: i18n.p13n.cell.title,
          onTap: () async {
            await context.push("/timetable/cell-style");
          },
        ),
        PullDownItem(
          icon: Icons.image_outlined,
          title: i18n.p13n.background.title,
          onTap: () async {
            await context.push("/timetable/background");
          },
        ),
        if (focusMode) ...buildFocusPopupActions(context),
        const PullDownDivider(),
        PullDownSelectable(
          title: i18n.focusTimetable,
          selected: focusMode,
          onTap: () async {
            Settings.focusTimetable = !focusMode;
          },
        ),
      ],
    );
  }
}

class TimetableCard extends StatelessWidget {
  final SitTimetable timetable;
  final int id;
  final bool selected;
  final List<String>? allTimetableNames;

  const TimetableCard({
    super.key,
    required this.timetable,
    required this.id,
    required this.selected,
    this.allTimetableNames,
  });

  @override
  Widget build(BuildContext context) {
    final year = '${timetable.schoolYear}–${timetable.schoolYear + 1}';
    final semester = timetable.semester.l10n();
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
      deleteAction: (ctx) => EntryAction.delete(
        label: i18n.delete,
        icon: context.icons.delete,
        action: () async {
          final confirm = await ctx.showDialogRequest(
            title: i18n.mine.deleteRequest,
            desc: i18n.mine.deleteRequestDesc,
            yes: i18n.delete,
            no: i18n.cancel,
            destructive: true,
          );
          if (confirm != true) return;
          TimetableInit.storage.timetable.delete(id);
          if (TimetableInit.storage.timetable.isEmpty) {
            if (!ctx.mounted) return;
            ctx.pop();
          }
        },
      ),
      actions: (ctx) => [
        if (!selected)
          EntryAction(
            main: true,
            label: i18n.preview,
            icon: ctx.icons.preview,
            activator: const SingleActivator(LogicalKeyboardKey.keyP),
            action: () async {
              if (!ctx.mounted) return;
              await context.show$Sheet$(
                (context) => TimetableStyleProv(
                  child: TimetablePreviewPage(
                    timetable: timetable,
                  ),
                ),
              );
            },
          ),
        EntryAction.edit(
          label: i18n.edit,
          icon: context.icons.edit,
          activator: const SingleActivator(LogicalKeyboardKey.keyE),
          action: () async {
            final newTimetable = await ctx.push<SitTimetable>("/timetable/edit/$id");
            if (newTimetable != null) {
              TimetableInit.storage.timetable[id] = newTimetable;
            }
          },
        ),
        EntryAction(
          label: i18n.share,
          icon: context.icons.share,
          type: EntryActionType.share,
          action: () async {
            await exportTimetableFileAndShare(timetable, context: ctx);
          },
        ),
        EntryAction(
          label: i18n.mine.exportCalendar,
          icon: context.icons.calendar,
          action: () async {
            await onExportCalendar(ctx, timetable);
          },
        ),
        EntryAction(
          label: i18n.duplicate,
          oneShot: true,
          icon: context.icons.copy,
          activator: const SingleActivator(LogicalKeyboardKey.keyD),
          action: () async {
            final duplicate = timetable.copyWith(
              name: getDuplicateFileName(timetable.name, all: allTimetableNames),
            );
            TimetableInit.storage.timetable.add(duplicate);
          },
        ),
      ],
      detailsBuilder: (ctx, actions) {
        return TimetableDetailsPage(id: id, timetable: timetable, actions: actions?.call(ctx));
      },
      itemBuilder: (ctx) => [
        timetable.name.text(style: textTheme.titleLarge),
        "$year, $semester".text(style: textTheme.titleMedium),
        if (timetable.signature.isNotEmpty) timetable.signature.text(style: textTheme.bodyMedium),
        "${i18n.startWith} ${context.formatYmdText(timetable.startDate)}".text(style: textTheme.bodyMedium),
      ],
    );
  }

  Future<void> onExportCalendar(BuildContext context, SitTimetable timetable) async {
    final config =
        await context.show$Sheet$<TimetableICalConfig>((context) => TimetableICalConfigEditor(timetable: timetable));
    if (config == null) return;
    if (!context.mounted) return;
    await exportTimetableAsICalendarAndOpen(
      context,
      timetable: timetable.resolve(),
      config: config,
    );
  }
}

class TimetableDetailsPage extends StatefulWidget {
  final int id;
  final SitTimetable timetable;
  final List<Widget>? actions;

  const TimetableDetailsPage({
    super.key,
    required this.id,
    required this.timetable,
    this.actions,
  });

  @override
  State<TimetableDetailsPage> createState() => _TimetableDetailsPageState();
}

class _TimetableDetailsPageState extends State<TimetableDetailsPage> {
  late final $row = TimetableInit.storage.timetable.listenRowChange(widget.id);
  late var timetable = widget.timetable;
  late var resolver = SitTimetablePaletteResolver(timetable);

  @override
  void initState() {
    super.initState();
    $row.addListener(refresh);
  }

  @override
  void dispose() {
    $row.removeListener(refresh);
    super.dispose();
  }

  void refresh() {
    final timetable = TimetableInit.storage.timetable[widget.id];
    if (timetable == null) {
      context.pop();
      return;
    } else {
      setState(() {
        this.timetable = timetable;
        resolver = SitTimetablePaletteResolver(timetable);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final timetable = this.timetable;
    final actions = widget.actions;
    final palette = TimetableInit.storage.palette.selectedRow ?? BuiltinTimetablePalettes.classic;
    final code2Courses = timetable.courses.values.groupListsBy((c) => c.courseCode).entries.toList();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: TextScroll(timetable.name),
            actions: actions,
          ),
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
              subtitle: timetable.signature.text(),
            ),
            const Divider(),
          ]),
          SliverList.builder(
            itemCount: code2Courses.length,
            itemBuilder: (ctx, i) {
              final MapEntry(value: courses) = code2Courses[i];
              final template = courses.first;
              return TimetableCourseCard(
                courses: courses,
                courseName: template.courseName,
                courseCode: template.courseCode,
                classCode: template.classCode,
                color: resolver.resolveColor(palette, template).byTheme(context.theme),
              );
            },
          )
        ],
      ),
    );
  }
}
