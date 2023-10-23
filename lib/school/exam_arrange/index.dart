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

  @override
  void initState() {
    super.initState();
    $refreshEvent = schoolEventBus.addListener(() {
      refresh();
    });
    refresh();
  }

  @override
  void dispose() {
    $refreshEvent.cancel();
    super.dispose();
  }

  void refresh() {
    final now = DateTime.now();
    final current = (
      year: now.month >= 9 ? now.year : now.year - 1,
      semester: now.month >= 3 && now.month <= 7 ? Semester.term2 : Semester.term1,
    );
    setState(() {
      examList = ExamArrangeInit.storage.getExamList(current);
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
    examList = examList.where((exam) => exam.time.length == 2 && exam.time[0].isAfter(now)).toList();
    examList.sort((a, b) => a.time[0].compareTo(b.time[0]));
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
          if (UniversalPlatform.isAndroid && UniversalPlatform.isIOS)
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
