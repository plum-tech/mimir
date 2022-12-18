import 'package:flutter/material.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/route.dart';

import '../user_widget/brick.dart';

class ExamArrangementItem extends StatefulWidget {
  const ExamArrangementItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExamArrangementItemState();
}

class _ExamArrangementItemState extends State<ExamArrangementItem> {
  String? content;

  @override
  void initState() {
    super.initState();
    Global.eventBus.on(EventNameConstants.onHomeRefresh, (arg) {});
  }

  @override
  Widget build(BuildContext context) {
    return Brick(
      route: RouteTable.examArrangement,
      icon: SvgAssetIcon('assets/home/icon_exam.svg'),
      title: i18n.ftype_examArr,
      subtitle: content ?? i18n.ftype_examArr_desc,
    );
  }
}
