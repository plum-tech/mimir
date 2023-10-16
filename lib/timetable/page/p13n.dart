import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/fab.dart';
import 'package:sit/qrcode/page.dart';
import 'package:sit/qrcode/protocol.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/entity/platte.dart';
import 'package:sit/timetable/init.dart';
import 'package:sit/timetable/platte.dart';

// TODO: i18n
class TimetableP13nPage extends StatefulWidget {
  const TimetableP13nPage({super.key});

  @override
  State<TimetableP13nPage> createState() => _TimetableP13nPageState();
}

class _TimetableP13nPageState extends State<TimetableP13nPage> {
  final $paletteList = TimetableInit.storage.palette.$any;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    $paletteList.addListener(refresh);
  }

  @override
  void dispose() {
    $paletteList.removeListener(refresh);
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            floating: true,
            title: "Personalization".text(),
          ),
          SliverList.list(children: [
            buildEditCellStyleTile(),
          ]),
          const SliverToBoxAdapter(
            child: Divider(),
          ),
          SliverToBoxAdapter(
            child: ListTile(
              leading: const Icon(Icons.color_lens_outlined),
              title: "Palettes".text(),
              subtitle: "How timetable colors look".text(),
            ),
          ),
          buildPaletteList(),
          const SliverFillRemaining(),
        ],
      ),
      floatingActionButton: AutoHideFAB.extended(
        controller: scrollController,
        onPressed: () {},
        label: "Palette".text(),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget buildEditCellStyleTile() {
    return ListTile(
      leading: const Icon(Icons.style_outlined),
      title: "Edit cell style".text(),
      subtitle: "How course cell looks like".text(),
      trailing: const Icon(Icons.open_in_new),
      onTap: () async {
        await context.show$Sheet$((ctx) => const TimetableCellStyleEditor());
      },
    );
  }

  Widget buildPaletteList() {
    final allIds = <int>[];
    allIds.addAll(BuiltinTimetablePalettes.all.map((e) => e.id));
    final customIdList = TimetableInit.storage.palette.idList;
    if (customIdList != null) {
      allIds.addAll(customIdList);
    }
    final selectedId = TimetableInit.storage.palette.selectedId ?? BuiltinTimetablePalettes.classic.id;
    return SliverList.builder(
      itemCount: allIds.length,
      itemBuilder: (ctx, i) {
        final id = allIds[i];
        final palette = TimetableInit.storage.palette[id];
        final isSelected = selectedId == id;
        if (palette == null) return const SizedBox();
        return PaletteCard(
          palette: palette,
          isSelected: isSelected,
          moreAction: buildActionPopup(id, palette, isSelected),
          actions: (
            use: () {
              TimetableInit.storage.palette.selectedId = id;
              setState(() {});
            },
            edit: palette is BuiltinTimetablePalette
                ? null
                : () async {
                    final newPalette = context.show$Sheet$<TimetablePalette>(
                      (context) => TimetablePaletteEditor(palette: palette.clone()),
                    );
                  },
          ),
        ).padH(12);
      },
    );
  }

  Widget buildActionPopup(int id, TimetablePalette palette, bool isSelected) {
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      padding: EdgeInsets.zero,
      itemBuilder: (ctx) => <PopupMenuEntry>[
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.copy),
            title: "Copy".text(),
            onTap: () async {
              ctx.pop();
              copyPalette(palette);
            },
          ),
        ),
        if (palette is! BuiltinTimetablePalette)
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.output_outlined),
              title: "Export file".text(),
              onTap: () async {
                ctx.pop();
              },
            ),
          ),
        if (palette is! BuiltinTimetablePalette)
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.qr_code),
              title: "Share QR code".text(),
              onTap: () async {
                ctx.pop();
                final qrCodeData = const TimetablePaletteDeepLink().encode(palette);
                context.show$Sheet$(
                  (context) => QrCodePage(
                    title: "Timetable Palette".text(),
                    data: qrCodeData.toString(),
                  ),
                );
              },
            ),
          ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.delete, color: Colors.redAccent),
            title: "Delete".text(style: const TextStyle(color: Colors.redAccent)),
            onTap: () async {
              ctx.pop();
              TimetableInit.storage.palette.delete(id);
            },
          ),
        ),
      ],
    );
  }

  void copyPalette(TimetablePalette palette) {
    final duplicate = palette.clone(getNewName: (old) => "$old-Copy");
    TimetableInit.storage.palette.add(duplicate);
  }
}

class TimetableCellStyleEditor extends StatefulWidget {
  const TimetableCellStyleEditor({super.key});

  @override
  State<TimetableCellStyleEditor> createState() => _TimetableCellStyleEditorState();
}

class _TimetableCellStyleEditorState extends State<TimetableCellStyleEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: "Cell style".text(),
          ),
          SliverList.list(children: [
            buildTeachersToggle(),
            buildFadeOutPassedLesson(),
          ]),
        ],
      ),
    );
  }

  Widget buildPreview() {
    return const Placeholder();
  }

  Widget buildTeachersToggle() {
    return StatefulBuilder(builder: (context, setState) {
      return ListTile(
        leading: const Icon(Icons.person_pin),
        title: "Teachers".text(),
        subtitle: "Show teachers in cell".text(),
        trailing: Switch.adaptive(
          value: Settings.timetable.cell.showTeachers,
          onChanged: (newV) {
            setState(() {
              Settings.timetable.cell.showTeachers = newV;
            });
          },
        ),
      );
    });
  }

  Widget buildFadeOutPassedLesson() {
    return ListTile(
      leading: const Icon(Icons.timelapse),
      title: "Fade out passed lessons".text(),
      subtitle: "Before today".text(),
      trailing: Switch.adaptive(
        value: true,
        onChanged: (newV) {},
      ),
    );
  }
}

typedef PaletteActions = ({
  void Function() use,
  void Function()? edit,
});

class PaletteCard extends StatelessWidget {
  final TimetablePalette palette;
  final Widget? moreAction;
  final bool isSelected;
  final PaletteActions? actions;

  const PaletteCard({
    super.key,
    required this.palette,
    required this.isSelected,
    this.actions,
    this.moreAction,
  });

  @override
  Widget build(BuildContext context) {
    final moreAction = this.moreAction;
    final actions = this.actions;
    final textTheme = context.textTheme;
    final widget = [
      palette.name.text(style: textTheme.titleLarge),
      buildColors(context),
      OverflowBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          if (actions != null) buildActions(actions).wrap(spacing: 4),
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

  List<Widget> buildActions(PaletteActions actions) {
    final all = <Widget>[];
    if (isSelected) {
      all.add(FilledButton.icon(
        icon: const Icon(Icons.check),
        onPressed: null,
        label: "Used".text(),
      ));
    } else {
      all.add(FilledButton(
        onPressed: () {
          actions.use();
        },
        child: "Use".text(),
      ));
    }
    final edit = actions.edit;
    if (edit != null) {
      all.add(OutlinedButton(
        onPressed: () {
          edit.call();
        },
        child: "Edit".text(),
      ));
    }
    return all;
  }

  Widget buildColors(BuildContext context) {
    return palette.colors.map((c) => buildColor(context, c)).toList().wrap();
  }

  Widget buildColor(BuildContext context, Color2Mode colors) {
    return FilledCard(
      color: colors.byTheme(context.theme),
      child: const SizedBox(
        width: 32,
        height: 32,
      ),
    );
  }
}

class TimetablePaletteEditor extends StatefulWidget {
  final TimetablePalette palette;

  const TimetablePaletteEditor({
    super.key,
    required this.palette,
  });

  @override
  State<TimetablePaletteEditor> createState() => _TimetablePaletteEditorState();
}

class _TimetablePaletteEditorState extends State<TimetablePaletteEditor> {
  late final $name = TextEditingController(text: widget.palette.name);
  late final $isLightMode = ValueNotifier(true);

  @override
  void dispose() {
    $name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: "Palette".text(),
            actions: [
              $isLightMode >>
                  (ctx, value) => SegmentedButton<bool>(
                        segments: [
                          ButtonSegment<bool>(
                            value: true,
                            label: "Light".text(),
                            icon: const Icon(Icons.light_mode),
                          ),
                          ButtonSegment<bool>(
                            value: false,
                            label: "Dark".text(),
                            icon: const Icon(Icons.dark_mode),
                          ),
                        ],
                        selected: <bool>{value},
                        onSelectionChanged: (newSelection) async {
                          $isLightMode.value = newSelection.first;
                          await HapticFeedback.selectionClick();
                        },
                      ),
            ],
          ),
          SliverList.list(children: [
            buildName(),
          ]),
          const SliverToBoxAdapter(
            child: Divider(),
          ),
          $isLightMode >>
              (ctx, isLightMode) => SliverList.builder(
                    itemCount: palette.colors.length,
                    itemBuilder: (ctx, i) => buildColors(palette.colors[i], isLightMode: isLightMode),
                  ),
        ],
      ),
    );
  }

  Widget buildName() {
    return ListTile(
      isThreeLine: true,
      leading: const Icon(Icons.drive_file_rename_outline),
      title: "Name".text(),
      subtitle: TextField(
        controller: $name,
        decoration: InputDecoration(
          hintText: "Please enter name",
        ),
      ),
    );
  }

  Widget buildColors(
    Color2Mode colors, {
    required bool isLightMode,
  }) {
    final color = isLightMode ? colors.light : colors.dark;
    return ListTile(
      title: "0x${color.hex}".text(),
      trailing: FilledCard(
        color: color,
        child: const SizedBox(width: 32, height: 32),
      ),
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
  context.showSnackBar("Timetable palette was added from QR code".text());
  context.push("/timetable/p13n");
}
