import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/credentials/widgets/oa_scope.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/animation/progress.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/list_tile.dart';
import 'package:sit/design/widgets/tags.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/school/class2nd/entity/activity.dart';
import 'package:sit/school/class2nd/utils.dart';
import 'package:sit/utils/error.dart';

import '../entity/attended.dart';
import '../init.dart';
import '../widgets/summary.dart';
import '../i18n.dart';

class AttendedActivityPage extends StatefulWidget {
  const AttendedActivityPage({super.key});

  @override
  State<AttendedActivityPage> createState() => _AttendedActivityPageState();
}

class _AttendedActivityPageState extends State<AttendedActivityPage> {
  List<Class2ndAttendedActivity>? attended = () {
    final applications = Class2ndInit.pointStorage.applicationList;
    final scores = Class2ndInit.pointStorage.pointItemList;
    if (applications == null || scores == null) return null;
    return buildAttendedActivityList(
      applications: applications,
      scores: scores,
    );
  }();
  late bool isFetching = false;
  final $loadingProgress = ValueNotifier(0.0);
  Class2ndActivityCat? selectedCat;
  Class2ndPointType? selectedScoreType;

  @override
  void initState() {
    super.initState();
    refresh(active: false);
  }

  @override
  void dispose() {
    $loadingProgress.dispose();
    super.dispose();
  }

  Future<void> refresh({required bool active}) async {
    if (!mounted) return;
    setState(() => isFetching = true);
    try {
      $loadingProgress.value = 0;
      final applicationList = await Class2ndInit.pointService.fetchActivityApplicationList();
      $loadingProgress.value = 0.5;
      final scoreItemList = await Class2ndInit.pointService.fetchScoreItemList();
      $loadingProgress.value = 1.0;
      Class2ndInit.pointStorage.applicationList = applicationList;
      Class2ndInit.pointStorage.pointItemList = scoreItemList;

      if (!mounted) return;
      setState(() {
        attended = buildAttendedActivityList(applications: applicationList, scores: scoreItemList);
        isFetching = false;
      });
      $loadingProgress.value = 0;
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
      if (!mounted) return;
      setState(() => isFetching = false);
      $loadingProgress.value = 0;
    }
  }

  Class2ndPointsSummary getTargetScore() {
    final admissionYear = int.tryParse(context.auth.credentials?.account.substring(0, 2) ?? "") ?? 2000;
    return getTargetScoreOf(admissionYear: admissionYear);
  }

  @override
  Widget build(BuildContext context) {
    final attended = this.attended;
    final filteredActivities = attended
        ?.where((activity) => selectedCat == null || activity.category == selectedCat)
        .where((activity) => selectedScoreType == null || activity.scoreType == selectedScoreType)
        .toList();
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                floating: true,
                title: i18n.attended.title.text(),
                bottom: isFetching
                    ? PreferredSize(
                        preferredSize: const Size.fromHeight(4),
                        child: $loadingProgress >> (ctx, value) => AnimatedProgressBar(value: value),
                      )
                    : null,
                forceElevated: innerBoxIsScrolled,
              ),
            ),
          ];
        },
        body: RefreshIndicator.adaptive(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () async {
            await HapticFeedback.heavyImpact();
            await refresh(active: true);
          },
          child: CustomScrollView(
            slivers: [
              SliverList.list(children: [
                ListTile(
                  title: i18n.info.category.text(),
                ),
                buildActivityCatChoices(),
                ListTile(
                  title: i18n.info.scoreType.text(),
                ),
                buildScoreTypeChoices(),
              ]),
              const SliverToBoxAdapter(
                child: Divider(),
              ),
              if (filteredActivities != null)
                if (filteredActivities.isEmpty)
                  SliverFillRemaining(
                    child: LeavingBlank(
                      icon: Icons.inbox_outlined,
                      desc: i18n.noAttendedActivities,
                    ),
                  )
                else
                  SliverList.builder(
                    itemCount: filteredActivities.length,
                    itemBuilder: (ctx, i) {
                      final activity = filteredActivities[i];
                      return AttendedActivityCard(activity);
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildActivityCatChoices() {
    return ListView(
      scrollDirection: Axis.horizontal,
      physics: const RangeMaintainingScrollPhysics(),
      children: [
        ChoiceChip(
          label: Class2ndActivityCat.allCatL10n().text(),
          selected: selectedCat == null,
          onSelected: (value) {
            setState(() {
              selectedCat = null;
            });
          },
        ).padH(4),
        ...(attended ?? const []).map((activity) => activity.category).toSet().map(
              (cat) => ChoiceChip(
                label: cat.l10nName().text(),
                selected: selectedCat == cat,
                onSelected: (value) {
                  setState(() {
                    selectedCat = cat;
                    selectedScoreType = null;
                  });
                },
              ).padH(4),
            ),
      ],
    ).sized(h: 40);
  }

  Widget buildScoreTypeChoices() {
    return ListView(
      scrollDirection: Axis.horizontal,
      physics: const RangeMaintainingScrollPhysics(),
      children: [
        ChoiceChip(
          label: Class2ndPointType.allCatL10n().text(),
          selected: selectedScoreType == null,
          onSelected: (value) {
            setState(() {
              selectedScoreType = null;
            });
          },
        ).padH(4),
        ...(attended ?? const []).map((activity) => activity.category.pointType).whereNotNull().toSet().map(
              (scoreType) => ChoiceChip(
                label: scoreType.l10nFullName().text(),
                selected: selectedScoreType == scoreType,
                onSelected: (value) {
                  setState(() {
                    selectedScoreType = scoreType;
                    selectedCat = null;
                  });
                },
              ).padH(4),
            ),
      ],
    ).sized(h: 40);
  }
}

class AttendedActivityCard extends StatelessWidget {
  final Class2ndAttendedActivity attended;

  const AttendedActivityCard(this.attended, {super.key});

  @override
  Widget build(BuildContext context) {
    final (:title, :tags) = separateTagsFromTitle(attended.title);
    final points = attended.calcTotalPoints();
    return FilledCard(
      clip: Clip.hardEdge,
      child: ListTile(
          isThreeLine: true,
          title: title.text(),
          subtitleTextStyle: context.textTheme.bodyMedium,
          subtitle: [
            "${attended.category.l10nName()} #${attended.application.applicationId}".text(),
            context.formatYmdhmsNum(attended.application.time).text(),
            if (tags.isNotEmpty) TagsGroup(tags),
          ].column(caa: CrossAxisAlignment.start),
          trailing: points != null && points != 0
              ? Text(
                  _pointsText(points),
                  style: context.textTheme.titleMedium?.copyWith(color: _pointsColor(context, points)),
                )
              : Text(
                  attended.application.status,
                  style: context.textTheme.titleMedium
                      ?.copyWith(color: attended.application.isPassed ? Colors.green : null),
                ),
          onTap: () async {
            await context.push("/class2nd/attended-details", extra: attended);
          }),
    );
  }
}

class Class2ndAttendDetailsPage extends StatefulWidget {
  final Class2ndAttendedActivity activity;

  const Class2ndAttendDetailsPage(
    this.activity, {
    super.key,
  });

  @override
  State<Class2ndAttendDetailsPage> createState() => _Class2ndAttendDetailsPageState();
}

class _Class2ndAttendDetailsPageState extends State<Class2ndAttendDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final activity = widget.activity;
    final (:title, :tags) = separateTagsFromTitle(activity.title);
    final scores = activity.scores;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: i18n.info.applicationOf(activity.application.applicationId).text(),
          ),
          SliverList.list(children: [
            DetailListTile(
              title: i18n.info.name,
              subtitle: title,
            ),
            DetailListTile(
              title: i18n.info.category,
              subtitle: activity.category.l10nName(),
            ),
            DetailListTile(
              title: i18n.info.applicationTime,
              subtitle: context.formatYmdhmNum(activity.application.time),
            ),
            DetailListTile(
              title: i18n.info.status,
              subtitle: activity.application.status,
            ),
            if (tags.isNotEmpty)
              ListTile(
                isThreeLine: true,
                title: i18n.info.tags.text(),
                subtitle: TagsGroup(tags),
                visualDensity: VisualDensity.compact,
              ),
            if (!activity.cancelled)
              ListTile(
                title: i18n.viewDetails.text(),
                subtitle: i18n.info.activityOf(activity.activityId).text(),
                trailing: const Icon(Icons.open_in_new),
                onTap: () async {
                  await context.push(
                    "/class2nd/activity-details/${activity.activityId}?title=${activity.title}",
                  );
                },
              ),
          ]),
          if (scores.isNotEmpty)
            const SliverToBoxAdapter(
              child: Divider(),
            ),
          SliverList.builder(
            itemCount: scores.length,
            itemBuilder: (ctx, i) {
              return Class2ndScoreTile(scores[i]);
            },
          ),
        ],
      ),
    );
  }
}

class Class2ndScoreTile extends StatelessWidget {
  final Class2ndPointItem score;

  const Class2ndScoreTile(
    this.score, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final time = score.time;
    final subtitle = time == null ? null : context.formatYmdhmNum(time).text();
    final scoreType = score.pointType;
    if (score.points != 0 && score.honestyPoints != 0) {
      return ListTile(
        title: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: scoreType != null
                  ? "${scoreType.l10nFullName()} ${_pointsText(score.points)}"
                  : _pointsText(score.points),
              style: context.textTheme.bodyLarge?.copyWith(color: _pointsColor(context, score.points)),
            ),
            const TextSpan(text: "\n"),
            TextSpan(
              text: "${i18n.info.honestyPoints} ${_pointsText(score.honestyPoints)}",
              style: context.textTheme.bodyLarge?.copyWith(color: _pointsColor(context, score.honestyPoints)),
            ),
          ]),
        ),
        subtitle: subtitle,
      );
    } else if (score.points != 0) {
      return ListTile(
        titleTextStyle: context.textTheme.bodyLarge?.copyWith(color: _pointsColor(context, score.points)),
        title:
            (scoreType != null ? "${scoreType.l10nFullName()} ${_pointsText(score.points)}" : _pointsText(score.points))
                .text(),
        subtitle: subtitle,
      );
    } else if (score.honestyPoints != 0) {
      return ListTile(
        titleTextStyle: context.textTheme.bodyLarge?.copyWith(color: _pointsColor(context, score.honestyPoints)),
        title: "${i18n.info.honestyPoints} ${_pointsText(score.honestyPoints)}".text(),
        subtitle: subtitle,
      );
    } else {
      return ListTile(
        title: "+0".text(),
        subtitle: subtitle,
      );
    }
  }
}

String _pointsText(double points) {
  if (points > 0) {
    return "+${points.toStringAsFixed(2)}";
  } else if (points == 0) {
    return "+0";
  } else {
    return points.toStringAsFixed(2);
  }
}

Color? _pointsColor(BuildContext ctx, double points) {
  if (points > 0) {
    return Colors.green;
  } else if (points == 0) {
    return null;
  } else {
    return ctx.$red$;
  }
}
