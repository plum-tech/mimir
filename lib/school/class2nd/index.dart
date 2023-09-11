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
  Class2ndScoreSummary? summary;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() {
    // TODO: Error when school server unavailable or credentials are empty.
    Class2ndInit.scoreService.getScoreSummary().then((value) {
      if (summary != value) {
        summary = value;
        if (!mounted) return;
        setState(() {});
      }
    });
  }

  Class2ndScoreSummary getTargetScore() {
    final admissionYear = int.tryParse(context.auth.credentials?.account.substring(0, 2) ?? "") ?? 2000;
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
            refresh();
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}
