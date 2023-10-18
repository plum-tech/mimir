import 'package:flutter/material.dart';
import 'package:sit/credentials/widgets/oa_scope.dart';
import 'package:sit/school/utils.dart';
import 'package:sit/school/widgets/selector.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/settings/settings.dart';

import '../../../design/widgets/common.dart';
import '../entity/exam.dart';
import '../init.dart';
import '../widgets/exam.dart';
import '../i18n.dart';

class ExamArrangePage extends StatefulWidget {
  const ExamArrangePage({super.key});

  @override
  State<StatefulWidget> createState() => _ExamArrangePageState();
}

class _ExamArrangePageState extends State<ExamArrangePage> {
  List<ExamEntry>? examList;
  bool isLoading = false;
  late SemesterInfo initial = () {
    final now = DateTime.now();
    return Settings.school.examArrange.lastSemesterInfo ??
        (
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: i18n.title.text(),
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
                itemBuilder: (ctx, i) => ExamCard(examList[i]).padH(6),
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
        Settings.school.examArrange.lastSemesterInfo = newSelection;
        refresh(newSelection);
      },
    );
  }
}
