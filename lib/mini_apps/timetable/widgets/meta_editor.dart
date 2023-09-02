import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/meta.dart';
import '../using.dart';
import 'shared.dart';
import 'picker.dart';

class MetaEditor extends StatefulWidget {
  final TimetableMetaLegacy meta;

  const MetaEditor({super.key, required this.meta});

  @override
  State<MetaEditor> createState() => _MetaEditorState();
}

class _MetaEditorState extends State<MetaEditor> {
  late final _nameController = TextEditingController(text: widget.meta.name);
  late final _descController = TextEditingController(text: widget.meta.description);
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
          _wrap(TextFormField(
            controller: _descController,
            maxLines: 2,
            decoration: InputDecoration(labelText: i18n.detail.descFormTitle, border: const OutlineInputBorder()),
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
          $selectedDate >> (ctx, value) => Text(i18n.startDate(ctx.formatYmdNum(value))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton(ctx, i18n.save, onPressed: () {
                final meta = widget.meta;
                meta.name = _nameController.text;
                meta.description = _descController.text;
                meta.startDate = $selectedDate.value;
                Navigator.of(ctx).pop(true);
              }),
              buildButton(ctx, i18n.edit.setStartDate, onPressed: () async {
                final date = await pickDate(context, initial: $selectedDate.value);
                if (date != null) {
                  $selectedDate.value = DateTime(date.year, date.month, date.day, 8, 20);
                }
              })
            ],
          ).vwrap()
        ],
      ),
    );
  }
}
