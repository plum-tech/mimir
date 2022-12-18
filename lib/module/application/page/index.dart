import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../using.dart';
import 'list.dart';
import 'mailbox.dart';

class ApplicationIndexPage extends StatefulWidget {
  const ApplicationIndexPage({super.key});

  @override
  State<ApplicationIndexPage> createState() => _ApplicationIndexPageState();
}

class _ApplicationIndexPageState extends State<ApplicationIndexPage> {
  final $enableFilter = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    if (!Auth.hasLoggedIn) {
      return UnauthorizedTipPage(title: i18n.ftype_examArr.text());
    }
    return AdaptiveNavi(
      title: i18n.ftype_application,
      defaultIndex: 0,
      actions: [
        IconButton(
          icon: const Icon(CupertinoIcons.info_circle),
          onPressed: () async => showInfo(context),
        ),
        IconButton(
          icon: $enableFilter.value ? const Icon(Icons.filter_alt_outlined) : const Icon(Icons.filter_alt_off_outlined),
          tooltip: i18n.applicationFilerInfrequentlyUsed,
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
          label: i18n.applicationAllNavigation,
          unselectedIcon: const Icon(Icons.check_box_outline_blank),
          selectedIcon: const Icon(Icons.list_alt_rounded),
          builder: (ctx, key) {
            return ApplicationList(key: key, $enableFilter: $enableFilter);
          },
        ),
        // Mine page
        AdaptivePage(
          label: i18n.applicationMailboxNavigation,
          unselectedIcon: const Icon(Icons.mail_outline_rounded),
          selectedIcon: const Icon(Icons.mail_rounded),
          builder: (ctx, key) {
            return Mailbox(key: key);
          },
        ),
      ],
    );
  }
}

Future<void> showInfo(BuildContext ctx) async {
  await ctx.showTip(title: i18n.ftype_application, desc: i18n.applicationDesc, ok: i18n.close);
}
