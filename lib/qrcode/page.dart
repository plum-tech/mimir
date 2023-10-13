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
  final double? size;
  final Widget? title;

  const QrCodePage({
    super.key,
    required this.data,
    this.size,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
      ),
      body: [
        Container(
          color: context.isDarkMode ? context.colorScheme.inverseSurface : context.colorScheme.surface,
          child: QrImageView(
            data: data,
            version: QrVersions.auto,
            size: size,
          ),
        ).padAll(20),
        RichText(
          text: TextSpan(
            style: context.textTheme.bodyLarge,
            children: _i18n.hint,
          ),
        ),
      ].column().padAll(10),
    );
  }
}
