import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:mimir/school/class2nd/index.dart';
import 'package:mimir/school/exam_arr/index.dart';
import 'package:mimir/school/exam_result/index.dart';
import 'package:mimir/school/oa_announce/index.dart';
import 'package:mimir/school/yellow_pages/index.dart';
import 'package:rettulf/rettulf.dart';
import 'i18n.dart';

class SchoolPage extends StatefulWidget {
  const SchoolPage({super.key});

  @override
  State<SchoolPage> createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          snap: false,
          floating: false,
          title: i18n.navigation.text(),
        ),
        const SliverToBoxAdapter(
          child: Class2ndAppCard(),
        ),
        const SliverToBoxAdapter(
          child: ExamArrangeAppCard(),
        ),
        const SliverToBoxAdapter(
          child: ExamResultAppCard(),
        ),
        const SliverToBoxAdapter(
          child: OaAnnounceAppCard(),
        ),
        const SliverToBoxAdapter(
          child: YellowPagesAppCard(),
        ),
      ],
    );
  }
}

class ExamArrApp extends StatefulWidget {
  const ExamArrApp({super.key});

  @override
  State<ExamArrApp> createState() => _ExamArrAppState();
}

class _ExamArrAppState extends State<ExamArrApp> {
  @override
  Widget build(BuildContext context) {
    return FilledCard(
      child: [
        ListTile(
          titleTextStyle: context.textTheme.titleLarge,
          title: "Exam Arrangement".text(),
          subtitle: "aa".text(),
        ),
        OverflowBar(
          children: [],
        ),
      ].column(),
    );
  }
}
