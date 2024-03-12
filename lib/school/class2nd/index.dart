import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/credentials/widgets/oa_scope.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/app.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/school/class2nd/widgets/summary.dart';
import 'package:sit/school/event.dart';
import 'package:sit/school/utils.dart';
import 'package:sit/utils/async_event.dart';
import 'package:rettulf/rettulf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sit/utils/error.dart';
import 'package:super_context_menu/super_context_menu.dart';

import 'entity/attended.dart';
import "i18n.dart";
import 'init.dart';
import 'utils.dart';

class Class2ndAppCard extends StatefulWidget {
  const Class2ndAppCard({super.key});

  @override
  State<Class2ndAppCard> createState() => _Class2ndAppCardState();
}

class _Class2ndAppCardState extends State<Class2ndAppCard> {
  var summary = Class2ndInit.pointStorage.pointsSummary;
  final $pointsSummary = Class2ndInit.pointStorage.listenPointsSummary();
  late final EventSubscription $refreshEvent;

  @override
  void initState() {
    $pointsSummary.addListener(onSummaryChanged);
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
    $pointsSummary.removeListener(onSummaryChanged);
    $refreshEvent.cancel();
    super.dispose();
  }

  void onSummaryChanged() {
    setState(() {
      summary = Class2ndInit.pointStorage.pointsSummary;
    });
  }

  Future<void> refresh({required bool active}) async {
    // TODO: Error when school server unavailable.
    try {
      final summary = await Class2ndInit.pointService.fetchScoreSummary();
      Class2ndInit.pointStorage.pointsSummary = summary;
      if (active) {
        if (!mounted) return;
        context.showSnackBar(content: i18n.refreshSuccessTip.text());
      }
    } catch (error, stackTrace) {
      if (!mounted) return;
      handleRequestError(context, error, stackTrace);
      if (active) {
        context.showSnackBar(content: i18n.refreshFailedTip.text());
      }
    }
  }

  Class2ndPointsSummary getTargetScore() {
    final admissionYear = getAdmissionYearFromStudentId(context.auth.credentials?.account);
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
      subtitle: summary == null
          ? null
          : [
              "${i18n.info.honestyPoints}: ${summary.honestyPoints}".text(),
              "${i18n.info.totalPoints}: ${summary.totalPoints}".text(),
            ].column(caa: CrossAxisAlignment.start),
      leftActions: [
        FilledButton.icon(
          onPressed: () async {
            await context.push("/class2nd");
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
            tooltip: i18n.share,
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
    required Class2ndPointsSummary summary,
    required Class2ndPointsSummary target,
  }) {
    final card = Class2ndScoreSummeryCard(
      targetScore: target,
      summary: summary,
    ).constrained(maxH: 250);
    if (!isCupertino) return card;
    return Builder(
      builder: (ctx) => ContextMenuWidget(
        menuProvider: (MenuRequest request) {
          return Menu(
            children: [
              MenuAction(
                image: MenuImage.icon(CupertinoIcons.share),
                title: i18n.share,
                callback: () async {
                  await shareSummery(summary: summary, target: target, context: ctx);
                },
              ),
            ],
          );
        },
        child: card,
      ),
    );
  }

  Future<void> shareSummery({
    required Class2ndPointsSummary summary,
    required Class2ndPointsSummary target,
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
