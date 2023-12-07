import 'package:flutter/material.dart';
import 'package:sit/credentials/widgets/oa_scope.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/school/utils.dart';
import 'package:sit/school/widgets/semester.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/school/entity/school.dart';

import '../entity/exam.dart';
import '../init.dart';
import '../widgets/exam.dart';
import '../i18n.dart';

class ExamArrangementListPage extends StatefulWidget {
  const ExamArrangementListPage({super.key});

  @override
  State<StatefulWidget> createState() => _ExamArrangementListPageState();
}

class _ExamArrangementListPageState extends State<ExamArrangementListPage> {
  List<ExamEntry>? examList;
  bool isLoading = false;
  late SemesterInfo initial = () {
    final now = DateTime.now();
    return ExamArrangeInit.storage.lastSemesterInfo ??
        SemesterInfo(
          year: now.month >= 9 ? now.year : now.year - 1,
          semester: now.month >= 3 && now.month <= 7 ? Semester.term2 : Semester.term1,
        );
  }();
  late SemesterInfo selected = initial;

  @override
  void initState() {
    super.initState();
    refresh(initial);
  }

  Future<void> refresh(SemesterInfo info) async {
    if (!mounted) return;
    setState(() {
      examList = ExamArrangeInit.storage.getExamList(info);
      isLoading = true;
    });
    try {
      final examList = await ExamArrangeInit.service.getExamList(info);
      ExamArrangeInit.storage.setExamList(info, examList);
      if (info == selected) {
        if (!mounted) return;
        setState(() {
          this.examList = examList;
          isLoading = false;
        });
      }
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final examList = this.examList;
    final now = DateTime.now();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: i18n.title.text(style: context.textTheme.headlineSmall),
              background: buildSemesterSelector(),
            ),
            bottom: isLoading
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(4),
                    child: LinearProgressIndicator(),
                  )
                : null,
          ),
          if (examList != null)
            if (examList.isEmpty)
              SliverFillRemaining(
                child: LeavingBlank(
                  icon: Icons.inbox_outlined,
                  desc: i18n.noExamsTip,
                ),
              )
            else
              SliverList.builder(
                itemCount: examList.length,
                itemBuilder: (ctx, i) {
                  final exam = examList[i];
                  return FilledCard(
                    child: ExamCardContent(
                      exam,
                      enableAddEvent: exam.time?.end.isAfter(now) ?? false,
                    ),
                  ).padH(6);
                },
              ),
        ],
      ),
    );
  }

  Widget buildSemesterSelector() {
    return SemesterSelector(
      initial: initial,
      baseYear: getAdmissionYearFromStudentId(context.auth.credentials?.account),
      onSelected: (newSelection) {
        setState(() {
          selected = newSelection;
        });
        ExamArrangeInit.storage.lastSemesterInfo = newSelection;
        refresh(newSelection);
      },
    );
  }
}
