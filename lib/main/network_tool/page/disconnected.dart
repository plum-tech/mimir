import 'package:flutter/material.dart';
import 'package:mimir/main/network_tool/widgets/quick_button.dart';
import 'package:rettulf/rettulf.dart';

import '../using.dart';

class DisconnectedInfoPage extends StatelessWidget {
  const DisconnectedInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return [
      const Icon(Icons.public_off_outlined, size: 120).expanded(),
      buildTip(context).expanded(),
      const QuickButtons(),
    ].column(caa: CAAlign.stretch).padAll(10);
  }

  Widget buildTip(BuildContext context) {
    return Text(
      i18n.connectionFailedError,
      textAlign: TextAlign.start,
      style: context.textTheme.bodyLarge,
    ).padH(20);
  }
}
