import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/widgets/list_tile.dart';
import 'package:sit/design/widgets/tags.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/widgets/html.dart';
import 'package:rettulf/rettulf.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../entity/details.dart';
import '../init.dart';
import '../i18n.dart';
import '../utils.dart';

String _getActivityUrl(int activityId) {
  return 'http://sc.sit.edu.cn/public/activity/activityDetail.action?activityId=$activityId';
}

class Class2ndActivityDetailsPage extends StatefulWidget {
  final int activityId;
  final String? title;
  final DateTime? time;
  final bool enableApply;

  const Class2ndActivityDetailsPage({
    super.key,
    required this.activityId,
    this.title,
    this.time,
    this.enableApply = false,
  });

  @override
  State<StatefulWidget> createState() => _Class2ndActivityDetailsPageState();
}

class _Class2ndActivityDetailsPageState extends State<Class2ndActivityDetailsPage> {
  int get activityId => widget.activityId;
  late Class2ndActivityDetails? details = Class2ndInit.activityStorage.getActivityDetails(activityId);
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    if (details != null) return;
    setState(() {
      isFetching = true;
    });
    final data = await Class2ndInit.activityService.getActivityDetails(activityId);
    await Class2ndInit.activityStorage.setActivityDetails(activityId, data);
    setState(() {
      details = data;
      isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  floating: true,
                  title: i18n.info.activityOf(activityId).text(),
                  actions: [
                    if (widget.enableApply)
                      PlatformTextButton(
                        child: i18n.apply.btn.text(),
                        onPressed: () async {
                          await showApplyRequest();
                        },
                      ),
                    buildMoreActions(),
                  ],
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(child: i18n.infoTab.text()),
                      Tab(child: i18n.descriptionTab.text()),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              ActivityDetailsInfoTabView(activityTitle: widget.title, activityTime: widget.time, details: details),
              ActivityDetailsDocumentTabView(details: details),
            ],
          ),
        ),
      ),
      bottomNavigationBar: isFetching
          ? const PreferredSize(
              preferredSize: Size.fromHeight(4),
              child: LinearProgressIndicator(),
            )
          : null,
    );
  }

  Widget buildMoreActions() {
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      padding: EdgeInsets.zero,
      itemBuilder: (ctx) => <PopupMenuEntry>[
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.open_in_browser),
            title: "Open in browser".text(),
          ),
          onTap: () async {
            await launchUrlString(
              _getActivityUrl(activityId),
              mode: LaunchMode.externalApplication,
            );
          },
        ),
        if (Settings.isDeveloperMode)
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.send),
              title: "Forcibly apply".text(),
            ),
            onTap: () async {
              await showForciblyApplyRequest();
            },
          ),
      ],
    );
  }

  Future<void> showApplyRequest() async {
    final confirm = await context.showRequest(
      title: i18n.apply.applyRequest,
      desc: i18n.apply.applyRequestDesc,
      yes: i18n.confirm,
      no: i18n.notNow,
      highlight: true,
    );
    if (confirm != true) return;
    try {
      final response = await Class2ndInit.applicationService.join(activityId);
      if (!mounted) return;
      await context.showTip(title: i18n.apply.replyTip, desc: response, ok: i18n.ok);
    } catch (e) {
      if (!mounted) return;
      await context.showTip(
        title: i18n.error,
        desc: e.toString(),
        ok: i18n.ok,
        serious: true,
      );
      rethrow;
    }
  }

  Future<void> showForciblyApplyRequest() async {
    final confirm = await context.showRequest(
      title: "Forcibly apply",
      desc: "Confirm to apply this activity forcibly?",
      yes: i18n.confirm,
      no: i18n.notNow,
      highlight: true,
      serious: true,
    );
    if (confirm != true) return;
    try {
      final response = await Class2ndInit.applicationService.join(activityId, force: true);
      if (!mounted) return;
      await context.showTip(title: i18n.apply.replyTip, desc: response, ok: i18n.ok);
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      await context.showTip(title: i18n.apply.replyTip, desc: error.toString(), ok: i18n.ok);
      rethrow;
    }
  }
}

class ActivityDetailsInfoTabView extends StatefulWidget {
  final String? activityTitle;
  final DateTime? activityTime;
  final Class2ndActivityDetails? details;

  const ActivityDetailsInfoTabView({
    super.key,
    this.activityTitle,
    this.activityTime,
    this.details,
  });

  @override
  State<ActivityDetailsInfoTabView> createState() => _ActivityDetailsInfoTabViewState();
}

class _ActivityDetailsInfoTabViewState extends State<ActivityDetailsInfoTabView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final details = widget.details;
    final (:title, :tags) = separateTagsFromTitle(widget.activityTitle ?? details?.title ?? "");
    final time = details?.startTime ?? widget.activityTime;
    return SelectionArea(
      child: CustomScrollView(
        slivers: [
          SliverList.list(children: [
            DetailListTile(
              title: i18n.info.name,
              subtitle: title,
            ),
            if (time != null)
              DetailListTile(
                title: i18n.info.startTime,
                subtitle: context.formatYmdhmNum(time),
              ),
            if (details != null) ...[
              if (details.place != null)
                DetailListTile(
                  title: i18n.info.location,
                  subtitle: details.place!,
                ),
              if (details.principal != null)
                DetailListTile(
                  title: i18n.info.principal,
                  subtitle: details.principal!,
                ),
              if (details.organizer != null)
                DetailListTile(
                  title: i18n.info.organizer,
                  subtitle: details.organizer!,
                ),
              if (details.undertaker != null)
                DetailListTile(
                  title: i18n.info.undertaker,
                  subtitle: details.undertaker!,
                ),
              if (details.contactInfo != null)
                DetailListTile(
                  title: i18n.info.contactInfo,
                  subtitle: details.contactInfo!,
                ),
              if (tags.isNotEmpty)
                ListTile(
                  isThreeLine: true,
                  title: i18n.info.tags.text(),
                  subtitle: TagsGroup(tags),
                ),
              DetailListTile(
                title: i18n.info.signInTime,
                subtitle: context.formatYmdhmNum(details.signStartTime),
              ),
              DetailListTile(
                title: i18n.info.signOutTime,
                subtitle: context.formatYmdhmNum(details.signEndTime),
              ),
              if (details.duration != null)
                DetailListTile(
                  title: i18n.info.duration,
                  subtitle: details.duration!,
                ),
            ],
          ]),
        ],
      ),
    );
  }
}

class ActivityDetailsDocumentTabView extends StatefulWidget {
  final Class2ndActivityDetails? details;

  const ActivityDetailsDocumentTabView({
    super.key,
    this.details,
  });

  @override
  State<ActivityDetailsDocumentTabView> createState() => _ActivityDetailsDocumentTabViewState();
}

class _ActivityDetailsDocumentTabViewState extends State<ActivityDetailsDocumentTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final description = widget.details?.description;
    return SelectionArea(
      child: CustomScrollView(
        slivers: [
          if (description == null)
            SliverToBoxAdapter(child: i18n.noDetails.text(style: context.textTheme.titleLarge))
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              sliver: RestyledHtmlWidget(description, renderMode: RenderMode.sliverList),
            )
        ],
      ),
    );
  }
}
