import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/l10n/common.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/widgets/markdown.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/agreements.dart';

class _I18n with CommonI18nMixin{
  static const ns = "agreements";
  const _I18n();
  String get acceptanceRequired => "$ns.acceptanceRequired.title".tr();

  String get acceptanceRequiredDesc => "$ns.acceptanceRequired.desc".tr();
}

const _i = _I18n();

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
    final $accepted = Settings.agreements.$AgreementsAcceptanceOf(type);
    final accepted = ref.watch($accepted) ?? false;
    return [
      Checkbox.adaptive(
        value: accepted,
        onChanged: (newV) {
          ref.read($accepted.notifier).set(newV);
        },
      ),
      FeaturedMarkdownWidget(data: type.l10n()).expanded(flex: 9),
    ].row();
  }
}

Future<void> showAgreementsRequired2Accept(BuildContext context) async {
  await context.showTip(
    title: _i.acceptanceRequired,
    desc: _i.acceptanceRequiredDesc,
    primary: _i.ok,
  );
}
