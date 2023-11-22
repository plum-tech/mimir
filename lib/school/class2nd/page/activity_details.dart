import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/widgets/fab.dart';
import 'package:sit/widgets/html.dart';
import 'package:rettulf/rettulf.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../entity/details.dart';
import '../init.dart';
import '../entity/list.dart';
import '../i18n.dart';
import '../utils.dart';
import '../widgets/details.dart';

String _getActivityUrl(int activityId) {
  return 'http://sc.sit.edu.cn/public/activity/activityDetail.action?activityId=$activityId';
}

class Class2ndActivityDetailsPage extends StatefulWidget {
  final Class2ndActivity activity;
  final bool enableApply;

  const Class2ndActivityDetailsPage(
    this.activity, {
    super.key,
    this.enableApply = false,
  });

  @override
  State<StatefulWidget> createState() => _Class2ndActivityDetailsPageState();
}

class _Class2ndActivityDetailsPageState extends State<Class2ndActivityDetailsPage> {
  Class2ndActivity get activity => widget.activity;
  late Class2ndActivityDetails? details = Class2ndInit.activityDetailsStorage.getActivityDetail(activity.id);
  final scrollController = ScrollController();
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
    final data = await Class2ndInit.activityDetailsService.getActivityDetails(activity.id);
    setState(() {
      details = data;
      isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final details = this.details;
    final (:title, :tags) = separateTagsFromTitle(activity.title);
    return Scaffold(
      body: SelectionArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              floating: true,
              title: i18n.info.activityOf(activity.id).text(),
              actions: [
                IconButton(
                  icon: const Icon(Icons.open_in_browser),
                  onPressed: () {
                    launchUrlString(
                      _getActivityUrl(activity.id),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                )
              ],
              bottom: isFetching
                  ? const PreferredSize(
                      preferredSize: Size.fromHeight(4),
                      child: LinearProgressIndicator(),
                    )
                  : null,
            ),
            SliverToBoxAdapter(
              child: ActivityDetailsCard(activity: activity, details: details).hero(activity.id),
            ),
            if (details != null)
              if (details.description == null)
                SliverToBoxAdapter(child: i18n.noDetails.text(style: context.textTheme.titleLarge))
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  sliver: RestyledHtmlWidget(details.description ?? "", renderMode: RenderMode.sliverList),
                ),
          ],
        ),
      ),
      floatingActionButton: widget.enableApply
          ? AutoHideFAB.extended(
              controller: scrollController,
              icon: const Icon(Icons.person_add),
              label: i18n.apply.btn.text(),
              onPressed: () async {
                await showApplyRequest();
              },
            )
          : null,
    );
  }

  Future<void> showApplyRequest() async {
    final confirm = await context.showRequest(
        title: i18n.apply.applyRequest,
        desc: i18n.apply.applyRequestDesc,
        yes: i18n.confirm,
        no: i18n.notNow,
        highlight: true);
    if (confirm == true) {
      try {
        final response = await Class2ndInit.attendActivityService.join(activity.id);
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
  }

  Future<void> sendForceRequest(BuildContext context) async {
    try {
      final response = await Class2ndInit.attendActivityService.join(activity.id, force: true);
      if (!mounted) return;
      context.showSnackBar(content: Text(response));
    } catch (e) {
      context.showSnackBar(content: Text('错误: ${e.runtimeType}'), duration: const Duration(seconds: 3));
      rethrow;
    }
  }
}
