import 'package:flutter/material.dart';
import 'package:mimir/design/adaptive/adaptive.dart';
import 'package:mimir/design/widgets/dialog.dart';

import 'list.dart';
import 'mailbox.dart';
import '../i18n.dart';

class ApplicationIndexPage extends StatefulWidget {
  const ApplicationIndexPage({super.key});

  @override
  State<ApplicationIndexPage> createState() => _ApplicationIndexPageState();
}

class _ApplicationIndexPageState extends State<ApplicationIndexPage> {
  final $enableFilter = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return AdaptiveNavi(
      title: i18n.title,
      defaultIndex: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () async {
            await context.showTip(
              title: i18n.title,
              desc: i18n.desc,
              ok: i18n.close,
            );
          },
        ),
        IconButton(
          icon: $enableFilter.value ? const Icon(Icons.filter_alt_outlined) : const Icon(Icons.filter_alt_off_outlined),
          tooltip: i18n.filerInfrequentlyUsed,
          onPressed: () {
            setState(() {
              $enableFilter.value = !$enableFilter.value;
            });
          },
        ),
      ],
      pages: [
        // Activity List page
        AdaptivePage(
          label: i18n.navigation.all,
          unselectedIcon: const Icon(Icons.check_box_outline_blank),
          selectedIcon: const Icon(Icons.list_alt_rounded),
          builder: (ctx, key) {
            return YwbListPage(key: key);
          },
        ),
        // Mine page
        AdaptivePage(
          label: i18n.navigation.mailbox,
          unselectedIcon: const Icon(Icons.mail_outline_rounded),
          selectedIcon: const Icon(Icons.mail_rounded),
          builder: (ctx, key) {
            return YwbMailboxPage(key: key);
          },
        ),
      ],
    );
  }
}
