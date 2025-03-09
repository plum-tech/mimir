import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/design/entity/dual_color.dart';
import 'package:mimir/l10n/extension.dart';

import '../../i18n.dart';

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
