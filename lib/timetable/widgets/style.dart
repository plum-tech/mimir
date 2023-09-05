import 'package:flutter/widgets.dart';
import 'package:mimir/design/colors.dart';

import '../init.dart';

class TimetableStyleData {
  final List<Color2Mode> colors;
  final bool useNewUI;

  const TimetableStyleData(this.colors, this.useNewUI);

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) {
    return other is TimetableStyleData &&
        runtimeType == other.runtimeType &&
        colors == other.colors &&
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

  const TimetableStyleProv({super.key, this.child, this.builder});

  @override
  TimetableStyleProvState createState() => TimetableStyleProvState();
}

class TimetableStyleProvState extends State<TimetableStyleProv> {
  final storage = TimetableInit.storage;

  @override
  void initState() {
    super.initState();
    storage.onThemeChanged.addListener(rebuild);
  }

  @override
  void dispose() {
    storage.onThemeChanged.removeListener(rebuild);
    super.dispose();
  }

  void rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.builder != null || widget.child != null, "TimetableStyleProv should have at least one child.");
    return TimetableStyle(
      data: TimetableStyleData(
        storage.useOldSchoolPalette == true ? CourseColor.oldSchool : CourseColor.v1_5,
        storage.useNewUI ?? false,
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
