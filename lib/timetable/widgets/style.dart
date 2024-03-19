import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/entity/background.dart';
import 'package:sit/timetable/entity/platte.dart';
import 'package:sit/timetable/platte.dart';

import '../entity/cell_style.dart';
import '../init.dart';

part "style.g.dart";

@CopyWith(skipFields: true)
class TimetableStyleData {
  final TimetablePalette platte;
  final CourseCellStyle cellStyle;
  final BackgroundImage background;

  const TimetableStyleData({
    this.platte = BuiltinTimetablePalettes.classic,
    this.cellStyle = const CourseCellStyle(),
    this.background = const BackgroundImage.disabled(),
  });

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) {
    return other is TimetableStyleData &&
        runtimeType == other.runtimeType &&
        platte == other.platte &&
        background == other.background &&
        cellStyle == other.cellStyle;
  }
}

class TimetableStyle extends InheritedWidget {
  final TimetableStyleData data;

  const TimetableStyle({
    super.key,
    required this.data,
    required super.child,
  });

  static TimetableStyleData of(BuildContext context) {
    final TimetableStyle? result = context.dependOnInheritedWidgetOfExactType<TimetableStyle>();
    assert(result != null, 'No TimetableStyle found in context');
    return result!.data;
  }

  static TimetableStyleData? maybeOf(BuildContext context) {
    final TimetableStyle? result = context.dependOnInheritedWidgetOfExactType<TimetableStyle>();
    return result?.data;
  }

  @override
  bool updateShouldNotify(TimetableStyle oldWidget) {
    return data != oldWidget.data;
  }
}

class TimetableStyleProv extends StatefulWidget {
  final Widget? child;
  final TimetablePalette? palette;
  final CourseCellStyle? cellStyle;
  final BackgroundImage? background;

  final Widget Function(BuildContext context, TimetableStyleData style)? builder;

  const TimetableStyleProv({
    super.key,
    this.child,
    this.builder,
    this.palette,
    this.cellStyle,
    this.background,
  }) : assert(builder != null || child != null, "TimetableStyleProv should have at least one child.");

  @override
  TimetableStyleProvState createState() => TimetableStyleProvState();
}

class TimetableStyleProvState extends State<TimetableStyleProv> {
  final $palette = TimetableInit.storage.palette.$selected;
  final $cellStyle = Settings.timetable.listenCellStyle();
  final $background = Settings.timetable.listenBackgroundImage();
  var palette = TimetableInit.storage.palette.selectedRow ?? BuiltinTimetablePalettes.classic;
  var cellStyle = Settings.timetable.cellStyle ?? const CourseCellStyle();
  var background = Settings.timetable.backgroundImage ?? const BackgroundImage.disabled();

  @override
  void initState() {
    super.initState();
    $palette.addListener(refreshPalette);
    $cellStyle.addListener(refreshCellStyle);
    $background.addListener(refreshBackground);
  }

  @override
  void dispose() {
    $palette.removeListener(refreshPalette);
    $cellStyle.removeListener(refreshCellStyle);
    $background.removeListener(refreshBackground);
    super.dispose();
  }

  void refreshPalette() {
    setState(() {
      palette = TimetableInit.storage.palette.selectedRow ?? BuiltinTimetablePalettes.classic;
    });
  }

  void refreshCellStyle() {
    setState(() {
      cellStyle = Settings.timetable.cellStyle ?? const CourseCellStyle();
    });
  }

  void refreshBackground() {
    setState(() {
      background = Settings.timetable.backgroundImage ?? const BackgroundImage.disabled();
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = TimetableStyleData(
      platte: palette,
      cellStyle: cellStyle,
      background: background,
    ).copyWith(
      platte: widget.palette,
      cellStyle: widget.cellStyle,
      background: widget.background,
    );
    return TimetableStyle(
      data: data,
      child: buildChild(data),
    );
  }

  Widget buildChild(TimetableStyleData data) {
    final child = widget.child;
    if (child != null) {
      return child;
    }
    final builder = widget.builder;
    if (builder != null) {
      return Builder(builder: (ctx) => builder(ctx, data));
    }
    return const SizedBox();
  }
}
