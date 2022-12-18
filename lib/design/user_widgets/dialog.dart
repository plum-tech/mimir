import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rettulf/rettulf.dart';
import 'package:tuple/tuple.dart';

import 'multiplatform.dart';

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

  Future<dynamic> showSheet(WidgetBuilder builder) async {
    return await showCupertinoModalBottomSheet(
      context: this,
      builder: builder,
    );
    return await showModalBottomSheet(
        context: this,
        isScrollControlled: true,
        shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(48))),
        builder: builder);
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
            ).sized(height: targetHeight),
            actions: actions
                ?.map((e) =>
                    ValueListenableBuilder(valueListenable: $selected, builder: (ctx, value, child) => e(ctx, value)))
                .toList(),
            cancelButton: ok == null
                ? null
                : $selected <<
                    (ctx, selected, _) => CupertinoButton(
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

  Future<Tuple2<int?, int?>?> showDualPicker({
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
    final $selectedA = ValueNotifier<int?>(controllerA?.initialItem);
    final $selectedB = ValueNotifier<int?>(controllerB?.initialItem);
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
                children: List<Widget>.generate(countA, (int index) {
                  return makeA(ctx, index);
                }),
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
                children: List<Widget>.generate(countB, (int index) {
                  return makeB(ctx, index);
                }),
              ).expanded(),
            ].row().sized(height: targetHeight),
            actions:
                actions?.map((e) => $selectedA << (ctx, a, _) => $selectedB << (ctx, b, _) => e(ctx, a, b)).toList(),
            cancelButton: ok == null
                ? null
                : $selectedA <<
                    (ctx, a, _) =>
                        $selectedB <<
                        (ctx, b, _) => CupertinoButton(
                            onPressed: okEnabled?.call(a, b) ?? true
                                ? () {
                                    Navigator.of(ctx).pop(Tuple2($selectedA.value, $selectedB.value));
                                  }
                                : null,
                            child: ok.text(
                                style: TextStyle(
                              color: highlight ? ctx.$red$ : null,
                            )))),
      ),
    );
    return res;
  }
}
