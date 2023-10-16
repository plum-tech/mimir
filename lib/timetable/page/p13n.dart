import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/fab.dart';
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
        await context.show$Sheet$((ctx) => TimetableCellStyleEditor());
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
            edit: palette is BuiltinTimetablePalette ? null : () {},
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
    return ListTile(
      leading: const Icon(Icons.person_pin),
      title: "Teachers".text(),
      subtitle: "Show teachers in cell".text(),
      trailing: Switch.adaptive(
        value: true,
        onChanged: (newV) {},
      ),
    );
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
      buildColors(context).padSymmetric(h: 4, v: 4),
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
