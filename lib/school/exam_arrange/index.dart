import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/app.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/school/event.dart';
import 'package:sit/school/exam_arrange/entity/exam.dart';
import 'package:sit/school/exam_arrange/init.dart';
import 'package:sit/utils/async_event.dart';
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

import "i18n.dart";
import 'widgets/exam.dart';

class ExamArrangeAppCard extends StatefulWidget {
  const ExamArrangeAppCard({super.key});

  @override
  State<ExamArrangeAppCard> createState() => _ExamArrangeAppCardState();
}

class _ExamArrangeAppCardState extends State<ExamArrangeAppCard> {
  List<ExamEntry>? examList;
  late final EventSubscription $refreshEvent;
  late final StreamSubscription $examList;
  late final currentSemester = estimateCurrentSemester();

  @override
  void initState() {
    super.initState();
    $refreshEvent = schoolEventBus.addListener(() {
      refresh();
    });
    $examList = ExamArrangeInit.storage.watchExamList(() => currentSemester).listen((event) {
      refresh();
    });
    refresh();
  }

  @override
  void dispose() {
    $refreshEvent.cancel();
    $examList.cancel();
    super.dispose();
  }

  void refresh() {
    setState(() {
      examList = ExamArrangeInit.storage.getExamList(currentSemester);
    });
  }

  @override
  Widget build(BuildContext context) {
    final examList = this.examList;
    return AppCard(
      title: i18n.title.text(),
      view: examList != null ? buildMostRecentExam(examList) : null,
      leftActions: [
        FilledButton.icon(
          onPressed: () {
            context.push("/exam-arrange");
          },
          icon: const Icon(Icons.calendar_month),
          label: i18n.check.text(),
        ),
      ],
    );
  }

  Widget? buildMostRecentExam(List<ExamEntry> examList) {
    if (examList.isEmpty) return const SizedBox();
    final now = DateTime.now();
    examList = examList.where((exam) => exam.time?.start.isAfter(now) ?? false).toList();
    examList.sort(ExamEntry.comparator);
    final mostRecent = examList.firstOrNull;
    if (mostRecent == null) return null;
    return buildExam(mostRecent);
  }

  Widget buildExam(ExamEntry exam) {
    if (!isCupertino) {
      return ExamCard(exam);
    }
    return Builder(builder: (context) {
      return CupertinoContextMenu.builder(
        enableHapticFeedback: true,
        actions: [
          if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)
            CupertinoContextMenuAction(
              trailingIcon: CupertinoIcons.calendar_badge_plus,
              child: i18n.addCalendarEvent.text(),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await addExamArrangeToCalendar(exam);
              },
            ),
          CupertinoContextMenuAction(
            trailingIcon: CupertinoIcons.share,
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await shareExamArrange(exam: exam, context: context);
            },
            child: i18n.share.text(),
          ),
        ],
        builder: (context, animation) {
          return ExamCard(exam).scrolled(physics: const NeverScrollableScrollPhysics());
        },
      );
    });
  }
}

Future<void> shareExamArrange({
  required ExamEntry exam,
  required BuildContext context,
}) async {
  var text = "${exam.courseName}, ${exam.buildDate(context)}, ${exam.buildTime(context)}, ${exam.place}";
  if (exam.seatNumber != null) {
    text += ", ${i18n.seatNumber} ${exam.seatNumber}";
  }
  await Share.share(
    text,
    sharePositionOrigin: context.getSharePositionOrigin(),
  );
}

class ExamCard extends StatelessWidget {
  final ExamEntry exam;

  const ExamCard(
    this.exam, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return [
      [
        exam.courseName.text(style: context.textTheme.titleMedium),
        if (exam.isRetake == true) Chip(label: i18n.retake.text(), elevation: 2),
      ].row(maa: MainAxisAlignment.spaceBetween),
      const Divider(),
      ExamEntryDetailsTable(exam),
    ].column(caa: CrossAxisAlignment.start).padSymmetric(v: 15, h: 20).inCard();
  }
}
