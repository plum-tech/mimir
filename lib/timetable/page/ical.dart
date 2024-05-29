import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/duration_picker.dart';
import 'package:sit/design/widgets/tooltip.dart';
import 'package:sit/r.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../entity/timetable.dart';
import "../i18n.dart";

typedef TimetableICalAlarmConfig = ({
  Duration alarmBeforeClass,
  Duration alarmDuration,
  bool isDisplayAlarm,
});

typedef TimetableICalConfig = ({
  TimetableICalAlarmConfig? alarm,
  Locale? locale,
  bool isLessonMerged,
});

class TimetableICalConfigEditor extends StatefulWidget {
  final SitTimetable timetable;

  const TimetableICalConfigEditor({
    super.key,
    required this.timetable,
  });

  @override
  State<TimetableICalConfigEditor> createState() => _TimetableICalConfigEditorState();
}

class _TimetableICalConfigEditorState extends State<TimetableICalConfigEditor> {
  var enableAlarm = false;
  var alarmDuration = const Duration(minutes: 5);
  var alarmBeforeClass = const Duration(minutes: 15);
  var merged = true;
  var isDisplayAlarm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: i18n.export.title.text(),
            actions: [
              buildExportAction(),
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
      bottomNavigationBar: buildGetShortcut(),
    );
  }

  Widget? buildGetShortcut() {
    // only for iOS
    if (!UniversalPlatform.isIOS) return null;
    return BottomAppBar(
      color: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: PlatformTextButton(
        child: i18n.export.iOSGetShortcutAction.text(),
        onPressed: () {
          launchUrlString(R.iosTimetableICalToCalendarShortcut);
        },
      ),
    );
  }

  Widget buildExportAction() {
    return PlatformTextButton(
      child: i18n.export.export.text(),
      onPressed: () async {
        context.pop<TimetableICalConfig>((
          alarm: enableAlarm
              ? (
                  alarmBeforeClass: alarmBeforeClass,
                  alarmDuration: alarmDuration,
                  isDisplayAlarm: isDisplayAlarm,
                )
              : null,
          locale: context.locale,
          isLessonMerged: merged,
        ));
      },
    );
  }

  Widget buildModeSwitch() {
    return TooltipScope(
      message: merged ? i18n.export.lessonModeMergedTip : i18n.export.lessonModeSeparateTip,
      trigger: Icon(context.icons.info).padAll(8),
      builder: (context, trigger, showTooltip) {
        return ListTile(
          isThreeLine: true,
          leading: const Icon(Icons.calendar_month),
          title: i18n.export.lessonMode.text(),
          onTap: showTooltip,
          trailing: trigger,
          subtitle: [
            ChoiceChip(
              label: i18n.export.lessonModeMerged.text(),
              selected: merged,
              onSelected: (value) {
                setState(() {
                  merged = true;
                });
              },
            ),
            ChoiceChip(
              label: i18n.export.lessonModeSeparate.text(),
              selected: !merged,
              onSelected: (value) {
                setState(() {
                  merged = false;
                });
              },
            ),
          ].wrap(spacing: 4),
        );
      },
    );
  }

  Widget buildAlarmToggle() {
    return ListTile(
      leading: const Icon(Icons.alarm),
      title: i18n.export.enableAlarm.text(),
      subtitle: i18n.export.enableAlarmDesc.text(),
      trailing: Switch.adaptive(
        value: enableAlarm,
        onChanged: (newV) {
          setState(() {
            enableAlarm = newV;
          });
        },
      ),
    );
  }

  Widget buildAlarmModeSwitch() {
    return ListTile(
      isThreeLine: true,
      enabled: enableAlarm,
      title: i18n.export.alarmMode.text(),
      subtitle: [
        ChoiceChip(
          label: i18n.export.alarmModeSound.text(),
          selected: !isDisplayAlarm,
          onSelected: !enableAlarm
              ? null
              : (value) {
                  setState(() {
                    isDisplayAlarm = false;
                  });
                },
        ),
        ChoiceChip(
          label: i18n.export.alarmModeDisplay.text(),
          selected: isDisplayAlarm,
          onSelected: !enableAlarm
              ? null
              : (value) {
                  setState(() {
                    isDisplayAlarm = true;
                  });
                },
        ),
      ].wrap(spacing: 4),
    );
  }

  Widget buildAlarmDuration() {
    return ListTile(
      enabled: enableAlarm && !isDisplayAlarm,
      title: i18n.export.alarmDuration.text(),
      subtitle: i18n.time.minuteFormat(alarmDuration.inMinutes.toString()).text(),
      trailing: Icon(context.icons.edit),
      onTap: !enableAlarm
          ? null
          : () async {
              final newDuration = await showDurationPicker(
                context: context,
                initialTime: alarmDuration,
              );
              if (newDuration != null) {
                setState(() {
                  alarmDuration = newDuration;
                });
              }
            },
    );
  }

  Widget buildAlarmBeforeClassStart() {
    return ListTile(
      enabled: enableAlarm,
      title: i18n.export.alarmBeforeClassBegins.text(),
      subtitle: i18n.export.alarmBeforeClassBeginsDesc(alarmBeforeClass).text(),
      onTap: !enableAlarm
          ? null
          : () async {
              final newDuration = await showDurationPicker(
                context: context,
                initialTime: alarmBeforeClass,
              );
              if (newDuration != null) {
                setState(() {
                  alarmBeforeClass = newDuration;
                });
              }
            },
      trailing: Icon(context.icons.edit),
    );
  }
}
