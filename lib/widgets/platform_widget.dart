import 'dart:io';

import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

/// 平台相关的组件封装
///
///
///
///
///
class MyPlatformWidget extends StatelessWidget {
  final WidgetBuilder? desktopOrWebBuilder;
  final WidgetBuilder? desktopBuilder;
  final WidgetBuilder? mobileBuilder;
  final WidgetBuilder? androidBuilder;
  final WidgetBuilder? iosBuilder;
  final WidgetBuilder? linuxBuilder;
  final WidgetBuilder? windowsBuilder;
  final WidgetBuilder? macosBuilder;
  final WidgetBuilder? webBuilder;
  final WidgetBuilder? fuchsiaBuilder;
  final WidgetBuilder? otherBuilder;
  const MyPlatformWidget({
    Key? key,
    this.desktopOrWebBuilder,
    this.desktopBuilder,
    this.mobileBuilder,
    this.androidBuilder,
    this.iosBuilder,
    this.linuxBuilder,
    this.windowsBuilder,
    this.macosBuilder,
    this.webBuilder,
    this.fuchsiaBuilder,
    this.otherBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 按照优先级去调用相应的widget builder
    if (UniversalPlatform.isWindows && windowsBuilder != null) return windowsBuilder!(context);
    if (UniversalPlatform.isMacOS && macosBuilder != null) return macosBuilder!(context);
    if (UniversalPlatform.isLinux && linuxBuilder != null) return linuxBuilder!(context);
    if (UniversalPlatform.isAndroid && androidBuilder != null) return androidBuilder!(context);
    if (UniversalPlatform.isIOS && iosBuilder != null) return iosBuilder!(context);
    if (UniversalPlatform.isWeb && webBuilder != null) return webBuilder!(context);
    if (UniversalPlatform.isFuchsia && fuchsiaBuilder != null) return fuchsiaBuilder!(context);
    if (!UniversalPlatform.isDesktopOrWeb && mobileBuilder != null) return mobileBuilder!(context);
    if (UniversalPlatform.isDesktop && desktopBuilder != null) return desktopBuilder!(context);
    if (UniversalPlatform.isDesktopOrWeb && desktopOrWebBuilder != null) return desktopOrWebBuilder!(context);
    if (otherBuilder != null) return otherBuilder!(context);
    throw UnimplementedError('No platform widget builder: ${Platform.operatingSystem}');
  }
}
