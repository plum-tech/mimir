import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart' hide isCupertino;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/design/widget/app.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/school/class2nd/widget/summary.dart';
import 'package:mimir/school/event.dart';
import 'package:mimir/school/utils.dart';
import 'package:mimir/utils/async_event.dart';
import 'package:rettulf/rettulf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mimir/utils/error.dart';
import 'package:super_context_menu/super_context_menu.dart';

import 'entity/attended.dart';
import "i18n.dart";
import 'init.dart';
import 'utils.dart';

class Class2ndAppCard extends ConsumerStatefulWidget {
  const Class2ndAppCard({super.key});

  @override
  ConsumerState<Class2ndAppCard> createState() => _Class2ndAppCardState();
}

class _Class2ndAppCardState extends ConsumerState<Class2ndAppCard> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final EventSubscription $refreshEvent;

  @override
  void initState() {
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
    $refreshEvent.cancel();
    super.dispose();
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
      handleRequestError(error, stackTrace);
      if (!mounted) return;
      if (active) {
        context.showSnackBar(content: i18n.refreshFailedTip.text());
      }
    }
  }

  Class2ndPointsSummary getTargetScore() {
    final credentials = ref.watch(CredentialsInit.storage.oa.$credentials);
    final admissionYear = getAdmissionYearFromStudentId(credentials?.account);
    return getTargetScoreOf(admissionYear: admissionYear);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final storage = Class2ndInit.pointStorage;
    final summary = ref.watch(storage.$pointsSummary);
    return AppCard(
      title: i18n.title.text(),
      view: summary == null
          ? const SizedBox.shrink()
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
        FilledButton.tonal(
          onPressed: () async {
            await context.push("/class2nd/attended");
          },
          child: i18n.attendedAction.text(),
        )
      ],
      rightActions: [
        if (!supportContextMenu)
          PlatformIconButton(
            material: (ctx, p) {
              return MaterialIconButtonData(
                tooltip: i18n.share,
              );
            },
            onPressed: summary != null
                ? () async {
                    await shareSummery(summary: summary, target: getTargetScore(), context: context);
                  }
                : null,
            icon: Icon(context.icons.share),
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
    if (!supportContextMenu) return card;
    return Builder(
      builder: (ctx) => ContextMenuWidget(
        menuProvider: (MenuRequest request) {
          return Menu(
            children: [
              MenuAction(
                image: MenuImage.icon(context.icons.share),
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
