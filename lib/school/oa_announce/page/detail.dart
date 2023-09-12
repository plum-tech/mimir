import 'package:flutter/material.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/school/oa_announce/widget/article.dart';
import 'package:mimir/utils/url_launcher.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/announce.dart';
import '../init.dart';
import '../i18n.dart';
import '../widget/attachment.dart';
import '../widget/card.dart';

class AnnounceDetailsPage extends StatefulWidget {
  final OaAnnounceRecord record;

  const AnnounceDetailsPage(
    this.record, {
    super.key,
  });

  @override
  State<AnnounceDetailsPage> createState() => _AnnounceDetailsPageState();
}

class _AnnounceDetailsPageState extends State<AnnounceDetailsPage> {
  OaAnnounceDetails? details;

  OaAnnounceRecord get record => widget.record;
  late final url =
      'https://myportal.sit.edu.cn/detach.portal?action=bulletinBrowser&.ia=false&.pmn=view&.pen=${record.bulletinCatalogueId}&bulletinId=${record.uuid}';

  Future<OaAnnounceDetails?> fetchAnnounceDetail() async {
    return await OaAnnounceInit.service.getAnnounceDetail(widget.record.bulletinCatalogueId, widget.record.uuid);
  }

  @override
  void initState() {
    super.initState();
    fetchAnnounceDetail().then((value) {
      if (!mounted) return;
      setState(() {
        details = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final details = this.details;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: record.title.text(),
          actions: [
            IconButton(
              onPressed: () {
                launchUrlInBrowser(url);
              },
              icon: const Icon(Icons.open_in_browser),
            ),
          ],
          bottom: details != null
              ? null
              : const PreferredSize(
                  preferredSize: Size.fromHeight(4),
                  child: LinearProgressIndicator(),
                ),
        ),
        if (details != null)
          SliverToBoxAdapter(
            child: OaAnnounceInfoCard(
              record: record,
              details: details,
            ),
          ),
        if (details != null)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: AnnounceArticle(details),
          ),
        if (details != null) const SliverToBoxAdapter(child: Divider()),
        if (details != null)
          SliverToBoxAdapter(
            child: i18n.attachmentTip(details.attachments.length).text(
                  style: context.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
          ),
        if (details != null) ...details.attachments.map((e) => SliverToBoxAdapter(child: AttachmentLink(e))),
      ],
    );
  }

  Widget buildInfoCard(BuildContext ctx) {
    final valueStyle = Theme.of(context).textTheme.bodyMedium;
    final keyStyle = valueStyle?.copyWith(fontWeight: FontWeight.bold);

    TableRow buildRow(String key, String value) => TableRow(
          children: [
            Text(key, style: keyStyle),
            Text(value, style: valueStyle),
          ],
        );

    return Card(
      margin: const EdgeInsets.fromLTRB(2, 10, 2, 2),
      elevation: 3,
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(3),
            },
            children: [
              buildRow(i18n.publishingDepartment, record.departments.join(",")),
              buildRow(i18n.author, details?.author ?? ""),
              buildRow(i18n.publishTime, context.formatYmdWeekText(record.dateTime)),
            ],
          )),
    );
  }
}
