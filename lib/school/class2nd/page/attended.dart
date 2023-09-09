import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mimir/credential/symbol.dart';
import 'package:mimir/design/colors.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/list.dart';
import '../entity/score.dart';
import '../init.dart';
import '../widgets/summary.dart';
import '../utils.dart';
import 'detail.dart';
import "../i18n.dart";

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

  ScScoreSummary getTargetScore() {
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
            return AttendedActivityTile(rawActivity)
                .inCard()
                .hero(rawActivity.applyId)
                .padSymmetric(h: 8);
          },
        ),
      );
    }
  }
}

class AttendedActivityTile extends StatelessWidget {
  final ScJoinedActivity rawActivity;

  const AttendedActivityTile(this.rawActivity, {super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = context.textTheme.titleMedium;
    final subtitleStyle = context.textTheme.bodySmall;

    final color = rawActivity.isPassed ? Colors.green : context.themeColor;
    final trailingStyle = context.textTheme.titleLarge?.copyWith(color: color);
    final activity = ActivityParser.parse(rawActivity);

    return ListTile(
      isThreeLine: true,
      title: Text(activity.realTitle, style: titleStyle),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${i18n.application.time}: ${context.formatYmdhmsNum(rawActivity.time)}', style: subtitleStyle),
          Text('${i18n.application.id}: ${rawActivity.applyId}', style: subtitleStyle),
        ],
      ),
      trailing: Text(rawActivity.amount.abs() > 0.01 ? rawActivity.amount.toStringAsFixed(2) : rawActivity.status,
          style: trailingStyle),
      onTap: rawActivity.activityId != -1
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => DetailPage(activity, hero: rawActivity.applyId, enableApply: false)),
              );
            }
          : null,
    );
  }
}
