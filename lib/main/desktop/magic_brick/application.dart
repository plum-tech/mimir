import 'package:flutter/material.dart';
import 'package:mimir/mini_app.dart';
import '../../../route.dart';

import '../widgets/brick.dart';

class ApplicationBrick extends StatefulWidget {
  final String route;
  final IconBuilder icon;

  const ApplicationBrick({
    super.key,
    required this.route,
    required this.icon,
  });

  @override
  State<StatefulWidget> createState() => _ApplicationBrickState();
}

class _ApplicationBrickState extends State<ApplicationBrick> {
  @override
  Widget build(BuildContext context) {
    return Brick(
      route: widget.route,
      icon: widget.icon,
      title: MiniApp.application.l10nName(),
      subtitle: MiniApp.application.l10nDesc(),
    );
  }
}
