import 'package:flutter/material.dart';
import 'package:mimir/credential/symbol.dart';
import 'package:mimir/events/bus.dart';
import 'package:mimir/events/events.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/module/application/init.dart';
import 'package:mimir/route.dart';
import 'package:mimir/storage/init.dart';
import 'package:mimir/util/logger.dart';

import '../user_widget/brick.dart';

class ApplicationItem extends StatefulWidget {
  const ApplicationItem({super.key});

  @override
  State<StatefulWidget> createState() => _ApplicationItemState();
}

class _ApplicationItemState extends State<ApplicationItem> {
  String? content;

  @override
  void initState() {
    super.initState();
    On.home<HomeRefreshEvent>((event) {
      final oaCredential = Auth.oaCredential;
      if (oaCredential != null) {
        onHomeRefresh(oaCredential);
      }
    });
  }

  void _tryUpdateContent(String? newContent) {
    if (newContent != null) {
      if (newContent.isEmpty || newContent.trim().isEmpty) {
        content = null;
      } else {
        content = newContent;
      }
    } else {
      content = null;
    }
  }

  void onHomeRefresh(OACredential oaCredential) async {
    if (!mounted) return;
    final result = await buildContent(oaCredential);
    if (result != null) {
      Kv.home.lastOfficeStatus = result;
      if (!mounted) return;
      setState(() => _tryUpdateContent(result));
    }
  }

  Future<String?> buildContent(OACredential oaCredential) async {
    if (!ApplicationInit.session.isLogin) {
      try {
        await ApplicationInit.session.login(
          username: oaCredential.account,
          password: oaCredential.password,
        );
      } catch (e) {
        Log.error(e);
        return null;
      }
    }
    format(s, x) => x > 0 ? '$s ($x)' : '';
    final totalMessage = await ApplicationInit.messageService.getMessageCount();
    if (totalMessage == null) return null;
    final draftBlock = format(i18n.draft, totalMessage.inDraft);
    final doingBlock = format(i18n.processing, totalMessage.inProgress);
    final completedBlock = format(i18n.done, totalMessage.completed);

    return '$draftBlock $doingBlock $completedBlock'.trim();
  }

  @override
  Widget build(BuildContext context) {
    // 如果是首屏加载, 从缓存读
    _tryUpdateContent(Kv.home.lastOfficeStatus);
    return Brick(
        route: RouteTable.application,
        icon: SvgAssetIcon('assets/home/icon_office.svg'),
        title: i18n.ftype_application,
        subtitle: content ?? i18n.ftype_application_desc);
  }
}
