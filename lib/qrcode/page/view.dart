import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/settings/dev.dart';
import 'package:sit/utils/screenshot.dart';
import 'package:sit/widgets/modal_image_view.dart';

import '../i18n.dart';

class QrCodePage extends ConsumerStatefulWidget {
  final String data;
  final double? maxSize;
  final Widget? title;

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title,
        actions: [
          PlatformTextButton(
            child: "Save image".text(),
            onPressed: () async {
              await takeQrcodeScreenshot(context: context, data: widget.data);
            },
          )
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (context.isPortrait) {
      return ListView(children: [
        buildQrCode(widget.data).padSymmetric(h: 4),
        buildTip().padAll(10),
        if (Dev.on) buildUrl(widget.data),
      ]);
    } else {
      return [
        buildQrCode(widget.data).expanded(),
        ListView(
          children: [
            buildTip().padAll(10),
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
          data: data,
          size: side,
        ).center(),
      );
    });
  }

  Widget buildTip() {
    return RichText(
      text: TextSpan(
        style: context.textTheme.bodyLarge,
        children: i18n.hint,
      ),
    );
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

Future<void> takeQrcodeScreenshot({
  required BuildContext context,
  required String data,
}) async {
  if (!context.mounted) return;
  final fi = await takeWidgetScreenshot(
    context: context,
    name: 'qrcode.png',
    child: Builder(
      builder: (ctx) {
        final size = ctx.mediaQuery.size;
        return Material(
          child: PlainQrCodeView(
            data: data,
            size: min(size.width, size.height),
          ),
        );
      },
    ),
  );

  await onScreenshotTaken(fi.path);
}
