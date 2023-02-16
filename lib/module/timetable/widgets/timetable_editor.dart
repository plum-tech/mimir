import 'package:flutter/material.dart';
import 'package:mimir/module/symbol.dart';
import 'package:rettulf/rettulf.dart';

import '../using.dart';
import 'shared.dart';

class TimetableEditor extends StatefulWidget {
  final TimetableMetaLegacy meta;
  final DateTime? defaultStartDate;

  const TimetableEditor({super.key, required this.meta, this.defaultStartDate});

  @override
  State<TimetableEditor> createState() => _TimetableEditorState();
}

class _TimetableEditorState extends State<TimetableEditor> {
  late TextEditingController _metaDescController;

  @override
  void initState() {
    super.initState();
    _metaDescController = TextEditingController(text: widget.meta.description);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: buildTimetableEditor(context),
    );
  }

  final GlobalKey _formKey = GlobalKey<FormState>();

  Widget buildDescForm(BuildContext ctx) {
    return Form(
        key: _formKey,
        child: Column(children: [
          TextFormField(
            controller: _metaDescController,
            maxLines: 2,
            decoration: InputDecoration(labelText: i18n.detail.descFormTitle, border: const OutlineInputBorder()),
          )
        ]));
  }

  Widget buildTimetableEditor(BuildContext ctx) {
    final year = '${widget.meta.schoolYear} - ${widget.meta.schoolYear + 1}';
    final semester = Semester.values[widget.meta.semester].localized();
    return [
      [
        widget.meta.name.text(style: ctx.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        [
          Text(year),
          Text(semester),
          Text(i18n.startDate(ctx.dateNum(widget.meta.startDate))),
        ].row(maa: MainAxisAlignment.spaceEvenly).padV(5),
        buildDescForm(ctx).padV(20),
      ].column(),
      [
        buildButton(ctx, i18n.save, onPressed: () {
          widget.meta.description = _metaDescController.text;
          Navigator.of(ctx).pop(true);
        }),
      ].row(maa: MainAxisAlignment.spaceEvenly).vwrap()
    ]
        .column(
          maa: MainAxisAlignment.spaceBetween,
          mas: MainAxisSize.min,
        )
        .center(hFactor: 1);
  }
}
