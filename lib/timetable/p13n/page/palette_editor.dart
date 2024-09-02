import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart' hide isCupertino;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/settings/page/index.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/design/adaptive/swipe.dart';
import 'package:mimir/design/entity/dual_color.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/timetable/page/preview.dart';
import 'package:mimir/utils/save.dart';

import '../entity/palette.dart';
import '../../i18n.dart';
import '../../init.dart';

/// [TimetablePalette] object will be popped.
class TimetablePaletteEditorPage extends ConsumerStatefulWidget {
  final TimetablePalette palette;

  const TimetablePaletteEditorPage({
    super.key,
    required this.palette,
  });

  @override
  ConsumerState<TimetablePaletteEditorPage> createState() => _TimetablePaletteEditorPageState();
}

class _TimetablePaletteEditorPageState extends ConsumerState<TimetablePaletteEditorPage> {
  late final $name = TextEditingController(text: widget.palette.name);
  late final $author = TextEditingController(text: widget.palette.author);
  late var colors = widget.palette.colors;
  var anyChanged = false;

  void markChanged() => anyChanged |= true;

  @override
  void initState() {
    super.initState();
    $name.addListener(() {
      if ($name.text != widget.palette.name) {
        setState(() => markChanged());
      }
    });
    $author.addListener(() {
      if ($author.text != widget.palette.author) {
        setState(() => markChanged());
      }
    });
  }

  @override
  void dispose() {
    $name.dispose();
    $author.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timetable = ref.watch(TimetableInit.storage.timetable.$selectedRow);
    return PromptSaveBeforeQuitScope(
      changed: anyChanged,
      onSave: onSave,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: i18n.p13n.palette.title.text(),
              actions: [
                if (timetable != null && colors.isNotEmpty)
                  PlatformTextButton(
                    child: i18n.preview.text(),
                    onPressed: () async {
                      await previewTimetable(
                        context,
                        timetable: timetable,
                        palette: buildPalette(),
                      );
                    },
                  ),
                PlatformTextButton(
                  onPressed: onSave,
                  child: i18n.save.text(),
                ),
              ],
            ),
            SliverList.list(children: [
              buildName(),
              buildAuthor(),
            ]),
            const Divider().sliver(),
            FilledButton.tonal(
              child: const LightDarkColorsHeaderTitle(),
              onPressed: () {
                setState(() {
                  colors.insert(0, TimetablePalette.defaultColor);
                });
                markChanged();
              },
            ).padAll(8).sliver(),
            SliverList.builder(
              itemCount: colors.length,
              itemBuilder: buildColorTile,
            ),
            SliverList.list(children: [
              const Divider(),
              ListTile(
                title: i18n.p13n.palette.appSettings.text(),
              ),
              const ThemeModeTile(),
            ]),
          ],
        ),
      ),
    );
  }

  void onSave() {
    final palette = buildPalette();
    context.navigator.pop(palette);
  }

  TimetablePalette buildPalette() {
    return TimetablePalette(
      name: $name.text,
      author: $author.text,
      colors: colors,
      lastModified: DateTime.now(),
    );
  }

  Widget buildColorTile(BuildContext ctx, int index) {
    final current = colors[index];
    return WithSwipeAction(
      childKey: ObjectKey(current),
      right: SwipeAction.delete(
        icon: context.icons.delete,
        action: () async {
          setState(() {
            colors.removeAt(index);
          });
          markChanged();
        },
      ),
      child: PaletteColorTile(
        colors: current,
        onEdit: (brightness, newColor) async {
          await HapticFeedback.mediumImpact();
          setState(() {
            if (brightness == Brightness.light) {
              colors[index] = DualColor(light: newColor, dark: colors[index].dark);
            } else {
              colors[index] = DualColor(light: colors[index].light, dark: newColor);
            }
          });
          markChanged();
        },
      ).padH(8),
    );
  }

  Widget buildName() {
    return ListTile(
      isThreeLine: true,
      title: i18n.p13n.palette.name.text(),
      subtitle: TextField(
        controller: $name,
        decoration: InputDecoration(
          hintText: i18n.p13n.palette.namePlaceholder,
        ),
      ),
    );
  }

  Widget buildAuthor() {
    return ListTile(
      isThreeLine: true,
      title: i18n.p13n.palette.author.text(),
      subtitle: TextField(
        controller: $author,
        decoration: InputDecoration(
          hintText: i18n.p13n.palette.authorPlaceholder,
        ),
      ),
    );
  }
}

class LightDarkColorsHeaderTitle extends StatelessWidget {
  const LightDarkColorsHeaderTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.bodyLarge?.apply(color: DefaultTextStyle.of(context).style.color);
    return [
      [
        const Icon(Icons.light_mode),
        const SizedBox(width: 8),
        Brightness.light.l10n().text(style: style),
      ].row(mas: MainAxisSize.min),
      [
        const Icon(Icons.text_format),
        "Text".text(style: style),
      ].row(mas: MainAxisSize.min),
      [
        Brightness.dark.l10n().text(style: style),
        const SizedBox(width: 8),
        const Icon(Icons.dark_mode),
      ].row(mas: MainAxisSize.min),
    ].row(maa: MainAxisAlignment.spaceBetween).padSymmetric(h: 12, v: 12);
  }
}

class PaletteColorTile extends StatelessWidget {
  final DualColor colors;
  final void Function(Brightness brightness, ColorEntry newColor)? onEdit;

  const PaletteColorTile({
    super.key,
    required this.colors,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final DualColor(:light, :dark) = colors;
    return [
      SingleColorSpec(
        color: light,
        left: true,
        brightness: Brightness.light,
        onEdit: onEdit,
      ).expanded(),
      SingleColorSpec(
        color: dark,
        left: false,
        brightness: Brightness.dark,
        onEdit: onEdit,
      ).expanded(),
    ].row(maa: MainAxisAlignment.spaceBetween);
  }
}

class SingleColorSpec extends StatelessWidget {
  final ColorEntry color;
  final bool left;
  final Brightness brightness;
  final void Function(Brightness brightness, ColorEntry newColor)? onEdit;

  const SingleColorSpec({
    super.key,
    required this.color,
    this.onEdit,
    required this.brightness,
    required this.left,
  });

  @override
  Widget build(BuildContext context) {
    final onEdit = this.onEdit;
    return ListTile(
      isThreeLine: true,
      visualDensity: VisualDensity.compact,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      title: "#${color.color.hexAlpha}".text(textAlign: left ? TextAlign.start : TextAlign.right),
      subtitle: () {
        final widgets = [
          PaletteColorBar(
            color: color,
            brightness: brightness,
            onEdit: onEdit,
          ).expanded(),
          if (onEdit != null)
            IconButton.filledTonal(
              icon: Icon(resolveTextBrightness() ? context.icons.sun : context.icons.moon),
              padding: EdgeInsets.zero,
              onPressed: () {
                onEdit(brightness, color.copyWith(inverseText: !color.inverseText));
              },
            ),
        ];
        return (left ? widgets : widgets.reversed.toList()).row();
      }(),
    );
  }

  bool resolveTextBrightness() {
    var light = brightness == Brightness.light;
    if (color.inverseText) {
      light = !light;
    }
    return light;
  }
}

class PaletteColorBar extends StatelessWidget {
  final ColorEntry color;
  final Brightness brightness;
  final void Function(Brightness brightness, ColorEntry newColor)? onEdit;

  const PaletteColorBar({
    super.key,
    required this.color,
    required this.brightness,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final onEdit = this.onEdit;
    final textColor =
        (context.brightness == brightness ? color : color.copyWith(inverseText: !color.inverseText)).textColor(context);
    return Card.filled(
      color: color.color,
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onEdit == null
            ? null
            : () async {
                final old = color;
                final newColor = await _selectColor(context, old.color);
                if (newColor != old.color) {
                  onEdit.call(brightness, old.copyWith(color: newColor));
                }
              },
        onLongPress: () async {
          await Clipboard.setData(ClipboardData(text: "#${color.color.hexAlpha}"));
          if (!context.mounted) return;
          context.showSnackBar(content: i18n.copyTipOf(i18n.p13n.palette.color).text());
        },
        child: SizedBox(
          height: 35,
          child: brightness
              .l10n()
              .text(
                style: context.textTheme.bodyLarge?.copyWith(color: textColor),
              )
              .center(),
        ),
      ),
    );
  }
}

Future<Color> _selectColor(BuildContext context, Color old) async {
  return await showColorPickerDialog(
    context,
    old,
    enableOpacity: true,
    enableShadesSelection: true,
    enableTonalPalette: true,
    showColorCode: true,
    pickersEnabled: const <ColorPickerType, bool>{
      ColorPickerType.both: true,
      ColorPickerType.primary: false,
      ColorPickerType.accent: false,
      ColorPickerType.custom: true,
      ColorPickerType.wheel: true,
    },
  );
}
