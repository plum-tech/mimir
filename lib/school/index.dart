import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mimir/credential/entity/login_status.dart';
import 'package:mimir/credential/widgets/oa_scope.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:mimir/school/class2nd/index.dart';
import 'package:mimir/school/event.dart';
import 'package:mimir/school/exam_arrange/index.dart';
import 'package:mimir/school/exam_result/index.dart';
import 'package:mimir/school/oa_announce/index.dart';
import 'package:mimir/school/yellow_pages/index.dart';
import 'package:mimir/school/ywb/index.dart';
import 'package:rettulf/rettulf.dart';
import 'i18n.dart';

class SchoolPage extends StatefulWidget {
  const SchoolPage({super.key});

  @override
  State<SchoolPage> createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {
  LoginStatus? loginStatus;

  @override
  void didChangeDependencies() {
    final newLoginStatus = context.auth.loginStatus;
    if (loginStatus != newLoginStatus) {
      setState(() {
        loginStatus = newLoginStatus;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                title: i18n.navigation.text(),
                forceElevated: innerBoxIsScrolled,
              ),
            ),
          ];
        },
        body: RefreshIndicator.adaptive(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () async {
            debugPrint("School page refreshed");
            await HapticFeedback.heavyImpact();
            await schoolEventBus.notifyListeners();
          },
          child: CustomScrollView(
            slivers: [
              if (loginStatus != LoginStatus.never)
                const SliverToBoxAdapter(
                  child: Class2ndAppCard(),
                ),
              if (loginStatus != LoginStatus.never)
                const SliverToBoxAdapter(
                  child: ExamArrangeAppCard(),
                ),
              if (loginStatus != LoginStatus.never)
                const SliverToBoxAdapter(
                  child: ExamResultAppCard(),
                ),
              if (loginStatus != LoginStatus.never)
                const SliverToBoxAdapter(
                  child: OaAnnounceAppCard(),
                ),
              if (loginStatus != LoginStatus.never)
                const SliverToBoxAdapter(
                  child: YwbAppCard(),
                ),
              const SliverToBoxAdapter(
                child: YellowPagesAppCard(),
              ),
            ],
          ),
        ),
      ),
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
