import 'package:flutter/material.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/home/entity/ftype.dart';

import '../widgets/brick.dart';
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
    Global.eventBus.on<EventTypes>().listen((e) {
      if (e == EventTypes.onHomeRefresh) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Brick(
      route: Routes.eduEmail,
      icon: SvgAssetIcon('assets/home/icon_mail.svg'),
      title: FType.eduEmail.l10nName(),
      subtitle: content ?? FType.eduEmail.l10nDesc(),
    );
  }
}
