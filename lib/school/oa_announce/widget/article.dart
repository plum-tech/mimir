import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/dialog.dart';
import 'package:mimir/widgets/html.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/announce.dart';
import '../init.dart';
import '../i18n.dart';

class DetailArticle extends StatelessWidget {
  final AnnounceDetail detail;

  const DetailArticle(this.detail, {super.key});

  @override
  Widget build(BuildContext context) {
    final htmlContent = _linkTel(detail.content);
    // TODO: Bidirectional scrolling for large charts.
    final widgets = <Widget>[
      SelectionArea(child: StyledHtmlWidget(htmlContent)),
    ];
    if (detail.attachments.isNotEmpty) {
      widgets.add(const Divider());
      widgets.add(i18n.attachmentTip(detail.attachments.length).text(style: context.textTheme.titleLarge));
      widgets.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: detail.attachments.map((e) {
          return CupertinoButton(
            onPressed: () async => _onDownloadFile(context, e),
            child: Text(e.name),
          );
        }).toList(),
      ));
    }
    return widgets.column();
  }
}

final RegExp _phoneRegex = RegExp(r"(6087\d{4})");
final RegExp _mobileRegex = RegExp(r"(\d{12})");

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

Future<void> _onDownloadFile(BuildContext context, AnnounceAttachment attachment) async {
  context.showSnackBar(i18n.downloading.text(), duration: const Duration(seconds: 1));
  debugPrint('下载文件: [${attachment.name}](${attachment.url})');
  // TODO: download files.
  String targetPath = '${(await getTemporaryDirectory()).path}/downloads/${attachment.name}';
  debugPrint('下载到：$targetPath');
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

  if (!context.mounted) return;
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
        CupertinoButton(
          onPressed: () => OpenFile.open(targetPath),
          child: i18n.open.text(),
        ),
      ],
    ),
    duration: const Duration(seconds: 5),
  );
}
