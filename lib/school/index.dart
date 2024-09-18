import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mimir/feature/feature.dart';
import 'package:mimir/feature/utils.dart';
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
    final cards = [
      if (can(AppFeature.freshman, ref)) const FreshmanAppCard(),
      if (can(AppFeature.secondClass$, ref) == true) const Class2ndAppCard().sized(w: 400),
      if (can(AppFeature.examArrangement, ref) == true) const ExamArrangeAppCard().sized(w: 200),
      if (can(AppFeature.examResultUg, ref) == true) const ExamResultUgAppCard().sized(w: 200),
      if (can(AppFeature.examResultPg, ref) == true) const ExamResultPgAppCard(),
      if (kDebugMode && can(AppFeature.studentPlan, ref)) const StudentPlanAppCard(),
      if (can(AppFeature.oaAnnouncement, ref)) const OaAnnounceAppCard(),
      if (can(AppFeature.ywb, ref)) const YwbAppCard(),
      if (can(AppFeature.library$, ref)) const LibraryAppCard(),
      if (can(AppFeature.yellowPages, ref)) const YellowPagesAppCard(),
    ];
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
          child: GridView.custom(
            gridDelegate: SliverQuiltedGridDelegate(
              crossAxisCount: 2,
              repeatPattern: QuiltedGridRepeatPattern.inverted,
              pattern: [
                QuiltedGridTile(2, 2),
                QuiltedGridTile(1, 1),
                QuiltedGridTile(1, 1),
                QuiltedGridTile(1, 2),
              ],
            ),
            childrenDelegate: SliverChildBuilderDelegate(
              childCount: cards.length,
              (context, index) => cards[index],
            ),
          ),
        ),
      ),
    );
  }
}
