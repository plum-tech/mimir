import 'dart:io';

import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/utils/permission.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/adaptive/foundation.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/design/entity/dual_color.dart';
import 'package:mimir/design/widget/entry_card.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/intent/qrcode/page/view.dart';
import 'package:mimir/timetable/p13n/entity/palette.dart';
import 'package:mimir/timetable/entity/timetable.dart';
import 'package:mimir/timetable/init.dart';
import 'package:mimir/utils/format.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:uuid/uuid.dart';

import '../../i18n.dart';
import '../../deep_link/palette.dart';
import '../builtin.dart';
import '../utils/generate.dart';
import '../widget/style.dart';
import '../../widget/timetable/weekly.dart';
import 'palette_editor.dart';
import '../../page/preview.dart';

class TimetablePaletteListPage extends ConsumerStatefulWidget {
  final int? tab;

  const TimetablePaletteListPage({
    super.key,
    this.tab,
  }) : assert(tab == null || (0 <= tab && tab < TimetableP13nTab.length), "#$tab tab not found");

  @override
  ConsumerState<TimetablePaletteListPage> createState() => _TimetableP13nPageState();
}

class TimetableP13nTab {
  static const length = 2;
  static const custom = 0;
  static const builtin = 1;
}

class _TimetableP13nPageState extends ConsumerState<TimetablePaletteListPage> with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: TimetableP13nTab.length);
    final selectedId = TimetableInit.storage.palette.selectedId;
    final forceTab = widget.tab;
    if (forceTab != null) {
      tabController.index = forceTab.clamp(TimetableP13nTab.custom, TimetableP13nTab.builtin);
    } else if (selectedId == null || BuiltinTimetablePalettes.all.any((palette) => palette.uuid == selectedId)) {
      tabController.index = TimetableP13nTab.builtin;
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palettes = ref.watch(TimetableInit.storage.palette.$rows);
    return Scaffold(
      persistentFooterButtons: [
        FilledButton.tonalIcon(
          onPressed: generateFromImage,
          icon: const Icon(Icons.generating_tokens_outlined),
          label:i18n.p13n.palette.generate.text(),
        ),
        FilledButton.icon(
          onPressed: addPalette,
          icon: Icon(context.icons.add),
          label: i18n.p13n.palette.create.text(),
        ),
      ],
      persistentFooterAlignment: AlignmentDirectional.center,
      appBar: AppBar(
        title: i18n.p13n.palette.title.text(),
        bottom: TabBar(
          controller: tabController,
          isScrollable: true,
          tabs: [
            Tab(child: i18n.p13n.palette.customTab.text()),
            Tab(child: i18n.p13n.palette.builtinTab.text()),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          buildPaletteList(palettes),
          buildPaletteList(BuiltinTimetablePalettes.all),
        ],
      ),
    );
  }

  Future<void> addPalette() async {
    final palette = TimetablePalette.create(
      name: i18n.p13n.palette.newPaletteName,
      author: Settings.lastSignature ?? "",
      colors: [],
    );
    final uuid = TimetableInit.storage.palette.add(palette);
    tabController.index = TimetableP13nTab.custom;
    await editTimetablePalette(
      context: context,
      uuid: uuid,
    );
  }

  Future<void> generateFromImage() async {
    final context = this.context;
    await requestPermission(context, Permission.photos);
    final picker = ImagePicker();
    final XFile? fi = await picker.pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false,
    );
    if (fi == null) return;
    if (kIsWeb) {
      final bytes = await fi.readAsBytes();
      if (!context.mounted) return;
      await addPaletteFromImageByGenerator(
        context,
        MemoryImage(bytes),
      );
    } else {
      if (!context.mounted) return;
      await addPaletteFromImageByGenerator(
        context,
        FileImage(File(fi.path)),
      );
    }
  }

  Widget buildPaletteList(List<TimetablePalette> palettes) {
    final selectedId = ref.watch(TimetableInit.storage.palette.$selectedId) ?? BuiltinTimetablePalettes.classic.uuid;
    final selectedTimetable = ref.watch(TimetableInit.storage.timetable.$selectedRow);
    palettes = palettes.sorted((a, b) => b.lastModified.compareTo(a.lastModified));
    return ListView.builder(
      itemCount: palettes.length,
      itemBuilder: (ctx, i) {
        final palette = palettes[i];
        return PaletteCard(
          palette: palette,
          timetable: selectedTimetable,
          selected: selectedId == palette.uuid,
          onDuplicate: () {
            tabController.index = TimetableP13nTab.custom;
          },
          allPaletteNames: palettes.map((p) => p.name).toList(),
        ).padH(6);
      },
    );
  }
}

class PaletteCard extends StatelessWidget {
  final TimetablePalette palette;
  final bool selected;
  final Timetable? timetable;
  final VoidCallback? onDuplicate;
  final List<String>? allPaletteNames;

  const PaletteCard({
    super.key,
    required this.palette,
    required this.selected,
    this.timetable,
    this.onDuplicate,
    this.allPaletteNames,
  });

  @override
  Widget build(BuildContext context) {
    final timetable = this.timetable;
    return EntryCard(
      title: palette.name,
      selected: selected,
      selectAction: (ctx) => palette.colors.isEmpty
          ? null
          : EntrySelectAction(
              selectLabel: i18n.use,
              selectedLabel: i18n.used,
              action: () async {
                TimetableInit.storage.palette.selectedId = palette.uuid;
              },
            ),
      deleteAction: palette is BuiltinTimetablePalette
          ? null
          : (ctx) => EntryAction.delete(
                label: i18n.delete,
                icon: context.icons.delete,
                action: () async {
                  final confirm = await ctx.showDialogRequest(
                    title: i18n.p13n.palette.deleteRequest,
                    desc: i18n.p13n.palette.deleteRequestDesc,
                    primary: i18n.delete,
                    secondary: i18n.cancel,
                    primaryDestructive: true,
                  );
                  if (confirm == true) {
                    TimetableInit.storage.palette.delete(palette.uuid);
                  }
                },
              ),
      actions: (ctx) => [
        if (timetable != null && palette.colors.isNotEmpty)
          EntryAction(
            main: true,
            label: i18n.preview,
            icon: isCupertino ? CupertinoIcons.eye : Icons.preview,
            activator: const SingleActivator(LogicalKeyboardKey.keyP),
            action: () async {
              await previewTimetable(
                context,
                timetable: timetable,
                palette: palette,
              );
            },
          ),
        if (palette is! BuiltinTimetablePalette)
          EntryAction.edit(
            label: i18n.edit,
            icon: context.icons.edit,
            activator: const SingleActivator(LogicalKeyboardKey.keyE),
            action: () async {
              await editTimetablePalette(
                context: context,
                uuid: palette.uuid,
              );
            },
          ),
        EntryAction(
          label: i18n.duplicate,
          icon: context.icons.copy,
          oneShot: true,
          activator: const SingleActivator(LogicalKeyboardKey.keyD),
          action: () async {
            final duplicate = palette
                .copyWith(
                  uuid: const Uuid().v4(),
                  name: allocValidFileName(palette.name, all: allPaletteNames),
                  author: palette.author,
                  colors: List.of(palette.colors),
                )
                .markModified();
            TimetableInit.storage.palette.add(duplicate);
            onDuplicate?.call();
          },
        ),
        // Uint64 is not supporting on web
        if (!kIsWeb)
          EntryAction(
            label: i18n.shareQrCode,
            icon: context.icons.qrcode,
            action: () async {
              final qrCodeData = const TimetablePaletteDeepLink().encode(palette);
              await ctx.showSheet(
                (context) => QrCodePage(
                  title: palette.name,
                  data: qrCodeData.toString(),
                ),
              );
            },
          ),
        if (kDebugMode)
          EntryAction(
            icon: context.icons.copy,
            label: "Copy Dart code",
            action: () async {
              final code = palette.colors.toString();
              debugPrint(code);
              await Clipboard.setData(ClipboardData(text: code));
            },
          ),
      ],
      detailsBuilder: (ctx, actions) {
        return PaletteDetailsPage(
          palette: palette,
          actions: actions?.call(ctx),
        );
      },
      itemBuilder: (ctx) {
        return PaletteInfo(palette: palette);
      },
    );
  }
}

Future<void> editTimetablePalette({
  required BuildContext context,
  required String uuid,
}) async {
  var newPalette = await context.push<TimetablePalette>("/timetable/palette/edit/$uuid");
  if (newPalette != null) {
    final newName = allocValidFileName(newPalette.name);
    if (newName != newPalette.name) {
      newPalette = newPalette
          .copyWith(
            name: newName,
            colors: List.of(newPalette.colors),
          )
          .markModified();
    }
    TimetableInit.storage.palette[uuid] = newPalette;
  }
}

class PaletteInfo extends StatelessWidget {
  final TimetablePalette palette;

  const PaletteInfo({
    super.key,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return [
      palette.name.text(style: context.textTheme.titleLarge),
      if (palette.author.isNotEmpty)
        palette.author.text(
          style: const TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
      PaletteColorsPreview(palette.colors),
    ].column(caa: CrossAxisAlignment.start);
  }
}

class PaletteDetailsPage extends ConsumerWidget {
  final TimetablePalette palette;
  final List<Widget>? actions;

  const PaletteDetailsPage({
    super.key,
    required this.palette,
    this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(TimetableInit.storage.palette.$rowOf(this.palette.uuid)) ?? this.palette;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: TextScroll(palette.name),
            actions: actions,
          ),
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
              TimetableStyleProv(
                palette: palette,
                child: const TimetableP13nLivePreview(),
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
      ),
    );
  }
}

class PaletteColorsPreview extends StatelessWidget {
  final List<DualColor> colors;

  const PaletteColorsPreview(this.colors, {super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = context.theme.brightness;
    return colors
        .map((c) {
          final color = c.byBrightness(brightness);
          final textColor = (context.brightness == brightness ? color : color.copyWith(inverseText: !color.inverseText))
              .textColor(context);
          return Card.outlined(
            margin: EdgeInsets.zero,
            child: TweenAnimationBuilder(
              tween: ColorTween(begin: color.color, end: color.color),
              duration: const Duration(milliseconds: 300),
              builder: (ctx, value, child) => ColorSquareCard(
                color: value,
                textColor: textColor,
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
  const TimetableP13nLivePreview({
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
    final style = TimetableStyle.of(context);
    final cellStyle = style.cellStyle;
    final palette = style.platte;
    final cellSize = Size(fullSize.width / 5, fullSize.height / 3);
    final themeColor = context.colorScheme.primary;
    Widget buildCell({
      required int colorId,
      required String name,
      required String place,
      required List<String> teachers,
      bool grayOut = false,
    }) {
      final colorEntry = palette.safeGetColor(colorId);
      final textColor = colorEntry.textColorBy(context);
      var color = colorEntry.colorBy(context);
      color = cellStyle.decorateColor(color, themeColor: themeColor, isLessonTaken: grayOut);
      return TweenAnimationBuilder(
        tween: ColorTween(begin: color, end: color),
        duration: const Duration(milliseconds: 300),
        builder: (ctx, value, child) => CourseCell(
          courseName: name,
          color: value!,
          textColor: textColor,
          place: place,
          teachers: cellStyle.showTeachers ? teachers : null,
        ),
      );
    }

    Widget livePreview(
      int index, {
      required int colorId,
      bool grayOut = false,
    }) {
      final data = i18n.p13n.livePreview(index);
      return buildCell(
        colorId: colorId,
        name: data.name,
        place: data.place,
        teachers: data.teachers,
        grayOut: grayOut,
      );
    }

    final grayOut = cellStyle.grayOutTakenLessons;
    return CarouselSlider.builder(
      itemCount: palette.colors.length,
      options: CarouselOptions(
        height: cellSize.height,
        viewportFraction: 0.24,
        enableInfiniteScroll: true,
        padEnds: false,
        autoPlay: true,
        autoPlayInterval: const Duration(milliseconds: 1500),
        autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
      ),
      itemBuilder: (BuildContext context, int i, int pageViewIndex) {
        return livePreview(i % 4, colorId: i, grayOut: grayOut && i % 4 < 2).padH(8);
      },
    );
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
  final newPalette = await context.showSheet<TimetablePalette>(
    (ctx) => TimetablePaletteEditorPage(palette: palette),
    dismissible: false,
  );
  if (newPalette == null) return;
  TimetableInit.storage.palette.add(newPalette);
  await HapticFeedback.mediumImpact();
  if (!context.mounted) return;
  context.push("/timetable/palettes/custom");
}

class ColorSquareCard extends StatelessWidget {
  final Color? color;
  final Color? textColor;

  const ColorSquareCard({
    this.color,
    this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      margin: EdgeInsets.zero,
      color: color,
      child: SizedBox(
        width: 32,
        height: 32,
        child: "A"
            .text(
                style: context.textTheme.bodyLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ))
            .center(),
      ),
    );
  }
}
