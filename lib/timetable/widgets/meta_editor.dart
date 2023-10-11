import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/timetable.dart';
import '../i18n.dart';

class TimetableMetaEditor extends StatefulWidget {
  final SitTimetable timetable;

  const TimetableMetaEditor({super.key, required this.timetable});

  @override
  State<TimetableMetaEditor> createState() => _TimetableMetaEditorState();
}

class _TimetableMetaEditorState extends State<TimetableMetaEditor> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.timetable.name);
  late final ValueNotifier<DateTime> $selectedDate = ValueNotifier(widget.timetable.startDate);

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: i18n.import.timetableInfo.text(),
            actions: [
              CupertinoButton(
                onPressed: () {
                  ctx.pop(widget.timetable.copyWith(
                    name: _nameController.text,
                    startDate: $selectedDate.value,
                  ));
                },
                child: i18n.save.text(),
              ),
            ],
          ),
          SliverList.list(children: [
            buildDescForm(ctx),
            ListTile(
              leading: const Icon(Icons.alarm),
              title: i18n.startWith.text(),
              trailing: FilledButton(
                child: $selectedDate >> (ctx, value) => ctx.formatYmdText(value).text(),
                onPressed: () async {
                  final date = await _pickTimetableStartDate(context, initial: $selectedDate.value);
                  if (date != null) {
                    $selectedDate.value = DateTime(date.year, date.month, date.day);
                  }
                },
              ),
            ),
          ])
        ],
      ),
    );
  }

  Widget buildDescForm(BuildContext ctx) {
    return Form(
        key: _formKey,
        child: Column(children: [
          TextFormField(
            controller: _nameController,
            maxLines: 1,
            decoration: InputDecoration(labelText: i18n.details.nameFormTitle, border: const OutlineInputBorder()),
          ).padAll(10),
        ]));
  }
}

Future<DateTime?> _pickTimetableStartDate(
  BuildContext ctx, {
  required DateTime initial,
}) async {
  final now = DateTime.now();
  return await showDatePicker(
    context: ctx,
    initialDate: initial,
    currentDate: now,
    firstDate: DateTime(now.year - 2),
    lastDate: DateTime(now.year + 2),
    selectableDayPredicate: (DateTime dataTime) => dataTime.weekday == DateTime.monday,
  );
}
