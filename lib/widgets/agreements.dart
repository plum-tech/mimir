import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';

import 'markdown.dart';

class AgreementsI18n {
  const AgreementsI18n();

  static const _ns = "agreements";
}

const _i = AgreementsI18n();

enum AgreementsType {
  basic,
  account;

  String l10n() => "${AgreementsI18n._ns}.basic".tr();
}

class AgreementsCheckBox extends ConsumerWidget {
  final AgreementsType type;

  const AgreementsCheckBox({
    super.key,
    required this.type,
  });

  const AgreementsCheckBox.basic({
    super.key,
  }) : type = AgreementsType.basic;

  const AgreementsCheckBox.account({
    super.key,
  }) : type = AgreementsType.account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return [
      FeaturedMarkdownWidget(data: type.l10n()).expanded(flex: 9),
      Checkbox(value: false, onChanged: (v) {}),
    ].row();
  }
}
