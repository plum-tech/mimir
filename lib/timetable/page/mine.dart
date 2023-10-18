import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/widgets/fab.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/route.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/page/export.dart';

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
      context.showSnackBar("Format Error. Please select a timetable file.".text());
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
              IconButton(
                onPressed: () {
                  context.push("/timetable/p13n?enableCellStyle");
                },
                icon: const Icon(Icons.color_lens_outlined),
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
                final isSelected = selectedId == id;
                return buildTimetableEntry(id, timetable, isSelected);
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

  Widget buildTimetableEntry(int id, SitTimetable timetable, bool isSelected) {
    if (!isCupertino) {
      return TimetableEntry(
        timetable: timetable,
        isSelected: TimetableInit.storage.timetable.selectedId == id,
        moreAction: buildActionPopup(id, timetable, isSelected),
        actions: (
          use: () {
            TimetableInit.storage.timetable.selectedId = id;
            setState(() {});
          },
          preview: () {
            context.push("/timetable/preview/$id", extra: timetable);
          }
        ),
      );
    }
    return Builder(
      builder: (ctx) => CupertinoContextMenu.builder(
        enableHapticFeedback: true,
        actions: [
          if (!isSelected)
            CupertinoContextMenuAction(
              trailingIcon: CupertinoIcons.check_mark,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Future.delayed(const Duration(milliseconds: 336));
                TimetableInit.storage.timetable.selectedId = id;
              },
              child: i18n.mine.use.text(),
            ),
          CupertinoContextMenuAction(
            trailingIcon: CupertinoIcons.pencil,
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await onEdit(id, timetable);
            },
            child: i18n.mine.edit.text(),
          ),
          if (!isSelected)
            CupertinoContextMenuAction(
              trailingIcon: CupertinoIcons.eye,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Future.delayed(const Duration(milliseconds: 336));
                if (!mounted) return;
                context.push("/timetable/preview/$id", extra: timetable);
              },
              child: i18n.mine.preview.text(),
            ),
          CupertinoContextMenuAction(
            trailingIcon: CupertinoIcons.doc,
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await exportTimetableFileAndShare(timetable, context: ctx);
            },
            child: i18n.mine.exportFile.text(),
          ),
          CupertinoContextMenuAction(
            trailingIcon: CupertinoIcons.calendar_badge_plus,
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await onExportCalendar(timetable);
            },
            child: i18n.mine.exportCalendar.text(),
          ),
          CupertinoContextMenuAction(
            trailingIcon: CupertinoIcons.delete,
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await onDelete(id);
            },
            isDestructiveAction: true,
            child: i18n.mine.delete.text(),
          ),
        ],
        builder: (ctx, animation) {
          return TimetableEntry(
            isSelected: TimetableInit.storage.timetable.selectedId == id,
            timetable: timetable,
            moreAction: animation.value > 0.5
                ? null
                : IconButton(
                    onPressed: isSelected
                        ? null
                        : () async {
                            TimetableInit.storage.timetable.selectedId = id;
                          },
                    icon: isSelected
                        ? Icon(CupertinoIcons.check_mark, color: context.colorScheme.primary)
                        : const Icon(CupertinoIcons.square)),
          );
        },
      ),
    );
  }

  Widget buildActionPopup(int id, SitTimetable timetable, bool isSelected) {
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      padding: EdgeInsets.zero,
      itemBuilder: (ctx) => <PopupMenuEntry>[
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.edit),
            title: i18n.mine.edit.text(),
            onTap: () async {
              ctx.pop();
              onEdit(id, timetable);
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.output_outlined),
            title: i18n.mine.exportFile.text(),
            onTap: () async {
              ctx.pop();
              await exportTimetableFileAndShare(timetable, context: context);
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.calendar_month),
            title: i18n.mine.exportCalendar.text(),
            onTap: () async {
              ctx.pop();
              await onExportCalendar(timetable);
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.delete, color: Colors.redAccent),
            title: i18n.mine.delete.text(style: const TextStyle(color: Colors.redAccent)),
            onTap: () async {
              ctx.pop();
              onDelete(id);
            },
          ),
        ),
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

  Future<void> onEdit(int id, SitTimetable timetable) async {
    final newTimetable = await context.show$Sheet$<SitTimetable>(
      (ctx) => TimetableEditor(timetable: timetable),
    );
    if (newTimetable != null) {
      TimetableInit.storage.timetable[id] = newTimetable;
    }
  }

  Future<void> onDelete(int id) async {
    final confirm = await context.showRequest(
      title: i18n.mine.deleteRequest,
      desc: i18n.mine.deleteRequestDesc,
      yes: i18n.delete,
      no: i18n.cancel,
      highlight: true,
    );
    if (confirm == true) {
      TimetableInit.storage.timetable.delete(id);
    }
  }
}

typedef TimetableActions = ({void Function() use, void Function() preview});

class TimetableEntry extends StatelessWidget {
  final SitTimetable timetable;
  final Widget? moreAction;
  final TimetableActions? actions;
  final bool isSelected;

  const TimetableEntry({
    super.key,
    required this.timetable,
    this.actions,
    this.moreAction,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final year = '${timetable.schoolYear}–${timetable.schoolYear + 1}';
    final semester = timetable.semester.localized();
    final textTheme = context.textTheme;
    final moreAction = this.moreAction;
    final actions = this.actions;
    final widget = [
      timetable.name.text(style: textTheme.titleLarge),
      "$year, $semester".text(style: textTheme.titleMedium),
      "${i18n.startWith} ${context.formatYmdText(timetable.startDate)}".text(style: textTheme.bodyLarge),
      OverflowBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          [
            if (actions != null)
              if (isSelected)
                FilledButton.icon(
                  icon: const Icon(Icons.check),
                  label: i18n.mine.used.text(),
                  onPressed: null,
                )
              else
                FilledButton(
                  onPressed: () {
                    actions.use();
                  },
                  child: i18n.mine.use.text(),
                ),
            if (actions != null)
              if (!isSelected)
                OutlinedButton(
                  onPressed: () {
                    actions.preview();
                  },
                  child: i18n.mine.preview.text(),
                )
          ].wrap(spacing: 4),
          if (moreAction != null) moreAction,
        ],
      ),
    ].column(caa: CrossAxisAlignment.start).padSymmetric(v: 10, h: 15);
    return isSelected
        ? widget.inFilledCard(
            clip: Clip.hardEdge,
          )
        : widget.inOutlinedCard(
            clip: Clip.hardEdge,
          );
  }
}
