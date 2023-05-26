import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../using.dart';

class DisconnectedBlock extends StatelessWidget {
  const DisconnectedBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      i18n.connectionFailedError,
      textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.bodyLarge,
    ).scrolled().padH(20);
  }
}
