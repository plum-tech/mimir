import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../i18n.dart';
import '../entity/meta.dart';

class MetaEditor extends StatefulWidget {
  final TimetableMeta meta;

  const MetaEditor({super.key, required this.meta});

  @override
  State<MetaEditor> createState() => _MetaEditorState();
}

class _MetaEditorState extends State<MetaEditor> {
  late final _nameController = TextEditingController(text: widget.meta.name);
  final GlobalKey _formKey = GlobalKey<FormState>();
  late final ValueNotifier<DateTime> $selectedDate;

  @override
  void initState() {
    super.initState();
    $selectedDate = ValueNotifier(widget.meta.startDate);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: buildMetaEditor(context),
    );
  }

  Widget _wrap(Widget widget) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: widget,
    );
  }

  Widget buildDescForm(BuildContext ctx) {
    return Form(
        key: _formKey,
        child: Column(children: [
          _wrap(TextFormField(
            controller: _nameController,
            maxLines: 1,
            decoration: InputDecoration(labelText: i18n.detail.nameFormTitle, border: const OutlineInputBorder()),
          )),
        ]));
  }

  Widget buildMetaEditor(BuildContext ctx) {
    return Center(
      heightFactor: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(i18n.import.timetableInfo, style: ctx.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          buildDescForm(ctx),
          [
            i18n.startWith.text(style: ctx.textTheme.titleLarge),
            ElevatedButton(
              child: $selectedDate >>
                  (ctx, value) =>
                      ctx.formatYmdText(value).text(style: TextStyle(fontSize: ctx.textTheme.bodyLarge?.fontSize)),
              onPressed: () async {
                final date = await _pickTimetableStartDate(context, initial: $selectedDate.value);
                if (date != null) {
                  $selectedDate.value = DateTime(date.year, date.month, date.day);
                }
              },
            )
          ].row(maa: MainAxisAlignment.spaceEvenly),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(ctx, i18n.cancel, onPressed: () {
                ctx.pop();
              }),
              _buildButton(ctx, i18n.save, onPressed: () {
                final meta = widget.meta.copyWith(
                  name: _nameController.text,
                  startDate: $selectedDate.value,
                );
                ctx.pop(meta);
              }),
            ],
          ).padV(12)
        ],
      ),
    );
  }
}

Widget _buildButton(BuildContext ctx, String text, {VoidCallback? onPressed}) {
  return CupertinoButton(
    onPressed: onPressed,
    child: text.text(
      style: TextStyle(fontSize: ctx.textTheme.titleLarge?.fontSize),
    ),
  );
}

Future<DateTime?> _pickTimetableStartDate(
    BuildContext ctx, {
      required DateTime initial,
    }) async {
  return await showDatePicker(
    context: ctx,
    initialDate: initial,
    currentDate: DateTime.now(),
    firstDate: DateTime(DateTime.now().year - 2),
    lastDate: DateTime(DateTime.now().year + 2),
    selectableDayPredicate: (DateTime dataTime) => dataTime.weekday == DateTime.monday,
  );
}
