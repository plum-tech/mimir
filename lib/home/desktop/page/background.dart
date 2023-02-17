import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/dialog.dart';
import 'package:mimir/global/desktop_init.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/storage/init.dart';
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

class HomeBackground extends StatefulWidget {
  const HomeBackground({super.key});

  @override
  State<StatefulWidget> createState() => _HomeBackgroundState();
}

class _HomeBackgroundState extends State<HomeBackground> {
  @override
  void initState() {
    super.initState();
    Global.eventBus.on<EventTypes>().listen((e) {
      if (e == EventTypes.onBackgroundChange) {
        if (Kv.home.background == null) {
          return;
        }
        setState(() {});
      }
    });
    if (UniversalPlatform.isDesktop) {
      desktopEventBus.on<WindowResizeEndEvent>().listen((e) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () {
            setState(() {});
          },
        );
      });
    }
  }

  Widget _buildImageBg(File file) {
    return Image.file(file, fit: BoxFit.fill);
  }

  @override
  Widget build(BuildContext context) {
    if (Kv.home.backgroundMode == 2) {
      final backgroundSelected = Kv.home.background;
      if (backgroundSelected != null) {
        return _buildImageBg(File(backgroundSelected));
      }
    }
    return const SizedBox();
  }
}
