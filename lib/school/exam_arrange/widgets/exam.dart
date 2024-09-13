import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:mimir/design/adaptive/foundation.dart';
import 'package:universal_platform/universal_platform.dart';

import '../i18n.dart';
import '../entity/exam.dart';

class ExamCardContent extends StatelessWidget {
  final ExamEntry exam;
  final bool enableAddEvent;

  const ExamCardContent(
    this.exam, {
    super.key,
    this.enableAddEvent = false,
  });

  @override
  Widget build(BuildContext context) {
    final time = exam.time;
    final disqualifiedColor = exam.disqualified ? context.$red$ : null;
    return [
      [
        exam.courseName.text(style: context.textTheme.titleMedium?.copyWith(color: disqualifiedColor)),
        [
          if (exam.disqualified)
            Chip(
              label: i18n.disqualified.text(),
              labelStyle: TextStyle(color: disqualifiedColor),
              elevation: 2,
            ),
          if (exam.isRetake)
            Chip(
              label: i18n.retake.text(),
              elevation: 2,
            ),
        ].wrap(spacing: 4),
      ].row(maa: MainAxisAlignment.spaceBetween),
      Divider(color: disqualifiedColor ?? context.colorScheme.onSurfaceVariant),
      ExamEntryDetailsTable(exam),
      if (!exam.disqualified &&
          enableAddEvent &&
          time != null &&
          (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)) ...[
        Divider(color: context.colorScheme.onSurfaceVariant),
        buildAddToCalenderAction(),
      ],
    ].column(caa: CrossAxisAlignment.start).padSymmetric(v: 15, h: 20);
  }

  Widget buildAddToCalenderAction() {
    return FilledButton.icon(
      icon: const Icon(Icons.calendar_month),
      onPressed: () async {
        await addExamArrangeToCalendar(exam);
      },
      label: i18n.addCalendarEvent.text(),
    );
  }
}

class ExamEntryDetailsTable extends StatelessWidget {
  final ExamEntry exam;

  const ExamEntryDetailsTable(
    this.exam, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final disqualifiedColor = exam.disqualified ? context.$red$ : null;
    final style = context.textTheme.bodyMedium?.copyWith(color: disqualifiedColor);
    final time = exam.time;
    return Table(
      children: [
        TableRow(children: [
          i18n.location.text(style: style),
          exam.place.text(style: style),
        ]),
        if (exam.seatNumber != null)
          TableRow(children: [
            i18n.seatNumber.text(style: style),
            exam.seatNumber.toString().text(style: style),
          ]),
        if (time != null) ...[
          TableRow(children: [
            i18n.date.text(style: style),
            exam.buildDate(context).text(style: style),
          ]),
          TableRow(children: [
            i18n.time.text(style: style),
            exam.buildTime(context).text(style: style),
          ]),
        ],
      ],
    );
  }
}

Future<void> addExamArrangeToCalendar(ExamEntry exam) async {
  final time = exam.time;
  if (time == null) return;
  final (:start, :end) = time;
  final event = Event(
    title: i18n.calendarEventTitleOf(exam.courseName),
    description: "${i18n.seatNumber} ${exam.seatNumber}",
    location: "${exam.place} #${exam.seatNumber}",
    // alert before exam, 30 minutes by default.
    iosParams: const IOSParams(reminder: Duration(minutes: 30)),
    startDate: start,
    endDate: end,
  );
  await Add2Calendar.addEvent2Cal(event);
}
