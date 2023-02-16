import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rettulf/build_context/show.dart';
import 'package:rettulf/rettulf.dart';

import '../i18n.dart';
import 'multiplatform.dart';
import 'dialog.dart';

typedef EditorBuilder<T> = Widget Function(BuildContext ctx, String? desc, T initial);

class Editor {
  static final Map<Type, EditorBuilder> _customEditor = {};

  static void registerEditor<T>(EditorBuilder<T> builder) {
    _customEditor[T] = (ctx, desc, initial) => builder(ctx, desc, initial);
  }

  static bool isSupport(dynamic test) {
    return test is int || test is String || test is bool || _customEditor.containsKey(test.runtimeType);
  }

  static Future<dynamic> showAnyEditor(BuildContext ctx, dynamic initial,
      {String? desc, bool readonlyIfNotSupport = true}) async {
    if (initial is int) {
      return await showIntEditor(ctx, desc, initial);
    } else if (initial is String) {
      return await showStringEditor(ctx, desc, initial);
    } else if (initial is bool) {
      return await showBoolEditor(ctx, desc, initial);
    } else {
      final customEditorBuilder = _customEditor[initial.runtimeType];
      if (customEditorBuilder != null) {
        final newValue = await ctx.show$Dialog$(make: (ctx) => customEditorBuilder(ctx, desc, initial));
        if (newValue != null) {
          return newValue;
        } else {
          return initial;
        }
      } else {
        if (readonlyIfNotSupport) {
          return await showReadonlyEditor(ctx, desc, initial);
        } else {
          throw UnsupportedError("Editing $initial is not supported.");
        }
      }
    }
  }

  static Future<bool> showBoolEditor(BuildContext ctx, String? desc, bool initial) async {
    final newValue = await ctx.showDialog(
        builder: (ctx) => _BoolEditor(
              initial: initial,
              desc: desc,
            ));
    if (newValue != null) {
      return newValue;
    } else {
      return initial;
    }
  }

  static Future<String> showStringEditor(BuildContext ctx, String? desc, String initial) async {
    final newValue = await ctx.showDialog(
        builder: (ctx) => _StringEditor(
              initial: initial,
              title: desc,
            ));
    if (newValue != null) {
      return newValue;
    } else {
      return initial;
    }
  }

  static Future<void> showReadonlyEditor(BuildContext ctx, String? desc, dynamic value) async {
    await ctx.showDialog(
        builder: (ctx) => _readonlyEditor(ctx, (ctx) => SelectableText(value.toString()), title: desc));
  }

  static Future<int> showIntEditor(BuildContext ctx, String? desc, int initial) async {
    final newValue = await ctx.showDialog(
        builder: (ctx) => _IntEditor(
              initial: initial,
              title: desc,
            ));
    if (newValue == null) {
      return initial;
    } else {
      return newValue;
    }
  }
}

extension EditorEx on Editor {
  static void registerEnumEditor<T>(List<T> values) {
    Editor.registerEditor<T>((ctx, desc, initial) => EnumEditor<T>(
          initial: initial,
          title: desc,
          values: values,
        ));
  }
}

Widget _readonlyEditor(BuildContext ctx, WidgetBuilder make, {String? title}) {
  return $Dialog$(
      title: title,
      primary: $Action$(
          text: i18n.close,
          onPressed: () {
            ctx.navigator.pop(false);
          }),
      make: (ctx) => make(ctx));
}

class EnumEditor<T> extends StatefulWidget {
  final dynamic initial;
  final List<T> values;
  final String? title;

  const EnumEditor({super.key, required this.initial, this.title, required this.values});

  @override
  State<EnumEditor> createState() => _EnumEditorState();
}

class _EnumEditorState extends State<EnumEditor> {
  late dynamic current = widget.initial;
  late final int initialIndex = max(widget.values.indexOf(widget.initial), 0);

  @override
  Widget build(BuildContext context) {
    return $Dialog$(
        title: widget.title,
        primary: $Action$(
            text: i18n.submit,
            isDefault: true,
            onPressed: () {
              context.navigator.pop(current);
            }),
        secondary: $Action$(
            text: i18n.cancel,
            onPressed: () {
              context.navigator.pop(widget.initial);
            }),
        make: (ctx) => buildBody(ctx));
  }

  Widget buildBody(BuildContext ctx) {
    return ListTile(
      title: current.toString().text(style: const TextStyle(fontSize: 15)),
      trailing: const Icon(Icons.edit).onTap(() async {
        FixedExtentScrollController controller = FixedExtentScrollController(initialItem: initialIndex);
        controller.addListener(() {
          final selected = widget.values[controller.selectedItem];
          if (selected != current) {
            setState(() {
              current = selected;
            });
          }
        });
        await ctx.showPicker(
            count: widget.values.length,
            controller: controller,
            make: (ctx, index) => widget.values[index].toString().text());
        controller.dispose();
      }),
    );
  }
}

class _IntEditor extends StatefulWidget {
  final int initial;
  final String? title;

  const _IntEditor({required this.initial, this.title});

  @override
  State<_IntEditor> createState() => _IntEditorState();
}

class _IntEditorState extends State<_IntEditor> {
  late TextEditingController controller;
  late int value = widget.initial;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initial.toString());
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return $Dialog$(
        title: widget.title,
        primary: $Action$(
            text: i18n.submit,
            isDefault: true,
            onPressed: () {
              context.navigator.pop(value);
            }),
        secondary: $Action$(
            text: i18n.cancel,
            onPressed: () {
              context.navigator.pop(widget.initial);
            }),
        make: (ctx) => buildBody(ctx));
  }

  Widget buildBody(BuildContext ctx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CupertinoButton(
          child: const Icon(Icons.remove),
          onPressed: () {
            setState(() {
              value--;
              controller.text = value.toString();
            });
          },
        ),
        TextFormField(
          controller: controller,
          onChanged: (v) {
            final newV = int.tryParse(v);
            if (newV != null) {
              setState(() {
                value = newV;
              });
            }
          },
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'\d')),
          ],
        ).sized(w: 100, h: 50),
        CupertinoButton(
          child: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              value++;
              controller.text = value.toString();
            });
          },
        ),
      ],
    );
  }
}

class _BoolEditor extends StatefulWidget {
  final bool initial;
  final String? desc;

  const _BoolEditor({required this.initial, this.desc});

  @override
  State<_BoolEditor> createState() => _BoolEditorState();
}

class _BoolEditorState extends State<_BoolEditor> {
  late bool value = widget.initial;

  @override
  Widget build(BuildContext context) {
    return $Dialog$(
        primary: $Action$(
            text: i18n.submit,
            isDefault: true,
            onPressed: () {
              context.navigator.pop(value);
            }),
        secondary: $Action$(
            text: i18n.cancel,
            onPressed: () {
              context.navigator.pop(widget.initial);
            }),
        make: (ctx) => ListTile(
            title: widget.desc?.text(style: context.textTheme.bodyMedium),
            trailing: CupertinoSwitch(
              value: value,
              onChanged: (newValue) {
                setState(() {
                  value = newValue;
                });
              },
            )));
  }
}

class _StringEditor extends StatefulWidget {
  final String initial;
  final String? title;

  const _StringEditor({required this.initial, this.title});

  @override
  State<_StringEditor> createState() => _StringEditorState();
}

class _StringEditorState extends State<_StringEditor> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lines = context.isPortrait ? widget.initial.length ~/ 40 + 1 : widget.initial.length ~/ 120 + 1;
    return $Dialog$(
        title: widget.title,
        primary: $Action$(
            text: i18n.submit,
            isDefault: true,
            onPressed: () {
              context.navigator.pop(controller.text);
            }),
        secondary: $Action$(
            text: i18n.cancel,
            onPressed: () {
              context.navigator.pop(widget.initial);
            }),
        make: (ctx) => TextFormField(
              maxLines: lines,
              controller: controller,
              style: context.textTheme.bodyMedium,
            ));
  }
}
