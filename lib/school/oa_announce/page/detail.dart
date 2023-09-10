import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/school/oa_announce/widget/article.dart';
import 'package:mimir/utils/guard_launch.dart';
import 'package:mimir/utils/url_launcher.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/announce.dart';
import '../init.dart';
import '../i18n.dart';

class AnnounceDetailsPage extends StatefulWidget {
  final AnnounceRecord record;

  const AnnounceDetailsPage(
    this.record, {
    super.key,
  });

  @override
  State<AnnounceDetailsPage> createState() => _AnnounceDetailsPageState();
}

class _AnnounceDetailsPageState extends State<AnnounceDetailsPage> {
  AnnounceDetail? detail;

  AnnounceRecord get record => widget.record;
  late final url =
      'https://myportal.sit.edu.cn/detach.portal?action=bulletinBrowser&.ia=false&.pmn=view&.pen=${record.bulletinCatalogueId}&bulletinId=${record.uuid}';

  Future<AnnounceDetail?> fetchAnnounceDetail() async {
    return await OaAnnounceInit.service.getAnnounceDetail(widget.record.bulletinCatalogueId, widget.record.uuid);
  }

  @override
  void initState() {
    super.initState();
    fetchAnnounceDetail().then((value) {
      if (!mounted) return;
      setState(() {
        detail = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.text.text(),
        actions: [
          IconButton(
            onPressed: () {
              launchUrlInBrowser(url);
            },
            icon: const Icon(Icons.open_in_browser),
          ),
        ],
        bottom: detail != null
            ? null
            : const PreferredSize(
                preferredSize: Size.fromHeight(4),
                child: LinearProgressIndicator(),
              ),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext ctx) {
    final theme = ctx.theme;
    final detail = this.detail;
    final titleStyle = theme.textTheme.titleLarge;
    return [
      [
        record.title.text(style: titleStyle),
        buildInfoCard(ctx),
      ].wrap().hero(record.uuid),
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: detail != null ? DetailArticle(detail) : const SizedBox(),
      ),
    ].column().padAll(12).scrolled();
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
              buildRow(i18n.author, detail?.author ?? ""),
              buildRow(i18n.publishTime, context.formatYmdWeekText(record.dateTime)),
            ],
          )),
    );
  }
}
