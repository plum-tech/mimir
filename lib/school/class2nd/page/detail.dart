import 'package:flutter/material.dart';
import 'package:mimir/design/adaptive/adaptive.dart';
import 'package:mimir/design/widgets/button.dart';
import 'package:mimir/design/widgets/dialog.dart';
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

class Class2ndActivityDetailPage extends StatefulWidget {
  final Class2ndActivity activity;
  final bool enableApply;

  const Class2ndActivityDetailPage(
    this.activity, {
    super.key,
    this.enableApply = false,
  });

  @override
  State<StatefulWidget> createState() => _Class2ndActivityDetailPageState();
}

class _Class2ndActivityDetailPageState extends State<Class2ndActivityDetailPage> {
  int get activityId => widget.activity.id;

  Class2ndActivity get activity => widget.activity;
  Class2ndActivityDetails? detail;
  Size? titleBarSize;
  final _fabKey = GlobalKey(debugLabel: "To get size of FAB in Landscape Mode.");

  @override
  void initState() {
    super.initState();
    Class2ndInit.activityDetailService.getActivityDetail(activityId).then((value) {
      setState(() {
        detail = value;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      titleBarSize = _fabKey.currentContext?.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    final details = this.detail;
    return Scaffold(
      appBar: AppBar(
        title: i18n.details.text(),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () {
              launchUrlInBrowser(_getActivityUrl(activityId));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ActivityDetailsCard(activity:activity, details:details),
          if (details != null) _buildArticle(context, details.description) else const CircularProgressIndicator(),
          const SizedBox(height: 64),
        ]),
      ),
      floatingActionButton: widget.enableApply
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.person_add),
              label: i18n.apply.btn.text(),
              onPressed: () async {
                await showApplyRequest();
              },
            )
          : null,
    );
  }

  Widget _buildArticle(BuildContext context, String? html) {
    if (html == null) {
      return i18n.detailEmptyTip.text(style: context.textTheme.titleLarge).center();
    }
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SelectionArea(
        child: StyledHtmlWidget(
          html,
          textStyle: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
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
        final response = await Class2ndInit.attendActivityService.join(activityId);
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
      final response = await Class2ndInit.attendActivityService.join(activityId, force);
      if (!mounted) return;
      context.showSnackBar(Text(response));
    } catch (e) {
      context.showSnackBar(Text('错误: ${e.runtimeType}'), duration: const Duration(seconds: 3));
      rethrow;
    }
  }
}
