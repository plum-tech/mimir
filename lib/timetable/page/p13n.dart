import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/entry_card.dart';
import 'package:sit/qrcode/page.dart';
import 'package:sit/qrcode/protocol.dart';
import 'package:sit/timetable/entity/platte.dart';
import 'package:sit/timetable/init.dart';
import 'package:sit/timetable/platte.dart';

import '../i18n.dart';

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

  @override
  void initState() {
    super.initState();
    $paletteList.addListener(refresh);
    tabController = TabController(vsync: this, length: TimetableP13nTab.length);
    final selectedId = TimetableInit.storage.palette.selectedId;
    final forceTab = widget.tab;
    if (forceTab != null) {
      tabController.index = forceTab.clamp(TimetableP13nTab.custom, TimetableP13nTab.builtin);
    } else if (BuiltinTimetablePalettes.all.any((palette) => palette.id == selectedId)) {
      tabController.index = TimetableP13nTab.builtin;
    }
  }

  @override
  void dispose() {
    $paletteList.removeListener(refresh);
    tabController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: i18n.p13n.palette.fab.text(),
        icon: const Icon(Icons.add),
        onPressed: () {
          TimetableInit.storage.palette.add(TimetablePalette(
            name: i18n.p13n.palette.newPaletteName,
            author: "",
            colors: [],
          ));
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
            buildPaletteList(TimetableInit.storage.palette.idList ?? const []),
            buildPaletteList(BuiltinTimetablePalettes.all.map((e) => e.id).toList()),
          ],
        ),
      ),
    );
  }

  Widget buildPaletteList(List<int> idList) {
    final selectedId = TimetableInit.storage.palette.selectedId ?? BuiltinTimetablePalettes.classic.id;
    return ListView.builder(
      itemCount: idList.length,
      itemBuilder: (ctx, i) {
        final id = idList[i];
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
                extra: palette.copyWith(),
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
            final duplicate = palette.copyWith(
              name: i18n.p13n.palette.copyPaletteName(palette.name),
              // copy will ignore the original author
              author: "",
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
      children: [
        palette.name.text(style: theme.textTheme.titleLarge),
        if (palette.author.isNotEmpty)
          palette.author.text(
              style: const TextStyle(
            fontStyle: FontStyle.italic,
          )),
        palette.colors
            .map((c) => OutlinedCard(
                  margin: EdgeInsets.zero,
                  child: FilledCard(
                    margin: EdgeInsets.zero,
                    color: c.byTheme(theme),
                    child: const SizedBox(
                      width: 32,
                      height: 32,
                    ),
                  ),
                ))
            .toList()
            .wrap(spacing: 4, runSpacing: 4)
            .padV(4),
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
  context.push("/timetable/p13n?custom");
}
