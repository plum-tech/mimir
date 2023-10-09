import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/widgets/fab.dart';
import 'package:mimir/utils/url_launcher.dart';
import 'package:mimir/widgets/html.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/details.dart';
import '../init.dart';
import '../entity/list.dart';
import '../i18n.dart';
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
  Class2ndActivityDetails? details;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Class2ndInit.activityDetailService.getActivityDetail(activity.id).then((value) {
      setState(() {
        details = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final details = this.details;
    return Scaffold(
      body: SelectionArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              floating: true,
              title: i18n.details.text(),
              actions: [
                IconButton(
                  icon: const Icon(Icons.open_in_browser),
                  onPressed: () {
                    launchUrlInBrowser(_getActivityUrl(activity.id));
                  },
                )
              ],
              bottom: details == null
                  ? const PreferredSize(
                      preferredSize: Size.fromHeight(4),
                      child: LinearProgressIndicator(),
                    )
                  : null,
            ),
            SliverToBoxAdapter(child: ActivityDetailsCard(activity: activity, details: details).hero(activity.id)),
            if (details != null)
              if (details.description == null)
                SliverToBoxAdapter(child: i18n.detailEmptyTip.text(style: context.textTheme.titleLarge))
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  sliver: StyledHtmlWidget(details.description ?? "", renderMode: RenderMode.sliverList),
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

  Future<void> _sendRequest(BuildContext context, bool force) async {
    try {
      final response = await Class2ndInit.attendActivityService.join(activity.id, force);
      if (!mounted) return;
      context.showSnackBar(Text(response));
    } catch (e) {
      context.showSnackBar(Text('错误: ${e.runtimeType}'), duration: const Duration(seconds: 3));
      rethrow;
    }
  }
}
