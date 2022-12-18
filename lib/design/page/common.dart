import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rettulf/rettulf.dart';

import '../colors.dart';

class LeavingBlank extends StatelessWidget {
  final WidgetBuilder iconBuilder;
  final String desc;
  final VoidCallback? onIconTap;
  final Widget? subtitle;

  const LeavingBlank.builder({super.key, required this.iconBuilder, required this.desc, this.onIconTap, this.subtitle});

  factory LeavingBlank({
    Key? key,
    required IconData icon,
    required String desc,
    VoidCallback? onIconTap,
    double size = 120,
    Widget? subtitle,
  }) {
    return LeavingBlank.builder(
      iconBuilder: (ctx) => icon.make(size: size, color: ctx.darkSafeThemeColor),
      desc: desc,
      onIconTap: onIconTap,
      subtitle: subtitle,
    );
  }

  factory LeavingBlank.svgAssets({
    Key? key,
    required String assetName,
    required String desc,
    VoidCallback? onIconTap,
    double width = 120,
    double height = 120,
    Widget? subtitle,
  }) {
    return LeavingBlank.builder(
      iconBuilder: (ctx) => SvgPicture.asset(assetName, width: width, height: height),
      desc: desc,
      onIconTap: onIconTap,
      subtitle: subtitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget icon = iconBuilder(context).padAll(20);
    if (onIconTap != null) {
      icon = icon.on(tap: onIconTap);
    }
    final sub = subtitle;
    if (sub != null) {
      return [
        icon.expanded(),
        [
          buildDesc(context),
          sub,
        ].column().expanded(),
      ].column(maa: MAAlign.spaceAround).center();
    } else {
      return [
        icon.expanded(),
        buildDesc(context).expanded(),
      ].column(maa: MAAlign.spaceAround).center();
    }
  }

  Widget buildDesc(BuildContext ctx) {
    return desc
        .text(
          style: ctx.textTheme.titleLarge,
          textAlign: TextAlign.center,
        )
        .center()
        .padAll(10);
  }
}
