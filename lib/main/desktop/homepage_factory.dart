import 'package:flutter/material.dart';

import '../../mini_app.dart';
import 'magic_brick/application.dart';
import 'magic_brick/expense.dart';
import 'magic_brick/library.dart';
import 'magic_brick/mail.dart';
import 'widgets/brick.dart';

class HomepageFactory {
  static final Map<MiniApp, WidgetBuilder?> builders = {
    MiniApp.login: (context) => Brick(
          route: "/login/guard",
          icon: SysIcon(Icons.person_outlined),
          title: MiniApp.login.l10nName(),
          subtitle: MiniApp.login.l10nDesc(),
        ),
    MiniApp.examArr: (context) => Brick(
          route: "/app/examArr",
          icon: SvgAssetIcon('assets/home/icon_exam.svg'),
          title: MiniApp.examArr.l10nName(),
          subtitle: MiniApp.examArr.l10nDesc(),
        ),
    MiniApp.activity: (context) => Brick(
          route: "/app/activity",
          icon: SvgAssetIcon('assets/home/icon_event.svg'),
          title: MiniApp.activity.l10nName(),
          subtitle: MiniApp.activity.l10nDesc(),
        ),
    MiniApp.expense: (context) => ExpenseBrick(
          route: "/app/expense",
          icon: SvgAssetIcon('assets/home/icon_expense.svg'),
        ),
    MiniApp.examResult: (context) => Brick(
          route: "/app/examResult",
          icon: SvgAssetIcon('assets/home/icon_score.svg'),
          title: MiniApp.examResult.l10nName(),
          subtitle: MiniApp.examResult.l10nDesc(),
        ),
    MiniApp.library: (context) => LibraryBrick(
          route: '/app/library',
          icon: SvgAssetIcon('assets/home/icon_library.svg'),
        ),
    MiniApp.application: (context) => ApplicationBrick(
          route: '/app/application',
          icon: SvgAssetIcon('assets/home/icon_application.svg'),
        ),
    MiniApp.eduEmail: (context) => EduEmailBrick(
          route: '/app/eduEmail',
          icon: SvgAssetIcon('assets/home/icon_mail.svg'),
        ),
    MiniApp.oaAnnouncement: (context) => Brick(
          route: "/app/oaAnnouncement",
          icon: SvgAssetIcon('assets/home/icon_bulletin.svg'),
          title: MiniApp.oaAnnouncement.l10nName(),
          subtitle: MiniApp.oaAnnouncement.l10nDesc(),
        ),
    MiniApp.yellowPages: (context) => Brick(
          route: "/app/yellowPages",
          icon: SvgAssetIcon('assets/home/icon_contact.svg'),
          title: MiniApp.yellowPages.l10nName(),
          subtitle: MiniApp.yellowPages.l10nDesc(),
        ),
    MiniApp.separator: (context) => const SizedBox(),
  };

  static Widget? buildBrickWidget(BuildContext context, MiniApp type) {
    final builder = builders[type];
    return builder?.call(context);
  }
}
