import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sit/l10n/common.dart';
import 'package:sit/l10n/tr.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "qrCode";

  String get barcodeNotRecognizedTip => "$ns.barcodeNotRecognizedTip".tr();

  String get unrecognizedQrCodeTip => "$ns.unrecognizedQrCodeTip".tr();

  List<InlineSpan> get hint => "$ns.hint".trSpan(args: {
        "me": const WidgetSpan(child: Icon(Icons.person)),
        "scan": const WidgetSpan(child: Icon(Icons.qr_code_scanner)),
      });
}
