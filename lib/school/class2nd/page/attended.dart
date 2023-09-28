import 'package:flutter/material.dart';
import 'package:mimir/credential/widgets/oa_scope.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/score.dart';
import '../init.dart';
import '../widgets/attended.dart';
import '../widgets/summary.dart';
import '../i18n.dart';

class AttendedActivityPage extends StatefulWidget {
  const AttendedActivityPage({super.key});

  @override
  State<AttendedActivityPage> createState() => _AttendedActivityPageState();
}

class _AttendedActivityPageState extends State<AttendedActivityPage> {
  List<Class2ndAttendedActivity>? attended = Class2ndInit.scoreStorage.attendedList;
  final _scrollController = ScrollController();
  final $attended = Class2ndInit.scoreStorage.listenAttendedList();

  @override
  void initState() {
    super.initState();
    refresh();
    $attended.addListener(onAttendedChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    $attended.removeListener(onAttendedChanged);
    super.dispose();
  }

  void onAttendedChanged() {
    setState(() {
      attended = Class2ndInit.scoreStorage.attendedList;
    });
  }

  Future<void> refresh() async {
    final applicationList = await Class2ndInit.scoreService.fetchActivityApplicationList();
    final scoreItemList = await Class2ndInit.scoreService.fetchScoreItemList();
    final attended = applicationList.map((application) {
      // 对于每一次申请, 找到对应的加分信息
      final relatedScoreItems = scoreItemList.where((e) => e.activityId == application.activityId).toList();
      // TODO: 潜在的 BUG，可能导致得分页面出现重复项。
      return Class2ndAttendedActivity(
        applyId: application.applyId,
        activityId: application.activityId,
        // because the application.title might have trailing ellipsis
        title: relatedScoreItems.firstOrNull?.name ?? application.title,
        time: application.time,
        status: application.status,
        points: relatedScoreItems.fold<double>(0.0, (points, item) => points + item.points),
        honestyPoints: relatedScoreItems.fold<double>(0.0, (points, item) => points + item.honestyPoints),
      );
    }).toList();
    Class2ndInit.scoreStorage.attendedList = attended;
  }

  Class2ndScoreSummary getTargetScore() {
    final admissionYear = int.tryParse(context.auth.credentials?.account.substring(0, 2) ?? "") ?? 2000;
    return getTargetScoreOf(admissionYear: admissionYear);
  }

  @override
  Widget build(BuildContext context) {
    final activities = attended;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: i18n.attended.title.text(),
            bottom: activities != null
                ? null
                : const PreferredSize(
                    preferredSize: Size.fromHeight(4),
                    child: LinearProgressIndicator(),
                  ),
          ),
          if (activities != null)
            if (activities.isEmpty)
              SliverToBoxAdapter(
                child: LeavingBlank(
                  icon: Icons.inbox_outlined,
                  desc: i18n.noAttendedActivities,
                ),
              )
            else
              SliverList.builder(
                itemCount: activities.length,
                itemBuilder: (ctx, i) {
                  final activity = activities[i];
                  return AttendedActivityCard(activity).inCard().hero(activity.applyId);
                },
              ),
        ],
      ),
    );
  }
}
