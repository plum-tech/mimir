import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mimir/l10n/common.dart';
import 'package:mimir/l10n/tr.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "qrCode";

  String get noQrCodeRecognizedTip => "$ns.noQrCodeRecognizedTip".tr();

  String get invalidFormatTip => "$ns.invalidFormatTip".tr();

  List<InlineSpan> get hint => "$ns.hint".trSpan(args: {
        "me": const WidgetSpan(child: Icon(Icons.person)),
        "scan": const WidgetSpan(child: Icon(Icons.qr_code_scanner)),
      });
}
