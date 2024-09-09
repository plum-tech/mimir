import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/credentials/entity/user_type.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/feature/feature.dart';
import 'package:mimir/school/class2nd/index.dart';
import 'package:mimir/school/event.dart';
import 'package:mimir/school/exam_arrange/index.dart';
import 'package:mimir/school/exam_result/index.pg.dart';
import 'package:mimir/school/exam_result/index.ug.dart';
import 'package:mimir/school/freshman/card.dart';
import 'package:mimir/school/library/index.dart';
import 'package:mimir/school/oa_announce/index.dart';
import 'package:mimir/school/student_plan/card.dart';
import 'package:mimir/school/yellow_pages/card.dart';
import 'package:mimir/school/ywb/index.dart';
import 'package:rettulf/rettulf.dart';
import 'i18n.dart';

class SchoolPage extends ConsumerStatefulWidget {
  const SchoolPage({super.key});

  @override
  ConsumerState<SchoolPage> createState() => _SchoolPageState();
}

class _SchoolPageState extends ConsumerState<SchoolPage> {
  @override
  Widget build(BuildContext context) {
    final userType = ref.watch(CredentialsInit.storage.oa.$userType);
    final loginStatus = ref.watch(CredentialsInit.storage.oa.$loginStatus);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        floatHeaderSlivers: true,
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
              SliverList.list(children: [
                if (userType == OaUserType.freshman) const FreshmanAppCard(),
                if (userType.has(AppFeature.secondClass$) == true) const Class2ndAppCard(),
                if (userType.has(AppFeature.examArrangement) == true) const ExamArrangeAppCard(),
                if (userType.has(AppFeature.examResultUg) == true) const ExamResultUgAppCard(),
                if (userType.has(AppFeature.examResultPg) == true) const ExamResultPgAppCard(),
                if (kDebugMode && userType.has(AppFeature.studentPlan)) const StudentPlanAppCard(),
                const OaAnnounceAppCard(),
                if (userType.has(AppFeature.ywb) == true) const YwbAppCard(),
                const LibraryAppCard(),
                const YellowPagesAppCard(),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
