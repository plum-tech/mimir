import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:mimir/school/class2nd/index.dart';
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
          pinned: true,
          snap: false,
          floating: false,
          title: i18n.navigation.text(),
        ),
        const SliverToBoxAdapter(
          child: YellowPagesAppCard(),
        ),
        const SliverToBoxAdapter(
          child: Class2ndAppCard(),
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
