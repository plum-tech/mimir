import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mimir/credential/widgets/oa_scope.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/score.dart';
import '../init.dart';
import '../widgets/attended.dart';
import '../widgets/summary.dart';
import '../utils.dart';

class AttendedActivityPage extends StatefulWidget {
  const AttendedActivityPage({super.key});

  @override
  State<AttendedActivityPage> createState() => _AttendedActivityPageState();
}

class _AttendedActivityPageState extends State<AttendedActivityPage> {
  List<ScJoinedActivity>? joined;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: buildBody(),
    );
  }

  void onRefresh() {
    getMyActivityListJoinScore(Class2ndInit.scoreService).then((value) {
      if (joined != value) {
        joined = value;
        if (!mounted) return;
        setState(() {});
      }
    });
  }

  Class2ndScoreSummary getTargetScore() {
    final admissionYear = int.tryParse(context.auth.credential?.account.substring(0, 2) ?? "") ?? 2000;
    return calcTargetScore(admissionYear);
  }

  Widget buildBody() {
    final activities = joined;
    if (activities == null) {
      return const CircularProgressIndicator();
    } else {
      return ScrollConfiguration(
        behavior: const CupertinoScrollBehavior(),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: activities.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (ctx, index) {
            final rawActivity = activities[index];
            return AttendedActivityTile(rawActivity).inCard().hero(rawActivity.applyId);
          },
        ),
      );
    }
  }
}
