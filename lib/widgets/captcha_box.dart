import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/adaptive/foundation.dart';
import 'package:mimir/l10n/common.dart';
import 'package:rettulf/rettulf.dart';

class CaptchaBox extends StatefulWidget {
  final Uint8List captchaData;

  const CaptchaBox({
    super.key,
    required this.captchaData,
  });

  @override
  State<CaptchaBox> createState() => _CaptchaBoxState();
}

class _CaptchaBoxState extends State<CaptchaBox> {
  final $captcha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return $Dialog$(
      title: _i18n.title,
      primary: $Action$(
        text: _i18n.submit,
        warning: true,
        isDefault: true,
        onPressed: () {
          context.navigator.pop($captcha.text);
        },
      ),
      secondary: $Action$(
        text: _i18n.cancel,
        onPressed: () {
          context.navigator.pop(null);
        },
      ),
      make: (ctx) => [
        Image.memory(
          widget.captchaData,
          scale: 0.5,
        ),
        $TextField$(
          controller: $captcha,
          placeholder: _i18n.enterHint,
          autofillHints: const [AutofillHints.oneTimeCode],
          onSubmit: (value) {
            context.navigator.pop(value);
          },
        ).padOnly(t: 15),
      ].column(mas: MainAxisSize.min).padAll(5),
    );
  }

  @override
  void dispose() {
    super.dispose();
    $captcha.dispose();
  }
}

const _i18n = CaptchaI18n();

class CaptchaI18n with CommonI18nMixin {
  static const ns = "captcha";

  const CaptchaI18n();

  String get title => "$ns.title".tr();

  String get enterHint => "$ns.enterHint".tr();

  String get emptyInputError => "$ns.emptyInputError".tr();
}
