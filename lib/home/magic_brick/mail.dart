import 'package:flutter/material.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/l10n/extension.dart';

import '../user_widget/brick.dart';
import 'package:mimir/route.dart';

class EduEmailItem extends StatefulWidget {
  const EduEmailItem({super.key});

  @override
  State<StatefulWidget> createState() => _EduEmailItemState();
}

class _EduEmailItemState extends State<EduEmailItem> {
  String? content;

  @override
  void initState() {
    super.initState();
    Global.eventBus.on<EventNameConstants>().listen((e){
      if(e==EventNameConstants.onHomeRefresh){

      }
    });
  }

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
