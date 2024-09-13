import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/widgets/markdown.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/agreements.dart';

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
    final $accepted = Settings.agreements.$acceptAgreementsOf(type);
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
