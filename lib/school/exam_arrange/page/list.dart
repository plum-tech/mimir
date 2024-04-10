import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/school/utils.dart';
import 'package:sit/school/widgets/semester.dart';
import 'package:sit/utils/error.dart';

import '../entity/exam.dart';
import '../i18n.dart';
import '../init.dart';
import '../widgets/exam.dart';

class ExamArrangementListPage extends ConsumerStatefulWidget {
  const ExamArrangementListPage({super.key});

  @override
  ConsumerState<ExamArrangementListPage> createState() => _ExamArrangementListPageState();
}

class _ExamArrangementListPageState extends ConsumerState<ExamArrangementListPage> {
  List<ExamEntry>? examList;
  bool isFetching = false;
  late SemesterInfo initial = ExamArrangeInit.storage.lastSemesterInfo ?? estimateCurrentSemester();
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
      isFetching = true;
    });
    try {
      final examList = await ExamArrangeInit.service.fetchExamList(info);
      ExamArrangeInit.storage.setExamList(info, examList);
      if (info == selected) {
        if (!mounted) return;
        setState(() {
          this.examList = examList;
          isFetching = false;
        });
      }
    } catch (error, stackTrace) {
      handleRequestError(context, error, stackTrace);
      if (!mounted) return;
      setState(() {
        isFetching = false;
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
          SliverAppBar.medium(
            title: i18n.title.text(),
          ),
          SliverToBoxAdapter(
            child: buildSemesterSelector(),
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
                  return Card.filled(
                    child: ExamCardContent(
                      exam,
                      enableAddEvent: exam.time?.end.isAfter(now) ?? false,
                    ),
                  ).padH(6);
                },
              ),
        ],
      ),
      bottomNavigationBar: isFetching
          ? const PreferredSize(
              preferredSize: Size.fromHeight(4),
              child: LinearProgressIndicator(),
            )
          : null,
    );
  }

  Widget buildSemesterSelector() {
    final credentials = ref.watch(CredentialsInit.storage.$oaCredentials);
    return SemesterSelector(
      initial: initial,
      baseYear: getAdmissionYearFromStudentId(credentials?.account),
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
