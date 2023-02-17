import 'package:flutter/material.dart';
import 'package:mimir/home/magic_brick/report.dart';

import '../route.dart';
import 'entity/ftype.dart';
import 'magic_brick/application.dart';
import 'magic_brick/electricity.dart';
import 'magic_brick/expense.dart';
import 'magic_brick/library.dart';
import 'magic_brick/mail.dart';
import 'widgets/brick.dart';

class HomepageFactory {
  static final Map<FType, WidgetBuilder?> builders = {
    FType.reportTemp: (context) => const ReportTempItem(),
    FType.timetable: (context) => Brick(
          route: Routes.timetable,
          icon: SvgAssetIcon('assets/home/icon_timetable.svg'),
          title: FType.timetable.l10nName(),
          subtitle: FType.timetable.l10nDesc(),
        ),
    FType.examArr: (context) => Brick(
          route: Routes.examArrangement,
          icon: SvgAssetIcon('assets/home/icon_exam.svg'),
          title: FType.examArr.l10nName(),
          subtitle: FType.examArr.l10nDesc(),
        ),
    FType.activity: (context) => Brick(
          route: Routes.activity,
          icon: SvgAssetIcon('assets/home/icon_event.svg'),
          title: FType.activity.l10nName(),
          subtitle: FType.activity.l10nDesc(),
        ),
    FType.expense: (context) => const ExpenseItem(),
    FType.examResult: (context) => Brick(
          route: Routes.examResult,
          icon: SvgAssetIcon('assets/home/icon_score.svg'),
          title: FType.examResult.l10nName(),
          subtitle: FType.examResult.l10nDesc(),
        ),
    FType.library: (context) => const LibraryItem(),
    FType.application: (context) => const ApplicationItem(),
    FType.eduEmail: (context) => const EduEmailItem(),
    FType.oaAnnouncement: (context) => Brick(
          route: Routes.oaAnnouncement,
          icon: SvgAssetIcon('assets/home/icon_bulletin.svg'),
          title: FType.oaAnnouncement.l10nName(),
          subtitle: FType.oaAnnouncement.l10nDesc(),
        ),
    FType.yellowPages: (context) => Brick(
          route: Routes.yellowPages,
          icon: SvgAssetIcon('assets/home/icon_contact.svg'),
          title: FType.yellowPages.l10nName(),
          subtitle: FType.yellowPages.l10nDesc(),
        ),
    FType.separator: (context) => Container(),
    FType.elecBill: (context) => const ElectricityBillItem(),
  };

  static Widget? buildBrickWidget(BuildContext context, FType type) {
    assert(builders.containsKey(type), "Brick[${type.name}] is not available.");
    final builder = builders[type];
    return builder?.call(context);
  }
}
