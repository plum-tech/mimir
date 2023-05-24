import 'package:flutter/material.dart';

import '../../route.dart';
import 'entity/miniApp.dart';
import 'magic_brick/application.dart';
import 'magic_brick/electricity.dart';
import 'magic_brick/expense.dart';
import 'magic_brick/library.dart';
import 'magic_brick/mail.dart';
import 'widgets/brick.dart';

class HomepageFactory {
  static final Map<MiniApp, WidgetBuilder?> builders = {
    MiniApp.timetable: (context) => Brick(
          route: Routes.timetable,
          icon: SvgAssetIcon('assets/home/icon_timetable.svg'),
          title: MiniApp.timetable.l10nName(),
          subtitle: MiniApp.timetable.l10nDesc(),
        ),
    MiniApp.examArr: (context) => Brick(
          route: Routes.examArrangement,
          icon: SvgAssetIcon('assets/home/icon_exam.svg'),
          title: MiniApp.examArr.l10nName(),
          subtitle: MiniApp.examArr.l10nDesc(),
        ),
    MiniApp.activity: (context) => Brick(
          route: Routes.activity,
          icon: SvgAssetIcon('assets/home/icon_event.svg'),
          title: MiniApp.activity.l10nName(),
          subtitle: MiniApp.activity.l10nDesc(),
        ),
    MiniApp.expense: (context) => const ExpenseItem(),
    MiniApp.examResult: (context) => Brick(
          route: Routes.examResult,
          icon: SvgAssetIcon('assets/home/icon_score.svg'),
          title: MiniApp.examResult.l10nName(),
          subtitle: MiniApp.examResult.l10nDesc(),
        ),
    MiniApp.library: (context) => const LibraryItem(),
    MiniApp.application: (context) => const ApplicationItem(),
    MiniApp.eduEmail: (context) => const EduEmailItem(),
    MiniApp.oaAnnouncement: (context) => Brick(
          route: Routes.oaAnnouncement,
          icon: SvgAssetIcon('assets/home/icon_bulletin.svg'),
          title: MiniApp.oaAnnouncement.l10nName(),
          subtitle: MiniApp.oaAnnouncement.l10nDesc(),
        ),
    MiniApp.yellowPages: (context) => Brick(
          route: Routes.yellowPages,
          icon: SvgAssetIcon('assets/home/icon_contact.svg'),
          title: MiniApp.yellowPages.l10nName(),
          subtitle: MiniApp.yellowPages.l10nDesc(),
        ),
    MiniApp.separator: (context) => Container(),
    MiniApp.elecBill: (context) => const ElectricityBillItem(),
  };

  static Widget? buildBrickWidget(BuildContext context, MiniApp type) {
    assert(builders.containsKey(type), "Brick[${type.name}] is not available.");
    final builder = builders[type];
    return builder?.call(context);
  }
}
