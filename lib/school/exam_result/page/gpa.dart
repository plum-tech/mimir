import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/school/exam_result/entity/result.ug.dart';
import 'package:sit/school/exam_result/init.dart';
import 'package:sit/utils/error.dart';
import '../i18n.dart';
import '../widgets/ug.dart';

class GpaCalculatorPage extends StatefulWidget {
  const GpaCalculatorPage({super.key});

  @override
  State<GpaCalculatorPage> createState() => _GpaCalculatorPageState();
}

class _GpaCalculatorPageState extends State<GpaCalculatorPage> {
  late List<ExamResultUg>? resultList = ExamResultInit.ugStorage.getResultList(SemesterInfo.all);
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    fetchAll();
  }

  Future<void> fetchAll() async {
    setState(() {
      isFetching = true;
    });
    try {
      final results = await ExamResultInit.ugService.fetchResultList(SemesterInfo.all);
      ExamResultInit.ugStorage.setResultList(SemesterInfo.all, results);
      if (!mounted) return;
      setState(() {
        resultList = results;
        isFetching = false;
      });
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
      if (!mounted) return;
      setState(() {
        isFetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final resultList = this.resultList;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: "GPA".text(),
          ),
          if (resultList != null)
            if (resultList.isEmpty)
              SliverFillRemaining(
                child: LeavingBlank(
                  icon: Icons.inbox_outlined,
                  desc: i18n.noResultsTip,
                ),
              )
            else
              SliverList.builder(
                itemCount: resultList.length,
                itemBuilder: (item, i) => ExamResultUgCard(
                  resultList[i],
                  elevated: false,
                ),
              ),
        ],
      ),
    );
  }
}
