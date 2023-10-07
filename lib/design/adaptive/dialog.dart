import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import 'foundation.dart';

typedef PickerActionWidgetBuilder = Widget Function(BuildContext context, int? selectedIndex);
typedef DualPickerActionWidgetBuilder = Widget Function(BuildContext context, int? selectedIndexA, int? selectedIndexB);

extension DialogEx on BuildContext {
  /// return: whether the button was hit
  Future<bool> showTip({
    required String title,
    required String desc,
    required String ok,
    bool highlight = false,
    bool serious = false,
  }) async {
    return showAnyTip(
      title: title,
      make: (_) => desc.text(style: const TextStyle()),
      ok: ok,
      highlight: false,
      serious: serious,
    );
  }

  Future<bool> showAnyTip({
    required String title,
    required WidgetBuilder make,
    required String ok,
    bool highlight = false,
    bool serious = false,
  }) async {
    final dynamic confirm = await show$Dialog$(
      make: (ctx) => $Dialog$(
          title: title,
          serious: serious,
          make: make,
          primary: $Action$(
            warning: highlight,
            text: ok,
            onPressed: () {
              ctx.navigator.pop(true);
            },
          )),
    );
    return confirm == true;
  }

  Future<bool?> showRequest({
    required String title,
    required String desc,
    required String yes,
    required String no,
    bool highlight = false,
    bool serious = false,
  }) async {
    return await showAnyRequest(
      title: title,
      make: (_) => desc.text(style: const TextStyle()),
      yes: yes,
      no: no,
      highlight: highlight,
      serious: serious,
    );
  }

  Future<bool?> showAnyRequest({
    required String title,
    required WidgetBuilder make,
    required String yes,
    required String no,
    bool highlight = false,
    bool serious = false,
  }) async {
    return await show$Dialog$(
      make: (ctx) => $Dialog$(
        title: title,
        serious: serious,
        make: make,
        primary: $Action$(
          warning: highlight,
          text: yes,
          onPressed: () {
            ctx.navigator.pop(true);
          },
        ),
        secondary: $Action$(
          text: no,
          onPressed: () {
            ctx.navigator.pop(false);
          },
        ),
      ),
    );
  }

  Future<int?> showPicker({
    required int count,
    String? ok,
    bool Function(int? selected)? okEnabled,
    double targetHeight = 240,
    bool highlight = false,
    FixedExtentScrollController? controller,
    List<PickerActionWidgetBuilder>? actions,
    required IndexedWidgetBuilder make,
  }) async {
    final res = await navigator.push(
      CupertinoModalPopupRoute(
        builder: (ctx) => SoloPicker(
          make: make,
          count: count,
          controller: controller,
          ok: ok,
          okEnabled: okEnabled,
          targetHeight: targetHeight,
          highlight: highlight,
          actions: actions,
        ),
      ),
    );
    if (res is int) {
      return res;
    } else {
      assert(res == null, "return value is ${res.runtimeType} actually");
      return null;
    }
  }

  Future<(int, int)?> showDualPicker({
    required int countA,
    required int countB,
    String? ok,
    bool Function(int? selectedA, int? selectedB)? okEnabled,
    double targetHeight = 240,
    bool highlight = false,
    FixedExtentScrollController? controllerA,
    FixedExtentScrollController? controllerB,
    List<DualPickerActionWidgetBuilder>? actions,
    required IndexedWidgetBuilder makeA,
    required IndexedWidgetBuilder makeB,
  }) async {
    final res = await navigator.push(
      CupertinoModalPopupRoute(
        builder: (ctx) => DualPicker(
          makeA: makeA,
          countA: countA,
          countB: countB,
          makeB: makeB,
          controllerA: controllerA,
          controllerB: controllerB,
          ok: ok,
          okEnabled: okEnabled,
          targetHeight: targetHeight,
          highlight: highlight,
          actions: actions,
        ),
      ),
    );
    if (res is (int, int)) {
      return res;
    } else {
      assert(res == null, "return value is ${res.runtimeType} actually");
      return null;
    }
  }
}

class SoloPicker extends StatefulWidget {
  final int count;
  final String? ok;
  final bool Function(int? selected)? okEnabled;
  final double targetHeight;
  final bool highlight;
  final FixedExtentScrollController? controller;
  final List<PickerActionWidgetBuilder>? actions;
  final IndexedWidgetBuilder make;

  const SoloPicker({
    super.key,
    required this.count,
    this.ok,
    this.okEnabled,
    this.controller,
    this.targetHeight = 240,
    this.highlight = false,
    this.actions,
    required this.make,
  });

  @override
  State<SoloPicker> createState() => _SoloPickerState();
}

class _SoloPickerState extends State<SoloPicker> {
  late final $selected = ValueNotifier(widget.controller?.initialItem);

  @override
  void dispose() {
    $selected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ok = widget.ok;
    return CupertinoActionSheet(
        message: CupertinoPicker(
          scrollController: widget.controller,
          magnification: 1.22,
          useMagnifier: true,
          // This is called when selected item is changed.
          onSelectedItemChanged: (int selectedItem) {
            $selected.value = selectedItem;
          },
          squeeze: 1.5,
          itemExtent: 32.0,
          children: List<Widget>.generate(widget.count, (index) => widget.make(context, index)),
        ).sized(h: widget.targetHeight),
        actions: widget.actions
            ?.map((e) =>
                ValueListenableBuilder(valueListenable: $selected, builder: (ctx, value, child) => e(ctx, value)))
            .toList(),
        cancelButton: ok == null
            ? null
            : $selected >>
                (ctx, selected) => CupertinoButton(
                    onPressed: widget.okEnabled?.call(selected) ?? true
                        ? () {
                            Navigator.of(ctx).pop($selected.value);
                          }
                        : null,
                    child: ok.text(style: TextStyle(color: widget.highlight ? ctx.$red$ : null))));
  }
}

class DualPicker extends StatefulWidget {
  final FixedExtentScrollController? controllerA;
  final FixedExtentScrollController? controllerB;
  final int countA;
  final int countB;
  final String? ok;
  final bool Function(int? selectedA, int? selectedB)? okEnabled;
  final double targetHeight;
  final bool highlight;
  final List<DualPickerActionWidgetBuilder>? actions;
  final IndexedWidgetBuilder makeA;
  final IndexedWidgetBuilder makeB;

  const DualPicker({
    super.key,
    this.ok,
    this.okEnabled,
    this.actions,
    this.highlight = false,
    this.targetHeight = 240,
    this.controllerA,
    this.controllerB,
    required this.makeA,
    required this.countA,
    required this.countB,
    required this.makeB,
  });

  @override
  State<DualPicker> createState() => _DualPickerState();
}

class _DualPickerState extends State<DualPicker> {
  late final $selectedA = ValueNotifier(widget.controllerA?.initialItem ?? 0);
  late final $selectedB = ValueNotifier(widget.controllerB?.initialItem ?? 0);

  @override
  void dispose() {
    $selectedA.dispose();
    $selectedB.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ok = widget.ok;
    return CupertinoActionSheet(
      message: [
        CupertinoPicker(
          scrollController: widget.controllerA,
          magnification: 1.22,
          useMagnifier: true,
          // This is called when selected item is changed.
          onSelectedItemChanged: (int selectedItem) {
            $selectedA.value = selectedItem;
          },
          squeeze: 1.5,
          itemExtent: 32.0,
          children: List<Widget>.generate(widget.countA, (index) => widget.makeA(context, index)),
        ).expanded(),
        CupertinoPicker(
          scrollController: widget.controllerB,
          magnification: 1.22,
          useMagnifier: true,
          // This is called when selected item is changed.
          onSelectedItemChanged: (int selectedItem) {
            $selectedB.value = selectedItem;
          },
          squeeze: 1.5,
          itemExtent: 32.0,
          children: List<Widget>.generate(widget.countB, (index) => widget.makeB(context, index)),
        ).expanded(),
      ].row().sized(h: widget.targetHeight),
      actions: widget.actions?.map((e) => $selectedA >> (ctx, a) => $selectedB >> (ctx, b) => e(ctx, a, b)).toList(),
      cancelButton: ok == null
          ? null
          : $selectedA >>
              (ctx, a) =>
                  $selectedB >>
                  (ctx, b) => CupertinoButton(
                        onPressed: widget.okEnabled?.call(a, b) ?? true
                            ? () {
                                Navigator.of(ctx).pop(($selectedA.value, $selectedB.value));
                              }
                            : null,
                        child: ok.text(
                          style: TextStyle(
                            color: widget.highlight ? ctx.$red$ : null,
                          ),
                        ),
                      ),
    );
  }
}

extension SnackBarX on BuildContext {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    Widget content, {
    Duration duration = const Duration(milliseconds: 800),
  }) {
    final snackBar = SnackBar(
      content: content,
      duration: duration,
    );

    return ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }
}
