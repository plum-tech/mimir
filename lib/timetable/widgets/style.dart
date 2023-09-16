import 'package:flutter/material.dart';
import 'package:mimir/timetable/entity/platte.dart';
import 'package:mimir/timetable/platte.dart';
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

class TimetableStyleData {
  final ITimetablePalette platte;
  final bool useNewUI;

  const TimetableStyleData(this.platte, this.useNewUI);

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) {
    return other is TimetableStyleData &&
        runtimeType == other.runtimeType &&
        platte == other.platte &&
        useNewUI == other.useNewUI;
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
    assert(result != null, 'No TimetablePalette found in context');
    return result!.data;
  }

  @override
  bool updateShouldNotify(TimetableStyle oldWidget) {
    return data != oldWidget.data;
  }
}

class TimetableStyleProv extends StatefulWidget {
  final Widget? child;
  final WidgetBuilder? builder;

  const TimetableStyleProv({super.key, this.child, this.builder})
      : assert(builder != null || child != null, "TimetableStyleProv should have at least one child.");

  @override
  TimetableStyleProvState createState() => TimetableStyleProvState();
}

class TimetableStyleProvState extends State<TimetableStyleProv> {
  final onThemeChanged = TimetableInit.storage.onThemeChanged;

  @override
  void initState() {
    super.initState();
    onThemeChanged.addListener(rebuild);
  }

  @override
  void dispose() {
    onThemeChanged.removeListener(rebuild);
    super.dispose();
  }

  void rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TimetableStyle(
      data: TimetableStyleData(
        TimetableInit.storage.useOldSchoolPalette == true
            ? BuiltinTimetablePalettes.oldSchool
            : BuiltinTimetablePalettes.newUI,
        TimetableInit.storage.useNewUI ?? false,
      ),
      child: buildChild(),
    );
  }

  Widget buildChild() {
    final child = widget.child;
    if (child != null) {
      return child;
    }
    final builder = widget.builder;
    if (builder != null) {
      return Builder(builder: builder);
    }
    return const SizedBox();
  }
}
