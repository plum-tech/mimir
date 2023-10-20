import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/entry_card.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/qrcode/page.dart';
import 'package:sit/qrcode/protocol.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/entity/platte.dart';
import 'package:sit/timetable/init.dart';
import 'package:sit/timetable/platte.dart';
import 'package:sit/utils/color.dart';

import '../i18n.dart';
import '../widgets/style.dart';
import '../widgets/timetable/weekly.dart';
import 'palette.dart';
import 'preview.dart';

class TimetableP13nPage extends StatefulWidget {
  final int? tab;

  const TimetableP13nPage({
    super.key,
    this.tab,
  }) : assert(tab == null || (0 <= tab && tab < TimetableP13nTab.length), "#$tab tab not found");

  @override
  State<TimetableP13nPage> createState() => _TimetableP13nPageState();
}

class TimetableP13nTab {
  static const length = 2;
  static const custom = 0;
  static const builtin = 1;
}

class _TimetableP13nPageState extends State<TimetableP13nPage> with SingleTickerProviderStateMixin {
  final $paletteList = TimetableInit.storage.palette.$any;
  late final TabController tabController;
  final $selected = TimetableInit.storage.timetable.$selected;
  var selectedTimetable = TimetableInit.storage.timetable.selectedRow;
  late final $brightness = ValueNotifier(context.theme.brightness);

  @override
  void initState() {
    super.initState();
    $selected.addListener(refresh);
    $paletteList.addListener(refresh);
    tabController = TabController(vsync: this, length: TimetableP13nTab.length);
    final selectedId = TimetableInit.storage.palette.selectedId;
    final forceTab = widget.tab;
    if (forceTab != null) {
      tabController.index = forceTab.clamp(TimetableP13nTab.custom, TimetableP13nTab.builtin);
    } else if (selectedId == null || BuiltinTimetablePalettes.all.any((palette) => palette.id == selectedId)) {
      tabController.index = TimetableP13nTab.builtin;
    }
  }

  @override
  void dispose() {
    $paletteList.removeListener(refresh);
    tabController.dispose();
    $selected.removeListener(refresh);
    super.dispose();
  }

  void refresh() {
    setState(() {
      selectedTimetable = TimetableInit.storage.timetable.selectedRow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: i18n.p13n.palette.fab.text(),
        icon: const Icon(Icons.add),
        onPressed: () async {
          final palette = TimetablePalette(
            name: i18n.p13n.palette.newPaletteName,
            author: "",
            colors: [],
            lastModified: DateTime.now(),
          );
          TimetableInit.storage.palette.add(palette);
          tabController.index = TimetableP13nTab.custom;
        },
      ),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                floating: true,
                title: i18n.p13n.palette.title.text(),
                forceElevated: innerBoxIsScrolled,
                actions: [
                  BrightnessSwitch($brightness),
                ],
                bottom: TabBar(
                  controller: tabController,
                  isScrollable: true,
                  tabs: [
                    Tab(child: i18n.p13n.palette.customTab.text()),
                    Tab(child: i18n.p13n.palette.builtinTab.text()),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: [
            buildPaletteList(TimetableInit.storage.palette.getRows()),
            buildPaletteList(BuiltinTimetablePalettes.all.map((e) => (id: e.id, row: e)).toList()),
          ],
        ),
      ),
    );
  }

  Widget buildPaletteList(List<({int id, TimetablePalette row})> palettes) {
    final selectedId = TimetableInit.storage.palette.selectedId ?? BuiltinTimetablePalettes.classic.id;
    palettes.sort((a, b) {
      final $a = a.row.lastModified;
      final $b = b.row.lastModified;
      if ($a == $b) return 0;
      if ($a == null) {
        return 1;
      } else if ($b == null) {
        return -1;
      }
      return $b.compareTo($a);
    });
    return CustomScrollView(
      slivers: [
        SliverList.builder(
          itemCount: palettes.length,
          itemBuilder: (ctx, i) {
            final (:id, row: palette) = palettes[i];
            return buildPaletteCard(
              id,
              palette,
              selected: selectedId == id,
            ).padH(6);
          },
        ),
      ],
    );
  }

  Widget buildPaletteCard(
    int id,
    TimetablePalette palette, {
    required bool selected,
  }) {
    final theme = context.theme;
    final selectedTimetable = this.selectedTimetable;
    return EntryCard(
      title: palette.name,
      selected: selected,
      selectAction: (ctx) => EntrySelectAction(
        selectLabel: i18n.use,
        selectedLabel: i18n.used,
        action: palette.colors.isEmpty
            ? null
            : () async {
                TimetableInit.storage.palette.selectedId = id;
              },
      ),
      deleteAction: palette is BuiltinTimetablePalette
          ? null
          : (ctx) => EntryDeleteAction(
                label: i18n.delete,
                action: () async {
                  final confirm = await ctx.showRequest(
                    title: i18n.p13n.palette.deleteRequest,
                    desc: i18n.p13n.palette.deleteRequestDesc,
                    yes: i18n.delete,
                    no: i18n.cancel,
                    highlight: true,
                  );
                  if (confirm == true) {
                    TimetableInit.storage.palette.delete(id);
                  }
                },
              ),
      detailsAction: (ctx) => EntryDetailsAction(
        label: i18n.p13n.palette.details,
        icon: Icons.details,
      ),
      actions: (ctx) => [
        if (palette is! BuiltinTimetablePalette)
          EntryAction(
            main: true,
            label: i18n.edit,
            icon: Icons.edit,
            cupertinoIcon: CupertinoIcons.pencil,
            type: EntryActionType.edit,
            oneShot: true,
            action: () async {
              await ctx.push<TimetablePalette>(
                "/timetable/p13n/palette/$id",
                extra: palette.copyWith(),
              );
            },
          ),
        if (selectedTimetable != null && palette.colors.isNotEmpty)
          EntryAction(
            label: i18n.preview,
            icon: Icons.preview,
            cupertinoIcon: CupertinoIcons.eye,
            action: () async {
              await context.navigator.push(
                MaterialPageRoute(
                  builder: (ctx) => TimetablePreviewPage(
                    timetable: selectedTimetable,
                    style: TimetableStyleData(
                      platte: palette,
                    ),
                  ),
                ),
              );
            },
          ),
        EntryAction(
          label: i18n.copy,
          icon: Icons.copy,
          oneShot: true,
          cupertinoIcon: CupertinoIcons.doc_on_clipboard,
          action: () async {
            final duplicate = palette.copyWith(
              name: i18n.p13n.palette.copyPaletteName(palette.name),
              // copy will ignore the original author
              author: "",
              lastModified: DateTime.now(),
            );
            TimetableInit.storage.palette.add(duplicate);
            tabController.index = TimetableP13nTab.custom;
          },
        ),
        EntryAction(
          label: i18n.p13n.palette.shareQrCode,
          icon: Icons.qr_code,
          cupertinoIcon: CupertinoIcons.qrcode,
          action: () async {
            final qrCodeData = const TimetablePaletteDeepLink().encode(palette);
            await ctx.show$Sheet$(
              (context) => QrCodePage(
                title: palette.name.text(),
                data: qrCodeData.toString(),
              ),
            );
          },
        ),
      ],
      detailsBuilder: (ctx) {
        return CustomScrollView(
          slivers: [
            SliverList.list(children: [
              ListTile(
                leading: const Icon(Icons.drive_file_rename_outline),
                title: i18n.p13n.palette.name.text(),
                subtitle: palette.name.text(),
              ),
              if (palette.author.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.person),
                  title: i18n.p13n.palette.author.text(),
                  subtitle: palette.author.text(),
                ),
              if (palette.colors.isNotEmpty) const Divider(),
              if (palette.colors.isNotEmpty)
                TimetableP13nLivePreview(
                  cellStyle: Settings.timetable.cell.cellStyle,
                  palette: palette,
                ),
              const Divider(),
              const LightDarkColorsHeaderTitle(),
            ]),
            SliverList.builder(
              itemCount: palette.colors.length,
              itemBuilder: (ctx, i) {
                return PaletteColorTile(colors: palette.colors[i]);
              },
            )
          ],
        );
      },
      itemBuilder: (ctx, animation) => [
        palette.name.text(style: theme.textTheme.titleLarge),
        if (palette.author.isNotEmpty)
          palette.author.text(
            style: const TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
        buildPaletteColorsPreview(palette),
      ],
    );
  }

  Widget buildPaletteColorsPreview(TimetablePalette palette) {
    return $brightness >>
        (ctx, brightness) => palette.colors
            .map((c) {
              final color = c.byBrightness(brightness);
              return OutlinedCard(
                color: brightness == Brightness.light ? Colors.black : Colors.white,
                margin: EdgeInsets.zero,
                child: TweenAnimationBuilder(
                  tween: ColorTween(begin: color, end: color),
                  duration: const Duration(milliseconds: 300),
                  builder: (ctx, value, child) => FilledCard(
                    margin: EdgeInsets.zero,
                    color: value,
                    child: const SizedBox(
                      width: 32,
                      height: 32,
                    ),
                  ),
                ),
              );
            })
            .toList()
            .wrap(spacing: 4, runSpacing: 4)
            .padV(4);
  }
}

class TimetableP13nLivePreview extends StatelessWidget {
  final CourseCellStyle cellStyle;
  final TimetablePalette palette;

  const TimetableP13nLivePreview({
    required this.cellStyle,
    required this.palette,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, box) {
      final height = box.maxHeight.isFinite ? box.maxHeight : context.mediaQuery.size.height / 2;
      return buildLivePreview(context, fullSize: Size(box.maxWidth, height));
    });
  }

  Widget buildLivePreview(
    BuildContext context, {
    required Size fullSize,
  }) {
    final cellSize = Size(fullSize.width / 5, fullSize.height / 3);
    final themeColor = context.colorScheme.primary;
    Widget buildCell({
      required int id,
      required String name,
      required String place,
      required List<String> teachers,
      bool grayOut = false,
    }) {
      var color = palette.safeGetColor(id).byTheme(context.theme);
      if (cellStyle.harmonizeWithThemeColor) {
        color = color.harmonizeWith(themeColor);
      }
      if (grayOut) {
        color = color.monochrome();
      }
      final alpha = cellStyle.alpha;
      if (alpha < 1.0) {
        color = color.withOpacity(alpha);
      }
      return SizedBox.fromSize(
        size: cellSize,
        child: TweenAnimationBuilder(
          tween: ColorTween(begin: color, end: color),
          duration: const Duration(milliseconds: 300),
          builder: (ctx, value, child) => CourseCell(
            courseName: name,
            color: value!,
            place: place,
            teachers: cellStyle.showTeachers ? teachers : null,
          ),
        ),
      );
    }

    Widget livePreview(int index, {bool grayOut = false}) {
      final data = i18n.p13n.livePreview(index);
      return buildCell(
        id: index,
        name: data.name,
        place: data.place,
        teachers: data.teachers,
        grayOut: grayOut,
      );
    }

    final grayOut = cellStyle.grayOutTakenLessons;
    return [
      livePreview(0, grayOut: grayOut),
      livePreview(1, grayOut: grayOut),
      livePreview(2),
      livePreview(3),
    ].row(maa: MainAxisAlignment.spaceEvenly);
  }
}

class BrightnessSwitch extends StatelessWidget {
  final ValueNotifier<Brightness> $brightness;

  const BrightnessSwitch(
    this.$brightness, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return $brightness >>
        (ctx, brightness) => SegmentedButton<Brightness>(
              segments: [
                ButtonSegment<Brightness>(
                  value: Brightness.light,
                  label: Brightness.light.l10n().text(),
                  icon: const Icon(Icons.light_mode),
                ),
                ButtonSegment<Brightness>(
                  value: Brightness.dark,
                  label: Brightness.dark.l10n().text(),
                  icon: const Icon(Icons.dark_mode),
                ),
              ],
              selected: <Brightness>{brightness},
              onSelectionChanged: (newSelection) async {
                $brightness.value = newSelection.first;
                await HapticFeedback.selectionClick();
              },
            );
  }
}

Future<void> onTimetablePaletteFromQrCode({
  required BuildContext context,
  required TimetablePalette palette,
}) async {
  TimetableInit.storage.palette.add(palette);
  await HapticFeedback.mediumImpact();
  if (!context.mounted) return;
  context.showSnackBar(i18n.p13n.palette.addFromQrCode.text());
  context.push("/timetable/p13n?custom");
}
