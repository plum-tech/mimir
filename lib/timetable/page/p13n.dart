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
import '../i18n.dart';

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
            title: i18n.p13n.title.text(),
          ),
          if (editCellStyle)
            SliverList.list(children: const [
              TimetableEditCellStyleTile(),
              Divider(),
            ]),
          SliverToBoxAdapter(
            child: ListTile(
              leading: const Icon(Icons.color_lens_outlined),
              title: i18n.p13n.palette.headerTitle.text(),
              subtitle: i18n.p13n.palette.headerDesc.text(),
            ),
          ),
          buildPaletteList(),
          const SliverFillRemaining(),
        ],
      ),
      floatingActionButton: AutoHideFAB.extended(
        controller: scrollController,
        label: i18n.p13n.palette.fab.text(),
        icon: const Icon(Icons.add),
        onPressed: () {
          TimetableInit.storage.palette.add(TimetablePalette(
            name: i18n.p13n.palette.newPaletteName,
            colors: [],
          ));
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
        return buildPaletteCard(
          id,
          palette,
          selected: selectedId == id,
        ).padH(12);
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
      selectAction: (ctx) => EntrySelectAction(
        selectLabel: i18n.use,
        selectedLabel: i18n.used,
        action: palette.colors.isEmpty
            ? null
            : () async {
                TimetableInit.storage.palette.selectedId = id;
              },
      ),
      deleteAction: (ctx) => EntryDeleteAction(
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
      actions: (ctx) => [
        if (palette is! BuiltinTimetablePalette)
          EntryAction(
            main: true,
            label: i18n.edit,
            icon: Icons.edit,
            cupertinoIcon: CupertinoIcons.pencil,
            action: () async {
              final newPalette = await ctx.push<TimetablePalette>(
                "/timetable/p13n/palette/$id",
                extra: palette.clone(),
              );
              if (newPalette == null) return;
              TimetableInit.storage.palette[id] = newPalette;
            },
          ),
        EntryAction(
          label: i18n.copy,
          icon: Icons.copy,
          cupertinoIcon: CupertinoIcons.doc_on_clipboard,
          action: () async {
            final duplicate = palette.clone(getNewName: (old) => i18n.p13n.palette.copyPaletteName(old));
            TimetableInit.storage.palette.add(duplicate);
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
}

Future<void> onTimetablePaletteFromQrCode({
  required BuildContext context,
  required TimetablePalette palette,
}) async {
  TimetableInit.storage.palette.add(palette);
  await HapticFeedback.mediumImpact();
  if (!context.mounted) return;
  context.showSnackBar(i18n.p13n.palette.addFromQrCode.text());
  context.push("/timetable/p13n");
}
