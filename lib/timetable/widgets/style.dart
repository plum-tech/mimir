import 'package:flutter/material.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/entity/background.dart';
import 'package:sit/timetable/entity/platte.dart';
import 'package:sit/timetable/platte.dart';

import '../init.dart';

class CourseCellStyle {
  final bool showTeachers;
  final bool grayOutTakenLessons;
  final bool harmonizeWithThemeColor;
  final double alpha;

  const CourseCellStyle({
    this.showTeachers = true,
    this.grayOutTakenLessons = false,
    this.harmonizeWithThemeColor = true,
    this.alpha = 1.0,
  });

  CourseCellStyle copyWith({
    bool? showTeachers,
    bool? grayOutTakenLessons,
    bool? harmonizeWithThemeColor,
    double? alpha,
  }) {
    return CourseCellStyle(
      showTeachers: showTeachers ?? this.showTeachers,
      grayOutTakenLessons: grayOutTakenLessons ?? this.grayOutTakenLessons,
      harmonizeWithThemeColor: harmonizeWithThemeColor ?? this.harmonizeWithThemeColor,
      alpha: alpha ?? this.alpha,
    );
  }
}

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

  TimetableStyleData copyWith({
    TimetablePalette? platte,
    CourseCellStyle? cell,
    BackgroundImage? background,
  }) {
    return TimetableStyleData(
      platte: platte ?? this.platte,
      cellStyle: cell ?? this.cellStyle,
      background: background ?? this.background,
    );
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
  final $cellStyle = Settings.timetable.cell.listenStyle();
  final $background = Settings.timetable.listenBackgroundImage();
  var palette = TimetableInit.storage.palette.selectedRow ?? BuiltinTimetablePalettes.classic;
  var cellStyle = Settings.timetable.cell.cellStyle;
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
      cellStyle = Settings.timetable.cell.cellStyle;
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
      cell: widget.cellStyle,
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
