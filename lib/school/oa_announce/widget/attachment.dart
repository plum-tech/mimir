import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:sanitize_filename/sanitize_filename.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:open_file/open_file.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/files.dart';

import '../entity/announce.dart';
import '../i18n.dart';
import '../init.dart';

class AttachmentLinkTile extends StatefulWidget {
  final String uuid;
  final OaAnnounceAttachment attachment;

  const AttachmentLinkTile(
    this.attachment, {
    super.key,
    required this.uuid,
  });

  @override
  State<AttachmentLinkTile> createState() => _AttachmentLinkTileState();
}

class _AttachmentLinkTileState extends State<AttachmentLinkTile> {
  double? progress;

  @override
  Widget build(BuildContext context) {
    final progress = this.progress;
    return ListTile(
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: widget.attachment.name,
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()..onTap = onDownload,
            ),
          ],
        ),
      ),
      subtitle: progress == null
          ? null
          : LinearProgressIndicator(
              value: progress.isNaN ? null : progress,
            ),
    );
  }

  Future<void> onDownload() async {
    final dir = await Files.oaAnnounce.attachmentDir(widget.uuid).create(recursive: true);
    final target = dir.subFile(sanitizeFilename(widget.attachment.name));
    if (await target.exists()) {
      await OpenFile.open(target.path);
    } else {
      if (!mounted) return;
      context.showSnackBar(
        content: i18n.downloading.text(),
        duration: const Duration(seconds: 1),
      );
      try {
        await _onDownloadFile(
          name: widget.attachment.name,
          url: widget.attachment.url,
          target: target,
          onProgress: (progress) {
            if (!mounted) return;
            setState(() {
              this.progress = progress;
            });
          },
        );
        if (!mounted) return;
        context.showSnackBar(
          content: widget.attachment.name.text(),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: i18n.open,
            onPressed: () async {
              await OpenFile.open(target.path);
            },
          ),
        );
        setState(() {
          progress = 1;
        });
      } catch (error, stackTrace) {
        debugPrint(error.toString());
        debugPrintStack(stackTrace: stackTrace);
        if (!mounted) return;
        setState(() {
          progress = null;
        });
        context.showSnackBar(
          content: i18n.downloadFailed.text(),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: i18n.retry,
            onPressed: () async {
              await onDownload();
            },
          ),
        );
      }
    }
  }
}

Future<void> _onDownloadFile({
  required String name,
  required String url,
  required File target,
  void Function(double progress)? onProgress,
}) async {
  debugPrint('Start downloading [$name]($url) to $target');
  // 如果文件不存在，那么下载文件
  await OaAnnounceInit.service.session.dio.download(
    url,
    target.path,
    onReceiveProgress: (int count, int total) {
      onProgress?.call(total <= 0 ? double.nan : count / total);
    },
  );
  debugPrint('Downloaded [$name]($url)');
}
