import 'package:flutter/material.dart';
import 'package:sit/design/widgets/list_tile.dart';
import 'package:sit/design/widgets/tags.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/school/class2nd/utils.dart';
import 'package:sit/school/oa_announce/widget/article.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/utils/error.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../entity/announce.dart';
import '../init.dart';
import '../i18n.dart';
import '../service/announce.dart';
import '../widget/attachment.dart';

class AnnounceDetailsPage extends StatefulWidget {
  final OaAnnounceRecord record;

  const AnnounceDetailsPage(
    this.record, {
    super.key,
  });

  @override
  State<AnnounceDetailsPage> createState() => _AnnounceDetailsPageState();
}

class _Tab {
  static const length = 2;
  static const info = 0;
  static const content = 1;
}

class _AnnounceDetailsPageState extends State<AnnounceDetailsPage> {
  late OaAnnounceDetails? details = OaAnnounceInit.storage.getAnnounceDetails(widget.record.uuid);
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    if (details != null) return;
    if (!mounted) return;
    setState(() {
      isFetching = true;
    });
    try {
      final catalogId = widget.record.catalogId;
      final uuid = widget.record.uuid;
      final details = await OaAnnounceInit.service.fetchAnnounceDetails(catalogId, uuid);
      OaAnnounceInit.storage.setAnnounceDetails(uuid, details);
      if (!mounted) return;
      setState(() {
        this.details = details;
        isFetching = false;
      });
    } catch (error, stackTrace) {
      handleRequestError(context, error, stackTrace);
      if (!mounted) return;
      setState(() {
        isFetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = this.details;
    final record = widget.record;
    return Scaffold(
      body: DefaultTabController(
        length: _Tab.length,
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  floating: true,
                  title: i18n.title.text(),
                  actions: [
                    IconButton(
                      onPressed: () {
                        launchUrlString(
                          OaAnnounceService.getAnnounceUrl(widget.record.catalogId, widget.record.uuid),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      icon: const Icon(Icons.open_in_browser),
                    ),
                  ],
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(child: i18n.infoTab.text()),
                      Tab(child: i18n.contentTab.text()),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              OaAnnounceDetailsInfoTabView(record: record, details: details),
              OaAnnounceDetailsContentTabView(details: details),
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
}

class OaAnnounceDetailsInfoTabView extends StatefulWidget {
  final OaAnnounceRecord record;
  final OaAnnounceDetails? details;

  const OaAnnounceDetailsInfoTabView({
    super.key,
    required this.record,
    this.details,
  });

  @override
  State<OaAnnounceDetailsInfoTabView> createState() => _OaAnnounceDetailsInfoTabViewState();
}

class _OaAnnounceDetailsInfoTabViewState extends State<OaAnnounceDetailsInfoTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final details = widget.details;
    final record = widget.record;
    final (:title, :tags) = separateTagsFromTitle(record.title);
    return SelectionArea(
      child: CustomScrollView(
        slivers: [
          SliverList.list(children: [
            DetailListTile(
              title: i18n.info.title,
              subtitle: title,
            ),
            if (details != null)
              DetailListTile(
                title: i18n.info.author,
                subtitle: details.author,
              ),
            DetailListTile(
              title: i18n.info.publishTime,
              subtitle: context.formatYmdText(record.dateTime),
            ),
            DetailListTile(
              title: i18n.info.department,
              subtitle: record.departments.join(", "),
            ),
            if (tags.isNotEmpty)
              ListTile(
                isThreeLine: true,
                title: i18n.info.tags.text(),
                subtitle: TagsGroup(tags),
              )
          ]),
          if (details != null && details.attachments.isNotEmpty)
            SliverList.list(children: [
              const Divider(),
              ListTile(
                leading: const Icon(Icons.attach_file),
                title: i18n.info.attachmentHeader(details.attachments.length).text(),
              )
            ]),
          if (details != null)
            SliverList.builder(
              itemCount: details.attachments.length,
              itemBuilder: (ctx, i) => AttachmentLinkTile(
                details.attachments[i],
                uuid: record.uuid,
              ),
            ),
        ],
      ),
    );
  }
}

class OaAnnounceDetailsContentTabView extends StatefulWidget {
  final OaAnnounceDetails? details;

  const OaAnnounceDetailsContentTabView({
    super.key,
    this.details,
  });

  @override
  State<OaAnnounceDetailsContentTabView> createState() => _OaAnnounceDetailsContentTabViewState();
}

class _OaAnnounceDetailsContentTabViewState extends State<OaAnnounceDetailsContentTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final details = widget.details;
    return SelectionArea(
      child: CustomScrollView(
        slivers: [
          if (details != null)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              sliver: AnnounceArticle(details),
            )
        ],
      ),
    );
  }
}
