import 'package:flutter/material.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/mini_app.dart';

import '../widgets/brick.dart';
import 'package:mimir/route.dart';

class EduEmailBrick extends StatefulWidget {
  final String route;
  final IconBuilder icon;

  const EduEmailBrick({
    super.key,
    required this.route,
    required this.icon,
  });

  @override
  State<StatefulWidget> createState() => _EduEmailBrickState();
}

class _EduEmailBrickState extends State<EduEmailBrick> {
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
      route: widget.route,
      icon: widget.icon,
      title: MiniApp.eduEmail.l10nName(),
      subtitle: content ?? MiniApp.eduEmail.l10nDesc(),
    );
  }
}
