import 'package:flutter/material.dart';
import 'package:mimir/mini_app.dart';
import 'package:mimir/route.dart';

import '../widgets/brick.dart';

class ApplicationItem extends StatefulWidget {
  const ApplicationItem({super.key});

  @override
  State<StatefulWidget> createState() => _ApplicationItemState();
}

class _ApplicationItemState extends State<ApplicationItem> {
  @override
  Widget build(BuildContext context) {
    return Brick(
      route: Routes.application,
      icon: SvgAssetIcon('assets/home/icon_office.svg'),
      title: MiniApp.application.l10nName(),
      subtitle: MiniApp.application.l10nDesc(),
    );
  }
}
