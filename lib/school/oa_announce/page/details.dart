import 'package:flutter/material.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/school/oa_announce/widget/article.dart';
import 'package:sit/utils/url_launcher.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/announce.dart';
import '../init.dart';
import '../i18n.dart';
import '../service/announce.dart';
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
  late OaAnnounceDetails? details =
      OaAnnounceInit.storage.getAnnounceDetails(widget.record.catalogId, widget.record.uuid);
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
      OaAnnounceInit.storage.setAnnounceDetails(catalogId, uuid, details);
      if (!mounted) return;
      setState(() {
        this.details = details;
        isFetching = false;
      });
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
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
      body: SelectionArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: widget.record.title.text(),
              actions: [
                IconButton(
                  onPressed: () {
                    launchUrlInBrowser(OaAnnounceService.getAnnounceUrl(widget.record.catalogId, widget.record.uuid));
                  },
                  icon: const Icon(Icons.open_in_browser),
                ),
              ],
              bottom: isFetching
                  ? const PreferredSize(
                      preferredSize: Size.fromHeight(4),
                      child: LinearProgressIndicator(),
                    )
                  : null,
            ),
            SliverToBoxAdapter(
              child: OaAnnounceInfoCard(
                record: record,
                details: details,
              ).hero(record.uuid),
            ),
            if (details != null)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                sliver: AnnounceArticle(details),
              ),
            if (details != null && details.attachments.isNotEmpty) ...[
              const SliverToBoxAdapter(child: Divider()),
              SliverToBoxAdapter(
                child: i18n.attachmentTip(details.attachments.length).text(
                      style: context.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
              )
            ],
            if (details != null) ...details.attachments.map((e) => SliverToBoxAdapter(child: AttachmentLink(e))),
          ],
        ),
      ),
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
    final author = details?.author;
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
              buildRow(i18n.publishingDepartment, widget.record.departments.join(",")),
              if (author != null) buildRow(i18n.author, author),
              buildRow(i18n.publishTime, context.formatYmdWeekText(widget.record.dateTime)),
            ],
          )),
    );
  }
}
