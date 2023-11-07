import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/settings/settings.dart';

import '../entity/timetable.dart';
import '../i18n.dart';

class TimetableEditor extends StatefulWidget {
  final SitTimetable timetable;

  const TimetableEditor({super.key, required this.timetable});

  @override
  State<TimetableEditor> createState() => _TimetableEditorState();
}

class _TimetableEditorState extends State<TimetableEditor> {
  final _formKey = GlobalKey<FormState>();
  late final $name = TextEditingController(text: widget.timetable.name);
  late final $selectedDate = ValueNotifier(widget.timetable.startDate);
  final $signature = TextEditingController(text: Settings.lastSignature);

  @override
  void dispose() {
    $name.dispose();
    $selectedDate.dispose();
    $signature.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: i18n.import.timetableInfo.text(),
            actions: [
              buildSaveAction(),
            ],
          ),
          SliverList.list(children: [
            buildDescForm(),
            buildStartDate(),
            buildSignature(),
          ])
        ],
      ),
    );
  }

  Widget buildStartDate() {
    return ListTile(
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
    );
  }

  Widget buildSignature() {
    return ListTile(
      isThreeLine: true,
      leading: const Icon(Icons.drive_file_rename_outline),
      title: i18n.signature.text(),
      subtitle: TextField(
        controller: $signature,
        decoration: InputDecoration(
          hintText: i18n.signaturePlaceholder,
        ),
      ),
    );
  }

  Widget buildSaveAction() {
    return PlatformTextButton(
      onPressed: () {
        final signature = $signature.text.trim();
        Settings.lastSignature = signature;
        context.pop(widget.timetable.copyWith(
          name: $name.text,
          signature: signature,
          startDate: $selectedDate.value,
        ));
      },
      child: i18n.save.text(),
    );
  }

  Widget buildDescForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: $name,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: i18n.editor.name,
              border: const OutlineInputBorder(),
            ),
          ).padAll(10),
        ],
      ),
    );
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
