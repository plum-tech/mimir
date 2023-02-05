import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../using.dart';

class ReminderDialog extends StatefulWidget {
  const ReminderDialog({super.key});

  @override
  State<ReminderDialog> createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog> {
  final ValueNotifier<TimeOfDay?> _notifier =
      ValueNotifier(Kv.report.time == null ? null : TimeOfDay.fromDateTime(Kv.report.time!));

  @override
  Widget build(BuildContext context) {
    final reportTime = Kv.report.time;
    if (reportTime != null) {
      _notifier.value = TimeOfDay(hour: reportTime.hour, minute: reportTime.minute);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        i18n.reportTempReminderDesc.text(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            i18n.reportTempReminderSwitch.text(),
            Switch(
              value: Kv.report.enable ?? false,
              onChanged: (value) {
                setState(() {
                  Kv.report.enable = value;
                });
              },
            ),
          ],
        ),
        if (Kv.report.enable ?? false)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              i18n.reportTempRemindTime.text(),
              TextButton(
                onPressed: () async {
                  final selectTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(reportTime ?? DateTime.now()),
                  );
                  if (selectTime == null) return;
                  _notifier.value = selectTime;
                  Kv.report.time = DateTime(0, 0, 0, selectTime.hour, selectTime.minute);
                },
                child: ValueListenableBuilder<TimeOfDay?>(
                  valueListenable: _notifier,
                  builder: (context, data, widget) {
                    if (data == null) {
                      return const TimeOfDay(hour: 0, minute: 0).format(context).text();
                    }
                    return data.format(context).text();
                  },
                ),
              ),
            ],
          )
      ],
    );
  }
}
