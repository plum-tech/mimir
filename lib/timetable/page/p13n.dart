import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/card.dart';
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
        return buildPaletteCard(id, palette, isSelected: selectedId == id).padH(12);
      },
    );
  }

  Widget buildPaletteCard(
    int id,
    TimetablePalette palette, {
    required bool isSelected,
  }) {
    final PaletteActions actions = (
      use: () {
        TimetableInit.storage.palette.selectedId = id;
      },
      edit: palette is BuiltinTimetablePalette
          ? null
          : () async {
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
    );
    if (!isCupertino) {
      return PaletteCard(
        palette: palette,
        isSelected: isSelected,
        moreAction: buildActionPopup(id, palette, isSelected),
        actions: actions,
      );
    }
    return Builder(
      builder: (context) => CupertinoContextMenu.builder(
        enableHapticFeedback: true,
        actions: [
          if (!isSelected)
            CupertinoContextMenuAction(
              trailingIcon: CupertinoIcons.check_mark,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Future.delayed(const Duration(milliseconds: 336));
                actions.use();
              },
              child: "Use".text(),
            ),
          if (actions.edit != null)
            CupertinoContextMenuAction(
              trailingIcon: CupertinoIcons.pencil,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                actions.edit?.call();
              },
              child: "Edit".text(),
            ),
          CupertinoContextMenuAction(
            trailingIcon: CupertinoIcons.doc_on_clipboard,
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              copyPalette(palette);
            },
            child: "Copy".text(),
          ),
          CupertinoContextMenuAction(
            trailingIcon: CupertinoIcons.qrcode,
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await shareQrCode(palette);
            },
            child: "Share QR code".text(),
          ),
          if (palette is! BuiltinTimetablePalette)
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
        builder: (context, animation) {
          return PaletteCard(
            palette: palette,
            isSelected: isSelected,
            moreAction: animation.value > 0
                ? null
                : IconButton(
                    onPressed: isSelected ? null : actions.use,
                    icon: isSelected
                        ? Icon(CupertinoIcons.check_mark, color: context.colorScheme.primary)
                        : const Icon(CupertinoIcons.square)),
          );
        },
      ),
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
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.qr_code),
            title: "Share QR code".text(),
            onTap: () async {
              ctx.pop();
              await shareQrCode(palette);
            },
          ),
        ),
        if (palette is! BuiltinTimetablePalette)
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

  Future<void> shareQrCode(TimetablePalette palette) async {
    final qrCodeData = const TimetablePaletteDeepLink().encode(palette);
    await context.show$Sheet$(
      (context) => QrCodePage(
        title: "Timetable Palette".text(),
        data: qrCodeData.toString(),
      ),
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

  void copyPalette(TimetablePalette palette) {
    final duplicate = palette.clone(getNewName: (old) => "$old-Copy");
    TimetableInit.storage.palette.add(duplicate);
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
      if (moreAction != null || actions != null)
        OverflowBar(
          alignment: moreAction != null
              ? actions != null
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end
              : MainAxisAlignment.spaceBetween,
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
        onPressed: palette.colors.isEmpty
            ? null
            : () {
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
