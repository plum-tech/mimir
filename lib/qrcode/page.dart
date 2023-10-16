import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/l10n/tr.dart';

class _I18n {
  const _I18n();

  static const ns = "qrCode";

  List<InlineSpan> get hint => "$ns.hint".trSpan(args: {
        "me": const WidgetSpan(child: Icon(Icons.person)),
        "scan": const WidgetSpan(child: Icon(Icons.qr_code_scanner)),
      });
}

const _i18n = _I18n();

class QrCodePage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
      ),
      body: [
        LayoutBuilder(
          builder: (ctx, box) {
            final side = min(box.maxWidth, maxSize ?? 256.0);
            return SizedBox(
              width: side,
              height: side,
              child: QrImageView(
                backgroundColor: context.colorScheme.surface,
                data: data,
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: context.colorScheme.onSurface,
                ),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: context.colorScheme.onSurface,
                ),
                version: QrVersions.auto,
              ),
            );
          },
        ),
        RichText(
          text: TextSpan(
            style: context.textTheme.bodyLarge,
            children: _i18n.hint,
          ),
        ).padAll(10),
      ].column().scrolled().center(),
    );
  }
}
