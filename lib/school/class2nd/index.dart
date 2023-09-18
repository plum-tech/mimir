import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/credential/widgets/oa_scope.dart';
import 'package:mimir/design/widgets/app.dart';
import 'package:mimir/school/class2nd/widgets/summary.dart';
import 'package:rettulf/rettulf.dart';

import 'entity/score.dart';
import "i18n.dart";
import 'init.dart';

class Class2ndAppCard extends StatefulWidget {
  const Class2ndAppCard({super.key});

  @override
  State<Class2ndAppCard> createState() => _Class2ndAppCardState();
}

class _Class2ndAppCardState extends State<Class2ndAppCard> {
  var summary = Class2ndInit.scoreStorage.scoreSummary;
  final $scoreSummary = Class2ndInit.scoreStorage.$scoreSummary;

  @override
  void initState() {
    $scoreSummary.addListener(onSummaryChanged);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refresh(active: false);
  }

  @override
  void dispose() {
    $scoreSummary.removeListener(onSummaryChanged);
    super.dispose();
  }

  void onSummaryChanged() {
    setState(() {
      summary = Class2ndInit.scoreStorage.scoreSummary;
    });
  }

  Future<void> refresh({required bool active}) async {
    // TODO: Error when school server unavailable.
    final summary = await Class2ndInit.scoreService.fetchScoreSummary();
    Class2ndInit.scoreStorage.scoreSummary = summary;
  }

  Class2ndScoreSummary getTargetScore() {
    final admissionYear = int.tryParse(context.auth.credentials?.account.substring(0, 2) ?? "");
    return getTargetScoreOf(admissionYear: admissionYear);
  }

  @override
  Widget build(BuildContext context) {
    final summary = this.summary;
    return AppCard(
      title: i18n.title.text(),
      view: summary == null
          ? const SizedBox()
          : Class2ndScoreSummeryCard(
              targetScore: getTargetScore(),
              summary: summary,
            ).constrained(maxH: 250),
      leftActions: [
        FilledButton.icon(
          onPressed: () async {
            await context.push("/class2nd/activity");
          },
          label: "Activity".text(),
          icon: const Icon(Icons.local_activity_outlined),
        ),
        OutlinedButton(
          onPressed: () async {
            await context.push("/class2nd/attended");
          },
          child: "Attended".text(),
        )
      ],
      rightActions: [
        IconButton(
          onPressed: () {
            refresh(active: true);
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}
