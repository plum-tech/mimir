import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/timetable/entity/platte.dart';
import 'package:sit/timetable/init.dart';
import 'package:sit/timetable/platte.dart';

class TimetableP13nPage extends StatefulWidget {
  const TimetableP13nPage({super.key});

  @override
  State<TimetableP13nPage> createState() => _TimetableP13nPageState();
}

class _TimetableP13nPageState extends State<TimetableP13nPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
          buildPaletteList(),
        ],
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
    final selectedId = TimetableInit.storage.palette.selectedId ?? BuiltinTimetablePalettes.newUI.id;
    return SliverList.builder(
      itemCount: allIds.length,
      itemBuilder: (ctx, i) {
        final id = allIds[i];
        final palette = TimetableInit.storage.palette[id];
        if (palette == null) return const SizedBox();
        return PaletteCard(
          palette: palette,
          selectable: (
            isSelected: selectedId == id,
            onSelect: () {
              TimetableInit.storage.palette.selectedId = id;
            },
          ),
        );
      },
    );
  }

  Widget buildEditCellStyleTile() {
    return ListTile(
      leading: const Icon(Icons.style_outlined),
      title: "Edit cell style".text(),
      subtitle: "How does course cell look like".text(),
      trailing: const Icon(Icons.open_in_new),
      onTap: () async {
        await context.show$Sheet$((ctx) => TimetableCellStyleEditor());
      },
    );
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
        ],
      ),
    );
  }
}

class PaletteCard extends StatelessWidget {
  final TimetablePalette palette;
  final ({bool isSelected, void Function() onSelect})? selectable;
  final ({void Function() onEdit})? editable;

  const PaletteCard({
    super.key,
    required this.palette,
    this.selectable,
    this.editable,
  });

  @override
  Widget build(BuildContext context) {
    final selectable = this.selectable;
    final editable = this.editable;
    final widget = ListTile(
      title: palette.name.text(),
      trailing: [
        if (editable != null)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: editable.onEdit,
          ),
        if (selectable != null)
          IconButton(
            icon: selectable.isSelected
                ? const Icon(Icons.check_box_outlined)
                : const Icon(Icons.check_box_outline_blank),
            onPressed: selectable.isSelected
                ? null
                : () {
                    selectable.onSelect();
                  },
          ),
      ].row(mas: MainAxisSize.min),
    );
    return selectable?.isSelected == true
        ? widget.inFilledCard(
      clip: Clip.hardEdge,
    )
        : widget.inOutlinedCard(
      clip: Clip.hardEdge,
    );
  }

  Widget buildColor(Color2Mode colors) {
    return CustomPaint(
      painter: DiagonalTwoColorsPainter((colors.light, colors.dark)),
    );
  }
}

class DiagonalTwoColorsPainter extends CustomPainter {
  final (Color a, Color b) colors;

  DiagonalTwoColorsPainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    paint.color = colors.$1;
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height)
        ..lineTo(size.width, 0),
      paint,
    );

    paint.color = colors.$2;
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
