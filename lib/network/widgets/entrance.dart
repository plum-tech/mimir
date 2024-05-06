import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/navigation.dart';
import '../i18n.dart';

class NetworkToolEntranceTile extends StatelessWidget {
  const NetworkToolEntranceTile({super.key});

  @override
  Widget build(BuildContext context) {
    return PageNavigationTile(
      title: i18n.title.text(),
      subtitle: i18n.subtitle.text(),
      leading: const Icon(Icons.network_check),
      path: "/tools/network-tool",
    );
  }
}
