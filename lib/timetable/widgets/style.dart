import 'package:flutter/material.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/entity/platte.dart';
import 'package:sit/timetable/platte.dart';
import 'package:rettulf/rettulf.dart';

import '../init.dart';

extension DesignExtension on BuildContext {
  ({Color bg, Color text}) makeTabHeaderTextBgColors(bool isSelected) {
    final Color text;
    final Color bg;
    if (isDarkMode) {
      if (isSelected) {
        bg = theme.secondaryHeaderColor;
      } else {
        bg = Colors.transparent;
      }
      text = Colors.white;
    } else {
      if (isSelected) {
        bg = theme.primaryColor;
        text = Colors.white;
      } else {
        bg = Colors.transparent;
        text = Colors.black;
      }
    }
    return (text: text, bg: bg);
  }
}

class CourseCellStyle {
  final bool showTeachers;
  final bool grayOutPassedLessons;
  final bool harmonizeWithThemeColor;

  const CourseCellStyle({
    required this.showTeachers,
    required this.grayOutPassedLessons,
    required this.harmonizeWithThemeColor,
  });

  CourseCellStyle copyWith({
    bool? showTeachers,
    bool? grayOutPassedLessons,
    bool? harmonizeWithThemeColor,
  }) {
    return CourseCellStyle(
      showTeachers: showTeachers ?? this.showTeachers,
      grayOutPassedLessons: grayOutPassedLessons ?? this.grayOutPassedLessons,
      harmonizeWithThemeColor: harmonizeWithThemeColor ?? this.harmonizeWithThemeColor,
    );
  }
}

class TimetableStyleData {
  final TimetablePalette platte;
  final CourseCellStyle cell;

  const TimetableStyleData({
    required this.platte,
    required this.cell,
  });

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) {
    return other is TimetableStyleData &&
        runtimeType == other.runtimeType &&
        platte == other.platte &&
        cell == other.cell;
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

  @override
  bool updateShouldNotify(TimetableStyle oldWidget) {
    return data != oldWidget.data;
  }
}

class TimetableStyleProv extends StatefulWidget {
  final Widget? child;
  final Widget Function(BuildContext context, TimetableStyleData style)? builder;

  const TimetableStyleProv({super.key, this.child, this.builder})
      : assert(builder != null || child != null, "TimetableStyleProv should have at least one child.");

  @override
  TimetableStyleProvState createState() => TimetableStyleProvState();
}

class TimetableStyleProvState extends State<TimetableStyleProv> {
  final $selected = TimetableInit.storage.palette.$selected;
  final $cellStyle = Settings.timetable.cell.listenStyle();

  @override
  void initState() {
    super.initState();
    $selected.addListener(refresh);
    $cellStyle.addListener(refresh);
  }

  @override
  void dispose() {
    $selected.removeListener(refresh);
    $cellStyle.removeListener(refresh);
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final data = TimetableStyleData(
      platte: TimetableInit.storage.palette.selectedRow ?? BuiltinTimetablePalettes.classic,
      cell: CourseCellStyle(
        showTeachers: Settings.timetable.cell.showTeachers,
        grayOutPassedLessons: Settings.timetable.cell.grayOutPassedLessons,
        harmonizeWithThemeColor: Settings.timetable.cell.harmonizeWithThemeColor,
      ),
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
