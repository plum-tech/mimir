import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: title,
          ),
          SliverToBoxAdapter(
            child: LayoutBuilder(
              builder: (ctx, box) {
                final side = min(box.maxWidth, maxSize ?? 256.0);
                return SizedBox(
                  width: side,
                  height: side,
                  child: PlainQrCodeView(
                    data: data,
                  ),
                ).center();
              },
            ),
          ),
          SliverToBoxAdapter(
            child: RichText(
              text: TextSpan(
                style: context.textTheme.bodyLarge,
                children: _i18n.hint,
              ),
            ).padAll(10),
          )
        ],
      ),
    );
  }
}

class PlainQrCodeView extends StatelessWidget {
  final String data;

  const PlainQrCodeView({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return QrImageView(
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
