import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/credential/widgets/oa_scope.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/design/widgets/app.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/school/class2nd/widgets/summary.dart';
import 'package:rettulf/rettulf.dart';
import 'package:share_plus/share_plus.dart';

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
  final $scoreSummary = Class2ndInit.scoreStorage.listenScoreSummary();

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
    try {
      final summary = await Class2ndInit.scoreService.fetchScoreSummary();
      Class2ndInit.scoreStorage.scoreSummary = summary;
      if (active) {
        if (!mounted) return;
        context.showSnackBar(i18n.refreshFailedTip.text());
      }
    } catch (error) {
      if (active) {
        if (!mounted) return;
        context.showSnackBar(i18n.refreshSuccessTip.text());
      }
    }
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
          : buildSummeryCard(
        summary: summary,
        target: getTargetScore(),
      ),
      leftActions: [
        FilledButton.icon(
          onPressed: () async {
            await context.push("/class2nd/activity");
          },
          label: i18n.activityAction.text(),
          icon: const Icon(Icons.local_activity),
        ),
        OutlinedButton(
          onPressed: () async {
            await context.push("/class2nd/attended");
          },
          child: i18n.attendedAction.text(),
        )
      ],
      rightActions: [
        if (summary != null && !isCupertino)
          IconButton(
            onPressed: () async {
              await shareSummery(summary: summary, target: getTargetScore());
            },
            icon: const Icon(Icons.share_outlined),
          ),
        IconButton(
          onPressed: () {
            refresh(active: true);
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget buildSummeryCard({
    required Class2ndScoreSummary summary,
    required Class2ndScoreSummary target,
  }) {
    if (!isCupertino) {
      return Class2ndScoreSummeryCard(
        targetScore: target,
        summary: summary,
      ).constrained(maxH: 250);
    }
    return CupertinoContextMenu.builder(
      actions: [
        CupertinoContextMenuAction(
          trailingIcon: CupertinoIcons.share,
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            await shareSummery(summary: summary, target: target);
          },
          child: i18n.share.text(),
        ),
      ],
      builder: (ctx, animation) =>
          Class2ndScoreSummeryCard(
            targetScore: target,
            summary: summary,
          ).constrained(maxH: 250),
    );
  }

  Future<void> shareSummery({
    required Class2ndScoreSummary summary,
    required Class2ndScoreSummary target,
  }) async {
    final name2score = summary.toName2score();
    final name2target = target.toName2score();
    final text = name2score
        .map((e) => "${e.name}: ${e.score}/${name2target
        .firstWhereOrNull((t) => t.name == e.name)
        ?.score}")
        .join(", ");
    await Share.share(
      text,
    );
  }
}
