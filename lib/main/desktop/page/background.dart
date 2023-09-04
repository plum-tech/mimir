import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mimir/global/desktop_init.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/storage/settings.dart';
import 'package:universal_platform/universal_platform.dart';

// TODO: homepage background
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
        // if (Settings.background == null) {
        //   return;
        // }
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
    // if (Settings.backgroundMode == 2) {
    //   final backgroundSelected = Settings.background;
    //   if (backgroundSelected != null) {
    //     return _buildImageBg(File(backgroundSelected));
    //   }
    // }
    return const SizedBox();
  }
}
