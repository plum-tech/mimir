import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sit/credentials/widgets/oa_scope.dart';
import 'package:sit/design/animation/progress.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/school/class2nd/entity/list.dart';
import 'package:sit/school/class2nd/utils.dart';

import '../entity/attended.dart';
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
  List<Class2ndAttendedActivity>? attended = () {
    final applications = Class2ndInit.scoreStorage.applicationList;
    final scores = Class2ndInit.scoreStorage.scoreItemList;
    if (applications == null || scores == null) return null;
    return buildAttendedActivityList(
      applications: applications,
      scores: scores,
    );
  }();
  final _scrollController = ScrollController();
  late bool isFetching = false;
  final $loadingProgress = ValueNotifier(0.0);
  late var selectedCats = Class2ndActivityCat.values.toSet();

  @override
  void initState() {
    super.initState();
    refresh(active: false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> refresh({required bool active}) async {
    if (!mounted) return;
    setState(() => isFetching = true);
    try {
      $loadingProgress.value = 0;
      final applicationList = await Class2ndInit.scoreService.fetchActivityApplicationList();
      $loadingProgress.value = 0.5;
      final scoreItemList = await Class2ndInit.scoreService.fetchScoreItemList();
      $loadingProgress.value = 1.0;
      Class2ndInit.scoreStorage.applicationList = applicationList;
      Class2ndInit.scoreStorage.scoreItemList = scoreItemList;

      if (!mounted) return;
      setState(() {
        attended = buildAttendedActivityList(applications: applicationList, scores: scoreItemList);
        isFetching = false;
      });
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      setState(() => isFetching = false);
    } finally {
      $loadingProgress.value = 0;
    }
  }

  Class2ndScoreSummary getTargetScore() {
    final admissionYear = int.tryParse(context.auth.credentials?.account.substring(0, 2) ?? "") ?? 2000;
    return getTargetScoreOf(admissionYear: admissionYear);
  }

  @override
  Widget build(BuildContext context) {
    final attended = this.attended ?? const [];
    final filteredActivities = attended.where((activity) => selectedCats.contains(activity.category)).toList();
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
              SliverToBoxAdapter(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      (attended.isEmpty ? Class2ndActivityCat.values : attended.map((activity) => activity.category))
                          .toSet()
                          .map(
                            (cat) => FilterChip(
                              label: cat.l10nName().text(),
                              selected: selectedCats.contains(cat),
                              onSelected: (value) {
                                setState(() {
                                  final newSelection = Set.of(selectedCats);
                                  if (value) {
                                    newSelection.add(cat);
                                  } else {
                                    newSelection.remove(cat);
                                  }
                                  selectedCats = newSelection;
                                });
                              },
                            ).padH(4),
                          )
                          .toList(),
                ).sized(h: 40),
              ),
              const SliverToBoxAdapter(
                child: Divider(),
              ),
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
}
