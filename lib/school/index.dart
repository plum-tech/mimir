import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/credentials/entity/user_type.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/school/class2nd/index.dart';
import 'package:mimir/school/electricity/card.dart';
import 'package:mimir/school/event.dart';
import 'package:mimir/school/exam_arrange/card.dart';
import 'package:mimir/school/exam_result/card.pg.dart';
import 'package:mimir/school/exam_result/card.ug.dart';
import 'package:mimir/school/expense_records/card.dart';
import 'package:mimir/school/oa_announce/index.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                floating: true,
                snap: true,
                title: i18n.navigation.text(),
                forceElevated: innerBoxIsScrolled,
                actions: [
                  PlatformIconButton(
                    icon: Icon(context.icons.settings),
                    onPressed: () async {
                      await context.push("/settings");
                    },
                  )
                ],
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
                const Class2ndAppCard(),
                const ExpenseRecordsAppCard(),
                const ElectricityBalanceAppCard(),
                const ExamArrangeAppCard(),
                if (ref.watch(CredentialsInit.storage.oa.$userType) == OaUserType.undergraduate)
                  const ExamResultUgAppCard(),
                if (ref.watch(CredentialsInit.storage.oa.$userType) == OaUserType.postgraduate)
                  const ExamResultPgAppCard(),
                const OaAnnounceAppCard(),
                const YwbAppCard(),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
