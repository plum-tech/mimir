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
    final selectedId = TimetableInit.storage.palette.selectedId ?? BuiltinTimetablePalettes.classic.id;
    return SliverList.builder(
      itemCount: allIds.length,
      itemBuilder: (ctx, i) {
        final id = allIds[i];
        final palette = TimetableInit.storage.palette[id];
        if (palette == null) return const SizedBox();
        return PaletteCard(
          palette: palette,
          isSelected: selectedId == id,
          actions: (
            use: () {
              TimetableInit.storage.palette.selectedId = id;
              setState(() {});
            },
            edit: () {}
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

typedef PaletteActions = ({void Function() use, void Function()? edit});

class PaletteCard extends StatelessWidget {
  final TimetablePalette palette;
  final bool isSelected;
  final PaletteActions? actions;

  const PaletteCard({
    super.key,
    required this.palette,
    required this.isSelected,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final actions = this.actions;
    final textTheme = context.textTheme;
    final widget = [
      palette.name.text(style: textTheme.titleLarge),
      if (actions != null)
        OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            [
              if (isSelected)
                FilledButton.icon(
                  icon: const Icon(Icons.check),
                  onPressed: null,
                  label: "Used".text(),
                )
              else
                FilledButton(
                  onPressed: () {
                    actions.use();
                  },
                  child: "Used".text(),
                ),
              if (actions.edit != null)
                OutlinedButton(
                  onPressed: () {
                    actions.edit!.call();
                  },
                  child: "Edit".text(),
                )
            ].wrap(spacing: 12),
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
