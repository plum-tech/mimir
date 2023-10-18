import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/timetable/platte.dart';

import '../entity/platte.dart';
import '../i18n.dart';

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
  late final $brightness = ValueNotifier(context.theme.brightness);
  late var colors = widget.palette.colors;

  @override
  void dispose() {
    $name.dispose();
    $brightness.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: $brightness >> (ctx, value) => buildBrightnessSwitch(value),
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
            const Divider(),
          ]),
          $brightness >>
              (ctx, brightness) {
                if (isCupertino) {
                  return SliverList.builder(
                    itemCount: colors.length,
                    itemBuilder: buildColorTile,
                  );
                }
                return SliverList.separated(
                  itemCount: colors.length,
                  itemBuilder: buildColorTile,
                  separatorBuilder: (ctx, i) => const Divider(
                    height: 4,
                    indent: 12,
                    endIndent: 12,
                  ),
                );
              },
          SliverList.list(children: [
            if (colors.isNotEmpty)
              const Divider(
                indent: 12,
                endIndent: 12,
              ),
            ListTile(
              leading: const Icon(Icons.add),
              title: i18n.p13n.palette.addColor.text(),
              onTap: () {
                setState(() {
                  colors.add((light: Colors.white30, dark: Colors.black12));
                });
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget buildBrightnessSwitch(Brightness brightness) {
    return SegmentedButton<Brightness>(
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

  Widget buildColorTile(BuildContext ctx, int index) {
    final brightness = $brightness.value;
    final current = colors[index];
    final color = current.byBrightness(brightness);
    if (!isCupertino) {
      return PaletteColorTile(
        color: color,
        onDelete: () {
          setState(() {
            colors.removeAt(index);
          });
        },
        onEdit: () async {
          await changeColor(ctx, index, color);
        },
      );
    }
    return SwipeActionCell(
      key: ObjectKey(current),

      /// this key is necessary
      trailingActions: <SwipeAction>[
        SwipeAction(
          title: i18n.delete,
          style: context.textTheme.titleSmall ?? const TextStyle(),
          performsFirstActionWithFullSwipe: true,
          onTap: (CompletionHandler handler) async {
            await handler(true);
            setState(() {
              colors.removeAt(index);
            });
          },
          color: Colors.red,
        ),
      ],
      child: PaletteColorTile(
        color: color,
        onEdit: () async {
          await changeColor(ctx, index, color);
        },
      ),
    );
  }

  Future<void> changeColor(BuildContext ctx, int index, Color old) async {
    final newColor = await showColorPickerDialog(
      ctx,
      old,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: true,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
    );
    if (newColor != old) {
      await HapticFeedback.mediumImpact();
      final brightness = $brightness.value;
      setState(() {
        if (brightness == Brightness.light) {
          colors[index] = (light: newColor, dark: colors[index].dark);
        } else {
          colors[index] = (light: colors[index].light, dark: newColor);
        }
      });
    }
  }

  Widget buildName() {
    return ListTile(
      isThreeLine: true,
      leading: const Icon(Icons.drive_file_rename_outline),
      title: i18n.p13n.palette.name.text(),
      subtitle: TextField(
        controller: $name,
        decoration: InputDecoration(
          hintText: i18n.p13n.palette.namePlaceholder,
        ),
      ),
    );
  }
}

class PaletteColorTile extends StatelessWidget {
  final Color color;
  final void Function()? onDelete;
  final void Function()? onEdit;

  const PaletteColorTile({
    super.key,
    required this.color,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final onDelete = this.onDelete;
    return ListTile(
      isThreeLine: true,
      visualDensity: VisualDensity.compact,
      title: "#${color.hexAlpha}".text(),
      subtitle: OutlinedCard(
        margin: EdgeInsets.zero,
        child: buildColorBar(),
      ),
      trailing: onDelete == null
          ? null
          : IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.delete),
              onPressed: () {
                onDelete.call();
              },
            ),
    );
  }

  Widget buildColorBar() {
    final onEdit = this.onEdit;
    return TweenAnimationBuilder(
      tween: ColorTween(begin: color, end: color),
      duration: const Duration(milliseconds: 300),
      builder: (ctx, value, child) => FilledCard(
        color: value,
        clip: Clip.hardEdge,
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onEdit == null
              ? null
              : () {
                  onEdit.call();
                },
          child: const SizedBox(height: 35),
        ),
      ),
    );
  }
}
