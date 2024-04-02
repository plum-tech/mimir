import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/r.dart';
import 'package:sit/school/yellow_pages/init.dart';
import 'package:sit/school/yellow_pages/storage/contact.dart';
import 'package:rettulf/rettulf.dart';

import '../widgets/list.dart';
import '../widgets/search.dart';
import '../i18n.dart';

class YellowPagesListPage extends StatefulWidget {
  const YellowPagesListPage({super.key});

  @override
  State<YellowPagesListPage> createState() => _YellowPagesListPageState();
}

class _YellowPagesListPageState extends State<YellowPagesListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.title.text(),
        actions: [
          PlatformIconButton(
            onPressed: () async {
              final result = await showSearch(context: context, delegate: YellowPageSearchDelegate(R.yellowPages));
              if (result == null) return;
              YellowPagesInit.storage.addInteractHistory(result);
            },
            icon: Icon(context.icons.search),
          ),
        ],
      ),
      body: SchoolContactList(
        R.yellowPages,
      ),
    );
  }
}
