import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/announce.dart';
import '../i18n.dart';
import '../init.dart';

class AttachmentLink extends StatelessWidget {
  final OaAnnounceAttachment attachment;

  const AttachmentLink(
    this.attachment, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformTextButton(
      onPressed: () async => _onDownloadFile(context, attachment),
      child: Text(attachment.name),
    );
  }
}

Future<void> _onDownloadFile(BuildContext context, OaAnnounceAttachment attachment) async {
  context.showSnackBar(i18n.downloading.text(), duration: const Duration(seconds: 1));
  debugPrint('下载文件: [${attachment.name}](${attachment.url})');
  // TODO: download files.
  String targetPath = '${(await getTemporaryDirectory()).path}/downloads/${attachment.name}';
  debugPrint('下载到：$targetPath');
  // 如果文件不存在，那么下载文件
  if (!await File(targetPath).exists()) {
    await OaAnnounceInit.service.session.download(
      attachment.url,
      savePath: targetPath,
      onReceiveProgress: (int count, int total) {
        // Log.info('已下载: ${count / (1024 * 1024)}MB');
      },
    );
  }

  if (!context.mounted) return;
  // TODO: redesign
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
        PlatformTextButton(
          onPressed: () => OpenFile.open(targetPath),
          child: i18n.open.text(),
        ),
      ],
    ),
    duration: const Duration(seconds: 5),
  );
}
