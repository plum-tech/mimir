import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:universal_platform/universal_platform.dart';

import '../i18n.dart';
import '../entity/exam.dart';

class ExamCard extends StatelessWidget {
  final ExamEntry exam;
  final bool enableAddEvent;

  const ExamCard(
    this.exam, {
    super.key,
    this.enableAddEvent = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.bodyMedium;
    return [
      [
        exam.courseName.text(style: context.textTheme.titleMedium),
        if (exam.isRetake == true) Chip(label: i18n.retake.text(), elevation: 2),
      ].row(maa: MainAxisAlignment.spaceBetween),
      const Divider(),
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
          if (exam.time.length >= 2)
            TableRow(children: [
              i18n.date.text(style: style),
              exam.buildDate(context).text(style: style),
            ]),
          if (exam.time.length >= 2)
            TableRow(children: [
              i18n.time.text(style: style),
              exam.buildTime(context).text(style: style),
            ]),
        ],
      ),
      if (enableAddEvent && exam.time.isNotEmpty && UniversalPlatform.isAndroid && UniversalPlatform.isIOS) ...[
        const Divider(),
        buildAddToCalenderAction(),
      ],
    ].column(caa: CrossAxisAlignment.start).padSymmetric(v: 15, h: 20).inCard();
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
  if (exam.time.length < 2) return;
  final startTime = exam.time[0];
  final endTime = exam.time[1];
  final event = Event(
    title: exam.courseName,
    description: "${i18n.seatNumber} ${exam.seatNumber}",
    location: "${exam.place} #${exam.seatNumber}",
    startDate: startTime,
    endDate: endTime,
  );
  await Add2Calendar.addEvent2Cal(event);
}
