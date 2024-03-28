import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/app.dart';
import 'package:sit/school/utils.dart';
import 'package:sit/school/exam_arrange/entity/exam.dart';
import 'package:sit/school/exam_arrange/init.dart';
import 'package:rettulf/rettulf.dart';
import 'package:super_context_menu/super_context_menu.dart';
import 'package:universal_platform/universal_platform.dart';

import "i18n.dart";
import 'widgets/exam.dart';

class ExamArrangeAppCard extends ConsumerStatefulWidget {
  const ExamArrangeAppCard({super.key});

  @override
  ConsumerState<ExamArrangeAppCard> createState() => _ExamArrangeAppCardState();
}

class _ExamArrangeAppCardState extends ConsumerState<ExamArrangeAppCard> {

  @override
  Widget build(BuildContext context) {
    final storage = ExamArrangeInit.storage;
    final currentSemester = estimateCurrentSemester();
    ref.watch(storage.$examListFamily(currentSemester));
    final examList = storage.getExamList(currentSemester);
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
    if (!supportContextMenu) {
      return ExamCard(exam);
    }
    return Builder(builder: (context) {
      return ContextMenuWidget(
        menuProvider: (MenuRequest request) {
          return Menu(
            children: [
              if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)
                MenuAction(
                  image: MenuImage.icon(CupertinoIcons.calendar_badge_plus),
                  title: i18n.addCalendarEvent,
                  callback: () async {
                    await addExamArrangeToCalendar(exam);
                  },
                ),
              MenuAction(
                image: MenuImage.icon(context.icons.share),
                title: i18n.share,
                callback: () async {
                  await shareExamArrange(exam: exam, context: context);
                },
              ),
            ],
          );
        },
        child: ExamCard(exam),
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
