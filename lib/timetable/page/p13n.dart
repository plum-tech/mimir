import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/entry_card.dart';
import 'package:sit/design/widgets/fab.dart';
import 'package:sit/qrcode/page.dart';
import 'package:sit/qrcode/protocol.dart';
import 'package:sit/timetable/entity/platte.dart';
import 'package:sit/timetable/init.dart';
import 'package:sit/timetable/platte.dart';

import 'cell_style.dart';
import 'palette.dart';
import '../i18n.dart';

// TODO: i18n
class TimetableP13nPage extends StatefulWidget {
  final bool editCellStyle;

  const TimetableP13nPage({
    super.key,
    required this.editCellStyle,
  });

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
    final editCellStyle = widget.editCellStyle;
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            floating: true,
            title: "Personalization".text(),
          ),
          if (editCellStyle)
            SliverList.list(children: const [
              TimetableEditCellStyleTile(),
              Divider(),
            ]),
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
        label: "Palette".text(),
        icon: const Icon(Icons.add),
        onPressed: () {
          TimetableInit.storage.palette.add(TimetablePalette(name: "New palette", colors: []));
        },
      ),
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
        if (palette == null) return const SizedBox();
        return buildPaletteCard(id, palette, selected: selectedId == id).padH(12);
      },
    );
  }

  Widget buildPaletteCard(
    int id,
    TimetablePalette palette, {
    required bool selected,
  }) {
    final theme = context.theme;
    return EntryCard(
      selected: selected,
      selectAction: EntrySelectAction(
        useLabel: "Use",
        usedLabel: "Used",
        action: palette.colors.isEmpty
            ? null
            : () async {
                TimetableInit.storage.palette.selectedId = id;
              },
      ),
      deleteAction: EntryDeleteAction(
        label: i18n.delete,
        action: () async {
          await onDelete(id);
        },
      ),
      actions: [
        if (palette is! BuiltinTimetablePalette)
          EntryAction(
            main: true,
            label: "Edit",
            cupertinoIcon: CupertinoIcons.pencil,
            action: () async {
              final newPalette = await context.show$Sheet$<TimetablePalette>(
                dismissible: false,
                (context) => TimetablePaletteEditor(
                  palette: palette.clone(),
                  initialBrightness: context.theme.brightness,
                ),
              );
              if (newPalette == null) return;
              TimetableInit.storage.palette[id] = newPalette;
            },
          ),
        EntryAction(
          label: "Copy",
          icon: Icons.output_outlined,
          cupertinoIcon: CupertinoIcons.doc_on_clipboard,
          action: () async {
            final duplicate = palette.clone(getNewName: (old) => "$old-Copy");
            TimetableInit.storage.palette.add(duplicate);
          },
        ),
        EntryAction(
            label: "Share QR code",
            icon: Icons.qr_code,
            cupertinoIcon: CupertinoIcons.qrcode,
            action: () async {
              final qrCodeData = const TimetablePaletteDeepLink().encode(palette);
              await context.show$Sheet$(
                (context) => QrCodePage(
                  title: "Timetable Palette".text(),
                  data: qrCodeData.toString(),
                ),
              );
            }),
      ],
      children: [
        palette.name.text(style: theme.textTheme.titleLarge),
        palette.colors
            .map((c) => FilledCard(
                  color: c.byTheme(theme),
                  child: const SizedBox(
                    width: 32,
                    height: 32,
                  ),
                ))
            .toList()
            .wrap(),
      ],
    );
  }

  Future<void> onDelete(int id) async {
    final confirm = await context.showRequest(
      title: "Delete?",
      desc: "Delete",
      yes: i18n.delete,
      no: i18n.cancel,
      highlight: true,
    );
    if (confirm == true) {
      TimetableInit.storage.palette.delete(id);
    }
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
