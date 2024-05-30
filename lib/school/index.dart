import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sit/credentials/entity/login_status.dart';
import 'package:sit/credentials/entity/user_type.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/school/class2nd/index.dart';
import 'package:sit/school/event.dart';
import 'package:sit/school/exam_arrange/index.dart';
import 'package:sit/school/exam_result/index.pg.dart';
import 'package:sit/school/exam_result/index.ug.dart';
import 'package:sit/school/library/index.dart';
import 'package:sit/school/oa_announce/index.dart';
import 'package:sit/school/student_plan/card.dart';
import 'package:sit/school/yellow_pages/card.dart';
import 'package:sit/school/ywb/index.dart';
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
    final userType = ref.watch(CredentialsInit.storage.$oaUserType);
    final loginStatus = ref.watch(CredentialsInit.storage.$oaLoginStatus);
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
              if (loginStatus != LoginStatus.never) ...[
                if (userType?.capability.enableClass2nd == true) const Class2ndAppCard().sliver(),
                if (userType?.capability.enableExamArrange == true) const ExamArrangeAppCard().sliver(),
                if (userType?.capability.enableExamResult == true)
                  if (userType == OaUserType.undergraduate)
                    const ExamResultUgAppCard().sliver()
                  else if (userType == OaUserType.postgraduate)
                    const ExamResultPgAppCard().sliver(),
                if (userType == OaUserType.undergraduate) const StudentPlanAppCard().sliver(),
                const OaAnnounceAppCard().sliver(),
                const YwbAppCard().sliver(),
              ],
              const LibraryAppCard().sliver(),
              const YellowPagesAppCard().sliver(),
            ],
          ),
        ),
      ),
    );
  }
}
