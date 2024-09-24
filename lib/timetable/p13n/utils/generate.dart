import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mimir/design/adaptive/foundation.dart';
import 'package:mimir/design/entity/dual_color.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/timetable/init.dart';
import 'package:mimir/timetable/p13n/entity/palette.dart';
import 'package:palette_generator/palette_generator.dart';
import '../../i18n.dart';
import '../page/palette_editor.dart';

Future<TimetablePalette> generatePaletteFromImage(
  ImageProvider img, {
  int maxColorCount = 12,
}) async {
  final generator = await PaletteGenerator.fromImageProvider(
    img,
    maximumColorCount: maxColorCount,
    targets: PaletteTarget.baseTargets,
  );
  final palette = TimetablePalette.create(
    name: i18n.p13n.palette.newPaletteName,
    author: Settings.lastSignature ?? "",
    colors: generator.paletteColors.map((pc) {
      final estimatedBrightness = ThemeData.estimateBrightnessForColor(pc.color);
      return DualColor(
        light: ColorEntry(
          pc.color,
          inverseText: estimatedBrightness != Brightness.light,
        ),
        dark: ColorEntry(
          pc.color,
          inverseText: estimatedBrightness != Brightness.dark,
        ),
      );
    }).toList(),
  );
  return palette;
}

Future<void> addPaletteFromImageByGenerator(
  BuildContext context,
  ImageProvider img, {
  int maxColorCount = 12,
}) async {
  final palette = await generatePaletteFromImage(
    img,
    maxColorCount: maxColorCount,
  );
  if (!context.mounted) return;
  final newPalette = await context.showSheet<TimetablePalette>(
    (ctx) => TimetablePaletteEditorPage(palette: palette),
    dismissible: false,
  );
  if (newPalette == null) return;
  TimetableInit.storage.palette.add(newPalette);
  await HapticFeedback.mediumImpact();
  if (!context.mounted) return;
}
