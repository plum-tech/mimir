import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/adaptive/foundation.dart';
import 'package:mimir/design/adaptive/menu.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/design/entity/dual_color.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/widgets/entry_card.dart';
import 'package:mimir/design/widgets/fab.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/intent/qrcode/page/view.dart';
import 'package:mimir/route.dart';
import 'package:mimir/school/entity/school.dart';
import 'package:mimir/utils/error.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/settings/dev.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/timetable/page/ical.dart';
import 'package:mimir/timetable/deep_link/timetable.dart';
import 'package:mimir/timetable/widgets/course.dart';
import 'package:mimir/utils/format.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uuid/uuid.dart';

import '../p13n/builtin.dart';
import '../p13n/entity/palette.dart';
import '../entity/timetable_entity.dart';
import '../i18n.dart';
import '../entity/timetable.dart';
import '../init.dart';
import '../utils/export.dart';
import '../utils/import.dart';
import '../utils/sync.dart';
import '../widgets/focus.dart';
import '../p13n/widget/style.dart';
import 'import.dart';
import 'preview.dart';

class MyTimetableListPage extends ConsumerStatefulWidget {
  const MyTimetableListPage({super.key});

  @override
  ConsumerState<MyTimetableListPage> createState() => _MyTimetableListPageState();
}

class _MyTimetableListPageState extends ConsumerState<MyTimetableListPage> {
  @override
  Widget build(BuildContext context) {
    final storage = TimetableInit.storage.timetable;
    final timetables = ref.watch(storage.$rows);
    final selectedId = ref.watch(storage.$selectedId);
    timetables.sort((a, b) => b.row.lastModified.compareTo(a.row.lastModified));

    if (timetables.isEmpty) {
      return buildEmptyTimetableBody();
    } else {
      return buildTimetablesBody(
        timetables: timetables,
        selectedId: selectedId,
      );
    }
  }

  Widget buildFab() {
    return FloatingActionButton.extended(
      onPressed: goImport,
      label: Text(isLoginGuarded(context) ? i18n.import.fromFile : i18n.import.import),
      icon: Icon(context.icons.add),
    );
  }

  List<Widget> buildActions() {
    final focusMode = ref.watch(Settings.timetable.$focusTimetable);
    return [
      if (focusMode)
        buildMoreActionsButton()
      else
        PlatformIconButton(
          icon: const Icon(Icons.color_lens_outlined),
          onPressed: () {
            context.push("/timetable/palettes");
          },
        ),
    ];
  }

  Widget buildEmptyTimetableBody() {
    return Scaffold(
      appBar: AppBar(
        title: i18n.mine.title.text(),
        actions: buildActions(),
      ),
      floatingActionButton: buildFab(),
      body: LeavingBlank(
        icon: Icons.calendar_month_rounded,
        desc: i18n.mine.emptyTip,
        action: FilledButton(
          onPressed: goImport,
          child: i18n.import.import.text(),
        ),
      ),
    );
  }

  Widget buildTimetablesBody({
    required List<({int id, Timetable row})> timetables,
    required int? selectedId,
  }) {
    return Scaffold(
      floatingActionButton: buildFab(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: i18n.mine.title.text(),
            actions: buildActions(),
          ),
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
          const FloatingActionButtonSpace().sliver(),
        ],
      ),
    );
  }

  /// Import a new timetable.
  /// Updates the selected timetable id.
  /// If [TimetableSettings.autoUseImported] is enabled, the newly-imported will be used.
  Future<void> goImport() async {
    Timetable? timetable;
    final fromFile = isLoginGuarded(context);
    if (fromFile) {
      timetable = await importFromFile();
    } else {
      timetable = await importFromSchoolServer();
    }
    if (timetable == null) return;
    // process timetable imported from file
    // if (fromFile) {
    //   if (!mounted) return;
    //   final newTimetable = await processImportedTimetable(context, timetable);
    //   if (newTimetable == null) return;
    //   timetable = newTimetable;
    // }

    // prevent duplicate names
    // timetable = timetable.copyWith(
    //   name: allocValidFileName(
    //     timetable.name,
    //     all: TimetableInit.storage.timetable.getRows().map((e) => e.row.name).toList(growable: false),
    //   ),
    // );
    final id = TimetableInit.storage.timetable.add(timetable);

    if (Settings.timetable.autoUseImported) {
      TimetableInit.storage.timetable.selectedId = id;
    } else {
      // use this timetable if no one else
      TimetableInit.storage.timetable.selectedId ??= id;
    }
  }

  Future<Timetable?> importFromSchoolServer() async {
    return await context.push<Timetable>("/timetable/import");
  }

  Future<Timetable?> importFromFile() async {
    final timetable = await readTimetableFromPickedFileWithPrompt(context);
    if (timetable == null) return null;
    if (!mounted) return null;
    return timetable;
  }

  Widget buildMoreActionsButton() {
    final focusMode = ref.watch(Settings.timetable.$focusTimetable);
    return PullDownMenuButton(
      itemBuilder: (ctx) => [
        PullDownItem(
          icon: Icons.palette_outlined,
          title: i18n.p13n.palette.title,
          onTap: () async {
            await context.push("/timetable/palettes");
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
            Settings.timetable.focusTimetable = !focusMode;
          },
        ),
      ],
    );
  }
}

Future<void> editTimetablePatch({
  required BuildContext context,
  required int id,
}) async {
  var timetable = await context.push<Timetable>("/timetable/patch/edit/$id");
  if (timetable == null) return;
  TimetableInit.storage.timetable[id] = timetable.markModified();
}

class TimetableCard extends StatefulWidget {
  final Timetable timetable;
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
  State<TimetableCard> createState() => _TimetableCardState();
}

class _TimetableCardState extends State<TimetableCard> {
  var syncing = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: syncing ? 0.5 : 1,
      duration: Durations.medium1,
      child: AbsorbPointer(
        absorbing: syncing,
        child: buildCard(),
      ),
    );
  }

  Widget buildCard() {
    final timetable = widget.timetable;
    final selected = widget.selected;
    final id = widget.id;
    final allTimetableNames = widget.allTimetableNames;
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
          final confirm = await ctx.showActionRequest(
            title: i18n.mine.deleteRequest,
            action: i18n.delete,
            desc: i18n.mine.deleteRequestDesc,
            cancel: i18n.cancel,
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
              await previewTimetable(
                context,
                timetable: timetable,
              );
            },
          ),
        EntryAction.edit(
          label: i18n.edit,
          icon: context.icons.edit,
          activator: const SingleActivator(LogicalKeyboardKey.keyE),
          action: () async {
            var newTimetable = await ctx.push<Timetable>("/timetable/edit/$id");
            if (newTimetable == null) return;
            final newName = allocValidFileName(newTimetable.name);
            if (newName != newTimetable.name) {
              newTimetable = newTimetable.copyWith(name: newName);
            }
            TimetableInit.storage.timetable[id] = newTimetable.markModified();
          },
        ),
        // share_plus: sharing files is not supported on Linux
        if (!UniversalPlatform.isLinux)
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
          label: i18n.mine.patch,
          icon: Icons.dashboard_customize,
          action: () async {
            await editTimetablePatch(context: ctx, id: id);
          },
        ),
        if (kDebugMode)
          EntryAction(
            icon: context.icons.copy,
            label: "Copy Dart code",
            action: () async {
              final code = timetable.toDartCode();
              debugPrint(code);
              await Clipboard.setData(ClipboardData(text: code));
            },
          ),
        if (!kIsWeb && Dev.on)
          EntryAction(
            icon: context.icons.qrcode,
            label: i18n.shareQrCode,
            action: () async {
              final qrCodeData = const TimetableDeepLink().encode(timetable);
              await context.showSheet(
                (context) => QrCodePage(
                  title: timetable.name,
                  data: qrCodeData.toString(),
                ),
              );
            },
          ),
        if (!kIsWeb && canSyncTimetable(timetable))
          EntryAction(
            icon: Icons.sync,
            label: i18n.sync,
            action: () async {
              try {
                setState(() {
                  syncing = true;
                });
                final merged = await syncTimetable(context, timetable);
                if (merged != null) {
                  TimetableInit.storage.timetable[id] = merged;
                }
                setState(() {
                  syncing = false;
                });
              } catch (error, stackTrace) {
                debugPrintError(error, stackTrace);
                if (!mounted) return;
                setState(() {
                  syncing = false;
                });
                await context.showTip(
                  title: i18n.import.failed,
                  desc: error is DioException ? i18n.import.networkFailedDesc : i18n.import.failedDesc,
                  primary: i18n.ok,
                );
              }
            },
          ),
        EntryAction(
          label: i18n.duplicate,
          oneShot: true,
          icon: context.icons.copy,
          activator: const SingleActivator(LogicalKeyboardKey.keyD),
          action: () async {
            final duplicate = timetable.copyWith(
              uuid: const Uuid().v4(),
              name: getDuplicateFileName(timetable.name, all: allTimetableNames),
              lastModified: DateTime.now(),
            );
            TimetableInit.storage.timetable.add(duplicate);
          },
        ),
      ],
      detailsBuilder: (ctx, actions) {
        return TimetableStyleProv(
          child: TimetableDetailsPage(
            id: id,
            timetable: timetable,
            actions: actions?.call(ctx),
          ),
        );
      },
      itemBuilder: (ctx) {
        return TimetableInfo(timetable: timetable);
      },
    );
  }

  Future<void> onExportCalendar(BuildContext context, Timetable timetable) async {
    final config = await context.showSheet<TimetableICalConfig>(
      (context) => TimetableICalConfigEditor(
        timetable: timetable,
      ),
    );
    if (config == null) return;
    if (!context.mounted) return;
    await exportTimetableAsICalendarAndOpen(
      context,
      timetable: timetable.resolve(),
      config: config,
    );
  }
}

class TimetableInfo extends StatelessWidget {
  final Timetable timetable;

  const TimetableInfo({
    super.key,
    required this.timetable,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final year = '${timetable.schoolYear}–${timetable.schoolYear + 1}';
    final semester = timetable.semester.l10n();
    final author = [timetable.studentId, timetable.signature].join(" ");
    return [
      timetable.name.text(style: textTheme.titleLarge),
      "$year, $semester".text(style: textTheme.titleMedium),
      if (author.isNotEmpty) author.text(style: textTheme.bodyMedium),
      "${i18n.startWith} ${context.formatYmdText(timetable.startDate)}".text(style: textTheme.bodyMedium),
    ].column(caa: CrossAxisAlignment.start);
  }
}

class TimetableDetailsPage extends ConsumerWidget {
  final int id;
  final Timetable timetable;
  final List<Widget>? actions;

  const TimetableDetailsPage({
    super.key,
    required this.id,
    required this.timetable,
    this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timetable = ref.watch(TimetableInit.storage.timetable.$rowOf(id)) ?? this.timetable;
    final resolver = TimetablePaletteResolver(timetable);
    final palette = ref.watch(TimetableInit.storage.palette.$selectedRow) ?? BuiltinTimetablePalettes.classic;
    final code2Courses = timetable.courses.values.groupListsBy((c) => c.courseCode).entries.toList();
    final style = TimetableStyle.of(context);
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
              leading: const Icon(Icons.create),
              title: i18n.createdWhen.text(),
              subtitle: context.formatYmdText(timetable.createdTime).text(),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: i18n.signature.text(),
              subtitle: timetable.signature.text(),
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: StudentType.l10nTitle().text(),
              subtitle: timetable.studentType.l10n().text(),
            ),
          ]),
          if (code2Courses.isNotEmpty) const SliverToBoxAdapter(child: Divider()),
          SliverList.builder(
            itemCount: code2Courses.length,
            itemBuilder: (ctx, i) {
              final MapEntry(value: courses) = code2Courses[i];
              final template = courses.first;
              final color = resolver.resolveColor(palette, template).colorBy(context);
              return TimetableCourseCard(
                courses: courses,
                courseName: template.courseName,
                courseCode: template.courseCode,
                classCode: template.classCode,
                campus: timetable.campus,
                color: style.cellStyle.decorateColor(color, themeColor: ctx.colorScheme.primary),
              );
            },
          )
        ],
      ),
    );
  }
}

Future<void> onTimetableFromFile({
  required BuildContext context,
  required Timetable timetable,
}) async {
  final newTimetable = await processImportedTimetable(
    context,
    timetable,
    useRootNavigator: true,
  );
  if (newTimetable == null) return;
  final id = TimetableInit.storage.timetable.add(timetable);
  if (Settings.timetable.autoUseImported) {
    TimetableInit.storage.timetable.selectedId = id;
  } else {
    TimetableInit.storage.timetable.selectedId ??= id;
  }
  await HapticFeedback.mediumImpact();
  if (!context.mounted) return;
  context.push("/timetable/mine");
}
