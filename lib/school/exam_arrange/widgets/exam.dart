import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:universal_platform/universal_platform.dart';

import '../i18n.dart';
import '../entity/exam.dart';

class ExamCard extends StatelessWidget {
  final ExamEntry exam;
  final bool enableAddEvent;

  const ExamCard(
    this.exam, {
    super.key,
    required this.enableAddEvent,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.bodyMedium;
    final time = exam.time;
    return FilledCard(
      child: [
        [
          exam.courseName.text(style: context.textTheme.titleMedium),
          if (exam.isRetake == true) Chip(label: i18n.retake.text(), elevation: 2),
        ].row(maa: MainAxisAlignment.spaceBetween),
        Divider(color: context.colorScheme.onSurfaceVariant),
        Table(
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
        ),
        if (enableAddEvent && time != null && (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)) ...[
          Divider(color: context.colorScheme.onSurfaceVariant),
          buildAddToCalenderAction(),
        ],
      ].column(caa: CrossAxisAlignment.start).padSymmetric(v: 15, h: 20),
    );
  }

  Widget buildAddToCalenderAction() {
    return FilledButton.icon(
      icon: const Icon(Icons.calendar_month),
      onPressed: () async {
        await addExamArrangeToCalendar(
          exam,
        );
      },
      label: i18n.addCalendarEvent.text(),
    );
  }
}

Future<void> addExamArrangeToCalendar(ExamEntry exam) async {
  final time = exam.time;
  if (time == null) return;
  final (:start, :end) = time;
  final event = Event(
    title: exam.courseName,
    description: "${i18n.seatNumber} ${exam.seatNumber}",
    location: "${exam.place} #${exam.seatNumber}",
    startDate: start,
    endDate: end,
  );
  await Add2Calendar.addEvent2Cal(event);
}
