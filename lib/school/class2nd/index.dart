import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/credential/widgets/oa_scope.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/app.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/school/class2nd/widgets/summary.dart';
import 'package:sit/school/event.dart';
import 'package:sit/utils/async_event.dart';
import 'package:rettulf/rettulf.dart';
import 'package:share_plus/share_plus.dart';

import 'entity/attended.dart';
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
  late final EventSubscription $refreshEvent;

  @override
  void initState() {
    $scoreSummary.addListener(onSummaryChanged);
    $refreshEvent = schoolEventBus.addListener(() async {
      await refresh(active: true);
    });
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
    $refreshEvent.cancel();
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
        context.showSnackBar(i18n.refreshSuccessTip.text());
      }
    } catch (error) {
      if (active) {
        if (!mounted) return;
        context.showSnackBar(i18n.refreshFailedTip.text());
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
        if (!isCupertino)
          IconButton(
            onPressed: summary != null
                ? () async {
                    await shareSummery(summary: summary, target: getTargetScore(), context: context);
                  }
                : null,
            icon: const Icon(Icons.share_outlined),
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
    return Builder(
      builder: (ctx) => CupertinoContextMenu.builder(
        enableHapticFeedback: true,
        actions: [
          CupertinoContextMenuAction(
            trailingIcon: CupertinoIcons.share,
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await shareSummery(summary: summary, target: target, context: ctx);
            },
            child: i18n.share.text(),
          ),
        ],
        builder: (ctx, animation) => Class2ndScoreSummeryCard(
          targetScore: target,
          summary: summary,
        ).constrained(maxH: 250),
      ),
    );
  }

  Future<void> shareSummery({
    required Class2ndScoreSummary summary,
    required Class2ndScoreSummary target,
    required BuildContext context,
  }) async {
    final name2score = summary.toName2score();
    final name2target = target.toName2score();
    final text = name2score
        .map((e) =>
            "${e.type.l10nFullName()}: ${e.score}/${name2target.firstWhereOrNull((t) => t.type == e.type)?.score}")
        .join(", ");
    await Share.share(
      text,
      sharePositionOrigin: context.getSharePositionOrigin(),
    );
  }
}
