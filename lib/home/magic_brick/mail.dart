import 'package:flutter/material.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/l10n/extension.dart';

import '../user_widget/brick.dart';
import 'package:mimir/route.dart';

class EduEmailItem extends StatefulWidget {
  const EduEmailItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EduEmailItemState();
}

class _EduEmailItemState extends State<EduEmailItem> {
  String? content;

  @override
  void initState() {
    super.initState();
    Global.eventBus.on(EventNameConstants.onHomeRefresh, _onHomeRefresh);
  }

  @override
  void dispose() {
    Global.eventBus.off(EventNameConstants.onHomeRefresh, _onHomeRefresh);
    super.dispose();
  }

  void _onHomeRefresh(_) async {}

  @override
  Widget build(BuildContext context) {
    return Brick(
      route: RouteTable.eduEmail,
      icon: SvgAssetIcon('assets/home/icon_mail.svg'),
      title: i18n.ftype_eduEmail,
      subtitle: content ?? i18n.ftype_eduEmail_desc,
    );
  }
}
