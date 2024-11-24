import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/adaptive/menu.dart';
import 'package:mimir/design/widget/list_tile.dart';
import 'package:mimir/design/widget/tags.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/school/class2nd/service/application.dart';
import 'package:mimir/utils/error.dart';
import 'package:mimir/utils/tel.dart';
import 'package:mimir/widget/html.dart';
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
  bool fetching = false;
  var showMore = false;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    if (details != null) return;
    setState(() {
      fetching = true;
    });
    final data = await Class2ndInit.activityService.getActivityDetails(activityId);
    await Class2ndInit.activityStorage.setActivityDetails(activityId, data);
    setState(() {
      details = data;
      fetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final details = this.details;
    final description = details?.description;
    return Scaffold(
      body: SelectionArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
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
            ),
            buildInfo(),
            if (!showMore)
              ListTile(
                title: "Show more".text(textAlign: TextAlign.end),
                trailing: const Icon(Icons.expand_more),
                onTap: () {
                  setState(() {
                    showMore = true;
                  });
                },
              ).sliver(),
            if (description != null && description.isNotEmpty) ...[
              const Divider().sliver(),
              buildDesc(description),
            ],
          ],
        ),
      ),
      floatingActionButton: !fetching ? null : const CircularProgressIndicator.adaptive(),
    );
  }

  Widget buildInfo() {
    final details = this.details;
    final (:title, :tags) = separateTagsFromTitle(widget.title ?? details?.title ?? "");
    final time = details?.startTime ?? widget.time;
    return SliverList.list(children: [
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
        if (tags.isNotEmpty)
          ListTile(
            isThreeLine: true,
            title: i18n.info.tags.text(),
            subtitle: TagsGroup(tags),
          ),
        if (showMore) ...[
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
            () {
              final contact = details.contactInfo!;
              final phoneNumber = tryParsePhoneNumber(contact);
              return DetailListTile(
                title: i18n.info.contactInfo,
                subtitle: contact,
                trailing: phoneNumber == null
                    ? null
                    : PlatformIconButton(
                        icon: const Icon(Icons.call),
                        onPressed: () async {
                          await launchUrlString("tel:$phoneNumber", mode: LaunchMode.externalApplication);
                        },
                      ),
              );
            }(),
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
      ],
    ]);
  }

  Widget buildDesc(String description) {
    return SliverPadding(
      padding: const EdgeInsets.all(8),
      sliver: RestyledHtmlWidget(
        description,
        renderMode: RenderMode.sliverList,
      ),
    );
  }

  Widget buildMoreActions() {
    return PullDownMenuButton(
      itemBuilder: (ctx) => [
        PullDownItem(
          icon: Icons.open_in_browser,
          title: i18n.openInBrowser,
          onTap: () async {
            await launchUrlString(
              _getActivityUrl(activityId),
              mode: LaunchMode.externalApplication,
            );
          },
        ),
      ],
    );
  }

  Future<void> showApplyRequest() async {
    final confirm = await context.showActionRequest(
      action: i18n.apply.applyRequest,
      desc: i18n.apply.applyRequestDesc,
      cancel: i18n.cancel,
      destructive: true,
    );
    if (confirm != true) return;
    try {
      final checkRes = await Class2ndInit.applicationService.check(activityId);
      if (checkRes != Class2ndApplicationCheckResponse.successfulCheck) {
        if (!mounted) return;
        await context.showTip(title: i18n.apply.replyTip, desc: checkRes.l10n(), primary: i18n.ok);
        return;
      }
      final applySuccess = await Class2ndInit.applicationService.apply(activityId);
      if (!mounted) return;
      await context.showTip(
        title: i18n.apply.replyTip,
        desc: applySuccess ? i18n.apply.applySuccessTip : i18n.apply.applyFailureTip,
        primary: i18n.ok,
      );
    } catch (error, stackTrace) {
      handleRequestError(error, stackTrace);
    }
  }

  Future<void> showForciblyApplyRequest() async {
    final confirm = await context.showActionRequest(
      action: "Forcibly apply",
      desc: "Confirm to apply this activity forcibly?",
      cancel: i18n.cancel,
      destructive: true,
    );
    if (confirm != true) return;
    try {
      final applySuccess = await Class2ndInit.applicationService.apply(activityId);
      if (!mounted) return;
      await context.showTip(
        title: i18n.apply.replyTip,
        desc: applySuccess ? "Yes" : "No",
        primary: i18n.ok,
      );
    } catch (error, stackTrace) {
      handleRequestError(error, stackTrace);
    }
  }
}
