import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/duration_picker.dart';
import '../entity/timetable.dart';
import '../utils.dart';
import "../i18n.dart";

typedef TimetableCalendarExportAlarmConfig = ({
  Duration alarmBeforeClass,
  Duration alarmDuration,
  bool isSoundAlarm,
});

typedef TimetableCalendarExportConfig = ({
  TimetableCalendarExportAlarmConfig? alarm,
  Locale? locale,
  bool isLessonMerged,
});

class TimetableCalendarExportConfigPage extends StatefulWidget {
  final SitTimetable timetable;

  const TimetableCalendarExportConfigPage({
    super.key,
    required this.timetable,
  });

  @override
  State<TimetableCalendarExportConfigPage> createState() => _TimetableCalendarExportConfigPageState();
}

class _TimetableCalendarExportConfigPageState extends State<TimetableCalendarExportConfigPage> {
  final $enableAlarm = ValueNotifier(false);
  final $alarmDuration = ValueNotifier(const Duration(minutes: 15));
  final $alarmBeforeClass = ValueNotifier(const Duration(minutes: 15));
  final $merged = ValueNotifier(true);
  final $isSoundAlarm = ValueNotifier(false);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: "Calendar export".text(),
            actions: [
              CupertinoButton(
                child: "Export".text(),
                onPressed: () async {
                  await exportTimetableAsICalendarAndOpen(
                    context,
                    timetable: widget.timetable.resolve(),
                    config: (
                      alarm: $enableAlarm.value
                          ? (
                              alarmBeforeClass: $alarmBeforeClass.value,
                              alarmDuration: $alarmDuration.value,
                              isSoundAlarm: $isSoundAlarm.value,
                            )
                          : null,
                      locale: context.locale,
                      isLessonMerged: $merged.value,
                    ),
                  );
                },
              ),
            ],
          ),
          SliverList.list(children: [
            buildModeSwitch(),
            const Divider(),
            buildAlarmToggle(),
            buildAlarmModeSwitch(),
            buildAlarmDuration(),
            buildAlarmBeforeClassStart(),
          ]),
        ],
      ),
    );
  }

  Widget buildModeSwitch() {
    return ListTile(
      title: "Lesson Mode".text(),
      subtitle: "How lesson to event".text(),
      trailing: $merged >>
          (ctx, value) => SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment<bool>(
                    value: true,
                    label: "Merged".text(),
                  ),
                  ButtonSegment<bool>(
                    value: false,
                    label: "Separate".text(),
                  ),
                ],
                selected: <bool>{value},
                onSelectionChanged: (newSelection) async {
                  $merged.value = newSelection.first;
                  await HapticFeedback.selectionClick();
                },
              ),
    );
  }

  Widget buildAlarmToggle() {
    return ListTile(
      leading: const Icon(Icons.alarm),
      title: "Enable alarm".text(),
      subtitle: "Add alarm before class".text(),
      trailing: $enableAlarm >>
          (ctx, value) => Switch(
                value: value,
                onChanged: (newV) {
                  $enableAlarm.value = newV;
                },
              ),
    );
  }

  Widget buildAlarmModeSwitch() {
    return $enableAlarm >>
        (ctx, enabled) => ListTile(
              enabled: enabled,
              title: "Alarm mode".text(),
              subtitle: "How to notify you".text(),
              trailing: $isSoundAlarm >>
                  (ctx, value) => SegmentedButton<bool>(
                        showSelectedIcon: false,
                        segments: [
                          ButtonSegment<bool>(
                            value: true,
                            label: "Sound".text(),
                          ),
                          ButtonSegment<bool>(
                            value: false,
                            label: "Display".text(),
                          ),
                        ],
                        selected: <bool>{value},
                        onSelectionChanged: !enabled
                            ? null
                            : (newSelection) async {
                                $isSoundAlarm.value = newSelection.first;
                                await HapticFeedback.selectionClick();
                              },
                      ),
            );
  }

  Widget buildAlarmDuration() {
    return $enableAlarm >>
        (ctx, enabled) =>
            $alarmDuration >>
            (ctx, duration) => ListTile(
                  enabled: enabled,
                  title: "Alarm duration".text(),
                  subtitle: i18n.time.minuteFormat(duration.inMinutes.toString()).text(),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: !enabled
                        ? null
                        : () async {
                            final newDuration = await showDurationPicker(
                              context: ctx,
                              initialTime: duration,
                            );
                            if (newDuration != null) {
                              $alarmDuration.value = newDuration;
                            }
                          },
                  ),
                );
  }

  Widget buildAlarmBeforeClassStart() {
    return $enableAlarm >>
        (ctx, enabled) =>
            $alarmBeforeClass >>
            (ctx, duration) => ListTile(
                  enabled: enabled,
                  title: "Alarm before class starts".text(),
                  subtitle: i18n.time.minuteFormat(duration.inMinutes.toString()).text(),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: !enabled
                        ? null
                        : () async {
                            final newDuration = await showDurationPicker(
                              context: ctx,
                              initialTime: duration,
                            );
                            if (newDuration != null) {
                              $alarmBeforeClass.value = newDuration;
                            }
                          },
                  ),
                );
  }
}
