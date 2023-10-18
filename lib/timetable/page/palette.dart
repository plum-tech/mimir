import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/timetable/platte.dart';

import '../entity/platte.dart';
import '../i18n.dart';

class TimetablePaletteEditor extends StatefulWidget {
  final TimetablePalette palette;
  final Brightness initialBrightness;

  const TimetablePaletteEditor({
    super.key,
    required this.palette,
    required this.initialBrightness,
  });

  @override
  State<TimetablePaletteEditor> createState() => _TimetablePaletteEditorState();
}

class _TimetablePaletteEditorState extends State<TimetablePaletteEditor> {
  late final $name = TextEditingController(text: widget.palette.name);
  late final $brightness = ValueNotifier(widget.initialBrightness);
  late var colors = widget.palette.colors;

  @override
  void dispose() {
    $name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: $brightness >>
                (ctx, value) => SegmentedButton<Brightness>(
                      segments: [
                        ButtonSegment<Brightness>(
                          value: Brightness.light,
                          label: "Light".text(),
                          icon: const Icon(Icons.light_mode),
                        ),
                        ButtonSegment<Brightness>(
                          value: Brightness.dark,
                          label: "Dark".text(),
                          icon: const Icon(Icons.dark_mode),
                        ),
                      ],
                      selected: <Brightness>{value},
                      onSelectionChanged: (newSelection) async {
                        $brightness.value = newSelection.first;
                        await HapticFeedback.selectionClick();
                      },
                    ),
            actions: [
              CupertinoButton(
                child: i18n.save.text(),
                onPressed: () {
                  context.navigator.pop(TimetablePalette(
                    name: $name.text,
                    colors: colors,
                  ));
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
          $brightness >>
              (ctx, brightness) => SliverList.separated(
                    itemCount: colors.length,
                    itemBuilder: (ctx, i) {
                      final color = colors[i];
                      return PaletteColorCard(
                        colors: colors[i],
                        brightness: brightness,
                        number: i + 1,
                        onDelete: () {
                          setState(() {
                            colors.removeAt(i);
                          });
                        },
                        onEdit: () async {
                          final current = color.byBrightness(brightness);
                          final newColor = await showColorPickerDialog(
                            context,
                            current,
                            pickersEnabled: const <ColorPickerType, bool>{
                              ColorPickerType.both: true,
                              ColorPickerType.primary: false,
                              ColorPickerType.accent: false,
                              ColorPickerType.custom: true,
                              ColorPickerType.wheel: true,
                            },
                          );
                          if (newColor != current) {
                            await HapticFeedback.mediumImpact();
                            setState(() {
                              if (brightness == Brightness.light) {
                                colors[i] = (light: newColor, dark: color.dark);
                              } else {
                                colors[i] = (light: color.light, dark: newColor);
                              }
                            });
                          }
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Divider(),
                      );
                    },
                  ),
          const SliverToBoxAdapter(
            child: Divider(),
          ),
          SliverToBoxAdapter(
            child: ListTile(
              leading: const Icon(Icons.add),
              title: "Add a pair of color".text(),
              onTap: () {
                setState(() {
                  colors.add((light: Colors.white30, dark: Colors.black12));
                });
              },
            ),
          )
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
}

class PaletteColorCard extends StatelessWidget {
  final Color2Mode colors;
  final Brightness brightness;
  final int number;
  final void Function()? onDelete;
  final void Function()? onEdit;

  const PaletteColorCard({
    super.key,
    required this.colors,
    required this.brightness,
    required this.number,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final onDelete = this.onDelete;
    final onEdit = this.onEdit;
    final color = colors.byBrightness(brightness);
    return ListTile(
      isThreeLine: true,
      visualDensity: VisualDensity.compact,
      title: TweenAnimationBuilder(
        tween: ColorTween(begin: color, end: color),
        duration: const Duration(milliseconds: 300),
        builder: (ctx, value, child) => FilledCard(
          color: value,
          clip: Clip.hardEdge,
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: () {
              onEdit?.call();
            },
            child: SizedBox(
              height: 35,
              child: "#$number".text(style: context.textTheme.titleLarge).center(),
            ),
          ),
        ),
      ),
      subtitle: "#${color.hexAlpha}".text(),
      trailing: IconButton(
        visualDensity: VisualDensity.compact,
        icon: const Icon(Icons.delete),
        onPressed: () {
          onDelete?.call();
        },
      ),
    );
  }
}
