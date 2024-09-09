import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/credentials/entity/login_status.dart';
import 'package:mimir/credentials/entity/user_type.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/school/class2nd/index.dart';
import 'package:mimir/school/event.dart';
import 'package:mimir/school/exam_arrange/index.dart';
import 'package:mimir/school/exam_result/index.pg.dart';
import 'package:mimir/school/exam_result/index.ug.dart';
import 'package:mimir/school/library/index.dart';
import 'package:mimir/school/oa_announce/index.dart';
import 'package:mimir/school/student_plan/card.dart';
import 'package:mimir/school/yellow_pages/card.dart';
import 'package:mimir/school/ywb/index.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/settings/dev.dart';
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
              if (loginStatus != OaLoginStatus.never && userType != null) ...[
                if (userType.has(UserCapability.class2nd) == true) const Class2ndAppCard().sliver(),
                if (userType.has(UserCapability.examArrange) == true) const ExamArrangeAppCard().sliver(),
                if (userType.has(UserCapability.examResult) == true)
                  if (userType == OaUserType.undergraduate)
                    const ExamResultUgAppCard().sliver()
                  else if (userType == OaUserType.postgraduate)
                    const ExamResultPgAppCard().sliver(),
                if (kDebugMode && userType == OaUserType.undergraduate && ref.watch(Dev.$on))
                  const StudentPlanAppCard().sliver(),
                const OaAnnounceAppCard().sliver(),
                if (userType.has(UserCapability.ywb) == true) const YwbAppCard().sliver(),
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
