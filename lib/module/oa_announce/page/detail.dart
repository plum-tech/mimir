import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mimir/design/utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/announce.dart';
import '../entity/attachment.dart';
import '../init.dart';
import '../using.dart';

class DetailPage extends StatefulWidget {
  final AnnounceRecord summary;

  const DetailPage(this.summary, {super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  static final RegExp _phoneRegex = RegExp(r"(6087\d{4})");
  static final RegExp _mobileRegex = RegExp(r"(\d{12})");
  AnnounceDetail? _detail;

  AnnounceRecord get summary => widget.summary;
  late final url =
      'https://myportal.sit.edu.cn/detach.portal?action=bulletinBrowser&.ia=false&.pmn=view&.pen=${summary.bulletinCatalogueId}&bulletinId=${summary.uuid}';

  Future<AnnounceDetail?> fetchAnnounceDetail() async {
    return await OaAnnounceInit.service.getAnnounceDetail(widget.summary.bulletinCatalogueId, widget.summary.uuid);
  }

  @override
  void initState() {
    super.initState();
    fetchAnnounceDetail().then((value) {
      if (!mounted) return;
      setState(() {
        _detail = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.oaAnnouncementTextTitle.text(),
        actions: [
          IconButton(
            onPressed: () {
              launchUrlInBrowser(url);
            },
            icon: const Icon(Icons.open_in_browser),
          ),
        ],
      ),
      body: buildBody(context).padAll(12),
    );
  }

  Widget buildBody(BuildContext ctx) {
    final theme = ctx.theme;
    final titleStyle = theme.textTheme.titleLarge;
    return [
      [
        summary.title.text(style: titleStyle),
        buildInfoCard(ctx),
      ].wrap().hero(summary.uuid),
      (_detail != null ? buildDetailArticle(ctx) : Placeholders.loading()).animatedSwitched(
        d: const Duration(milliseconds: 800),
      ),
    ].column().scrolled();
  }

  Widget buildInfoCard(BuildContext ctx) {
    final valueStyle = Theme.of(context).textTheme.bodyText2;
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
              buildRow(i18n.publishingDepartment, summary.department),
              buildRow(i18n.author, _detail?.author ?? "..."),
              buildRow(i18n.publishTime, context.dateText(summary.dateTime)),
            ],
          )),
    );
  }

  // static final dateFormat = DateFormat('yyyy/MM/dd HH:mm');

  String _linkTel(String content) {
    String t = content;
    for (var phone in _phoneRegex.allMatches(t)) {
      final num = phone.group(0).toString();
      t = t.replaceAll(num, '<a href="tel:021$num">$num</a>');
    }
    for (var mobile in _mobileRegex.allMatches(content)) {
      final num = mobile.group(0).toString();
      t = t.replaceAll(num, '<a href="tel:$num">$num</a>');
    }
    return t;
  }

  Future<void> _onDownloadFile(AnnounceAttachment attachment) async {
    context.showSnackBar(i18n.downloading.text(), duration: const Duration(seconds: 1));
    Log.info('下载文件: [${attachment.name}](${attachment.url})');

    String targetPath = '${(await getTemporaryDirectory()).path}/kite1/downloads/${attachment.name}';
    Log.info('下载到：$targetPath');
    // 如果文件不存在，那么下载文件
    if (!await File(targetPath).exists()) {
      await OaAnnounceInit.session.download(
        attachment.url,
        savePath: targetPath,
        onReceiveProgress: (int count, int total) {
          // Log.info('已下载: ${count / (1024 * 1024)}MB');
        },
      );
    }

    if (!mounted) return;
    context.showSnackBar(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                i18n.downloadCompleted.text(),
                Text(attachment.name),
              ],
            ),
          ),
          TextButton(
            onPressed: () => OpenFile.open(targetPath),
            child: i18n.open.text(),
          ),
        ],
      ),
      duration: const Duration(seconds: 5),
    );
  }

  Widget buildDetailArticle(BuildContext ctx) {
    final detail = _detail;
    if (detail == null) {
      return const SizedBox();
    }
    final theme = context.theme;
    final titleStyle = theme.textTheme.titleLarge;
    final htmlContent = _linkTel(detail.content);
    final widgets = [
      // DarkModeSafe sometimes isn't safe.
      if (theme.isDark) DarkModeSafeHtmlWidget(htmlContent) else MyHtmlWidget(htmlContent),
    ];
    if (detail.attachments.isNotEmpty) {
      widgets.add(const Divider());
      widgets.add(Text(i18n.oaAnnouncementAttachmentTip(detail.attachments.length), style: titleStyle));
      widgets.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: detail.attachments.map((e) {
          return TextButton(
            onPressed: () async => _onDownloadFile(e),
            child: Text(e.name),
          );
        }).toList(),
      ));
    }
    return widgets.column();
  }
}

class DarkModeSafeHtmlWidget extends StatefulWidget {
  final String html;

  const DarkModeSafeHtmlWidget(
    this.html, {
    super.key,
  });

  @override
  State<DarkModeSafeHtmlWidget> createState() => _DarkModeSafeHtmlWidgetState();
}

class _DarkModeSafeHtmlWidgetState extends State<DarkModeSafeHtmlWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.backgroundColor;
    final textColor = theme.textTheme.bodyText2?.color ?? Colors.white;
    final fontFamily = theme.textTheme.bodyText2?.fontFamily ?? "";
    final fontSizeNumber = theme.textTheme.bodyText2?.fontSize;
    final fontSize = fontSizeNumber != null ? FontSize(fontSizeNumber) : FontSize.large;
    return SingleChildScrollView(
        child: SelectableHtml(
            data: widget.html,
            onLinkTap: (url, context, attributes, element) async {
              if (url != null) {
                await GlobalLauncher.launch(url);
              }
            },
            style: {
              "p": Style(
                backgroundColor: bgColor,
                color: textColor,
                fontSize: fontSize,
                fontFamily: fontFamily,
              ),
              "div": Style(
                color: textColor,
                backgroundColor: bgColor,
                fontSize: fontSize,
                fontFamily: fontFamily,
              ),
              "span": Style(
                color: textColor,
                backgroundColor: bgColor,
                fontSize: fontSize,
                fontFamily: fontFamily,
              ),
              "b": Style(
                color: textColor,
                backgroundColor: bgColor,
                fontSize: fontSize,
                fontFamily: fontFamily,
              ),
            },
            tagsList: filterTags([...Html.tags])));
  }

  List<String> filterTags(List<String> tags) {
    return tags;
  }
}
