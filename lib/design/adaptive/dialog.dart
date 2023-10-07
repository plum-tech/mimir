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
    final $selected = ValueNotifier<int?>(controller?.initialItem);
    final res = await navigator.push(
      CupertinoModalPopupRoute(
        builder: (ctx) => CupertinoActionSheet(
            message: CupertinoPicker(
              scrollController: controller,
              magnification: 1.22,
              useMagnifier: true,
              // This is called when selected item is changed.
              onSelectedItemChanged: (int selectedItem) {
                $selected.value = selectedItem;
              },
              squeeze: 1.5,
              itemExtent: 32.0,
              children: List<Widget>.generate(count, (int index) {
                return make(ctx, index);
              }),
            ).sized(h: targetHeight),
            actions: actions
                ?.map((e) =>
                    ValueListenableBuilder(valueListenable: $selected, builder: (ctx, value, child) => e(ctx, value)))
                .toList(),
            cancelButton: ok == null
                ? null
                : $selected >>
                    (ctx, selected) => CupertinoButton(
                        onPressed: okEnabled?.call(selected) ?? true
                            ? () {
                                Navigator.of(ctx).pop($selected.value);
                              }
                            : null,
                        child: ok.text(style: TextStyle(color: highlight ? $red$ : null)))),
      ),
    );

    return res;
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
    final $selectedA = ValueNotifier(controllerA?.initialItem ?? 0);
    final $selectedB = ValueNotifier(controllerB?.initialItem ?? 0);
    final res = await navigator.push(
      CupertinoModalPopupRoute(
        builder: (ctx) => CupertinoActionSheet(
          message: [
            CupertinoPicker(
              scrollController: controllerA,
              magnification: 1.22,
              useMagnifier: true,
              // This is called when selected item is changed.
              onSelectedItemChanged: (int selectedItem) {
                $selectedA.value = selectedItem;
              },
              squeeze: 1.5,
              itemExtent: 32.0,
              children: List<Widget>.generate(countA, (index) => makeA(ctx, index)),
            ).expanded(),
            CupertinoPicker(
              scrollController: controllerB,
              magnification: 1.22,
              useMagnifier: true,
              // This is called when selected item is changed.
              onSelectedItemChanged: (int selectedItem) {
                $selectedB.value = selectedItem;
              },
              squeeze: 1.5,
              itemExtent: 32.0,
              children: List<Widget>.generate(countA, (index) => makeB(ctx, index)),
            ).expanded(),
          ].row().sized(h: targetHeight),
          actions: actions?.map((e) => $selectedA >> (ctx, a) => $selectedB >> (ctx, b) => e(ctx, a, b)).toList(),
          cancelButton: ok == null
              ? null
              : $selectedA >>
                  (ctx, a) =>
                      $selectedB >>
                      (ctx, b) => CupertinoButton(
                            onPressed: okEnabled?.call(a, b) ?? true
                                ? () {
                                    Navigator.of(ctx).pop(($selectedA.value, $selectedB.value));
                                  }
                                : null,
                            child: ok.text(
                              style: TextStyle(
                                color: highlight ? ctx.$red$ : null,
                              ),
                            ),
                          ),
        ),
      ),
    );
    $selectedA.dispose();
    $selectedB.dispose();
    return res;
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
