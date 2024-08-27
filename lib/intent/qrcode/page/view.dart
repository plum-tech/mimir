import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sanitize_filename/sanitize_filename.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/settings/dev.dart';
import 'package:mimir/utils/screenshot.dart';
import 'package:mimir/widgets/modal_image_view.dart';
import 'package:text_scroll/text_scroll.dart';

import '../i18n.dart';

class QrCodePage extends ConsumerStatefulWidget {
  final String data;
  final double? maxSize;
  final String? title;

  const QrCodePage({
    super.key,
    required this.data,
    this.maxSize,
    this.title,
  });

  @override
  ConsumerState createState() => _QrCodePageState();
}

class _QrCodePageState extends ConsumerState<QrCodePage> {
  final $qrcodeK = GlobalKey(debugLabel: "QR code view");

  @override
  Widget build(BuildContext context) {
    final title = widget.title;
    return Scaffold(
      appBar: AppBar(
        title: title == null ? null : TextScroll(title),
        actions: [
          PlatformTextButton(
            child: i18n.save.text(),
            onPressed: () async {
              final fi = await takeQrcodeScreenshot(
                context: context,
                data: widget.data,
                title: widget.title,
              );
              await onScreenshotTaken(fi.path);
            },
          ),
          PlatformIconButton(
            icon: Icon(context.icons.share),
            onPressed: () async {
              final sharePositionOrigin = ($qrcodeK.currentContext ?? context).getSharePositionOrigin();
              final fi = await takeQrcodeScreenshot(
                context: context,
                data: widget.data,
                title: widget.title,
              );
              await Share.shareXFiles(
                [XFile(fi.path)],
                sharePositionOrigin: sharePositionOrigin,
              );
            },
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (context.isPortrait) {
      return ListView(children: [
        buildQrCode(widget.data).padSymmetric(h: 4),
        const QrCodeHint().padAll(10),
        if (Dev.on) buildUrl(widget.data),
      ]);
    } else {
      return [
        buildQrCode(widget.data).expanded(),
        ListView(
          children: [
            const QrCodeHint().padAll(10),
            if (Dev.on) buildUrl(widget.data),
          ],
        ).expanded(),
      ].row();
    }
  }

  Widget buildQrCode(String data) {
    return LayoutBuilder(builder: (ctx, box) {
      final side = min(box.maxWidth, widget.maxSize ?? double.infinity);
      return ModalImageViewer(
        child: PlainQrCodeView(
          key: $qrcodeK,
          data: data,
          size: side,
        ).center(),
      );
    });
  }

  Widget buildUrl(String data) {
    return [
      ListTile(
        title: "Text length: ${data.length}".text(),
        trailing: PlatformIconButton(
          icon: Icon(context.icons.copy),
          onPressed: () async {
            context.showSnackBar(content: "Copied".text());
            await Clipboard.setData(ClipboardData(text: data));
          },
        ),
      ),
      SelectableText(data).padAll(10),
    ].column();
  }
}

class QrCodeHint extends StatelessWidget {
  const QrCodeHint({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: context.textTheme.bodyLarge,
        children: i18n.hint,
      ),
    );
  }
}

class PlainQrCodeView extends StatelessWidget {
  final String data;
  final double? size;

  const PlainQrCodeView({
    super.key,
    required this.data,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      backgroundColor: context.colorScheme.surface,
      data: data,
      size: size,
      eyeStyle: QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: context.colorScheme.onSurface,
      ),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: context.colorScheme.onSurface,
      ),
      version: QrVersions.auto,
    );
  }
}

class BrandQrCodeView extends StatelessWidget {
  final String data;

  const BrandQrCodeView({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return PrettyQrView.data(
      data: data,
      decoration: PrettyQrDecoration(
        shape: PrettyQrSmoothSymbol(
          color: context.colorScheme.onSurface,
        ),
        image: const PrettyQrDecorationImage(
          image: Svg("assets/icon.svg"),
        ),
      ),
    );
  }
}

Future<File> takeQrcodeScreenshot({
  required BuildContext context,
  String? title,
  required String data,
}) async {
  final fi = await takeWidgetScreenshot(
    context: context,
    name: '${title != null ? sanitizeFilename(title) : "QR code"}.png',
    child: Builder(
      builder: (ctx) {
        final maxSize = ctx.mediaQuery.size;
        final size = min(maxSize.width, maxSize.height);
        return Material(
          child: [
            if (title != null)
              Text(
                title,
                style: context.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ).sized(w: size * 0.8),
            PlainQrCodeView(
              data: data,
              size: size,
            ).padAll(8),
            const QrCodeHint().padSymmetric(v: 10).sized(w: size * 0.8),
          ].column().padAll(8),
        );
      },
    ),
  );
  return fi;
}
