import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/timetable.dart';
import '../i18n.dart';

class MetaEditor extends StatefulWidget {
  final TimetableMeta meta;

  const MetaEditor({super.key, required this.meta});

  @override
  State<MetaEditor> createState() => _MetaEditorState();
}

class _MetaEditorState extends State<MetaEditor> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.meta.name);
  late final ValueNotifier<DateTime> $selectedDate = ValueNotifier(widget.meta.startDate);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: buildMetaEditor(context),
    );
  }

  Widget buildDescForm(BuildContext ctx) {
    return Form(
        key: _formKey,
        child: Column(children: [
          TextFormField(
            controller: _nameController,
            maxLines: 1,
            decoration: InputDecoration(labelText: i18n.detail.nameFormTitle, border: const OutlineInputBorder()),
          ).padAll(10),
        ]));
  }

  Widget buildMetaEditor(BuildContext ctx) {
    final actionStyle = TextStyle(fontSize: ctx.textTheme.titleLarge?.fontSize);
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
            FilledButton(
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
              CupertinoButton(
                onPressed: () {
                  ctx.pop();
                },
                child: i18n.cancel.text(style: actionStyle),
              ),
              CupertinoButton(
                onPressed: () {
                  final meta = widget.meta.copyWith(
                    name: _nameController.text,
                    startDate: $selectedDate.value,
                  );
                  ctx.pop(meta);
                },
                child: i18n.save.text(style: actionStyle),
              ),
            ],
          ).padV(12)
        ],
      ),
    );
  }
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
