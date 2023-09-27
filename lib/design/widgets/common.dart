import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rettulf/rettulf.dart';

class LeavingBlank extends StatelessWidget {
  final WidgetBuilder iconBuilder;
  final String? desc;
  final VoidCallback? onIconTap;
  final Widget? subtitle;

  const LeavingBlank.builder({super.key, required this.iconBuilder, required this.desc, this.onIconTap, this.subtitle});

  factory LeavingBlank({
    Key? key,
    required IconData icon,
    String? desc,
    VoidCallback? onIconTap,
    double size = 120,
    Widget? subtitle,
  }) {
    return LeavingBlank.builder(
      iconBuilder: (ctx) => icon.make(size: size, color: ctx.colorScheme.primary),
      desc: desc,
      onIconTap: onIconTap,
      subtitle: subtitle,
    );
  }

  factory LeavingBlank.svgAssets({
    Key? key,
    required String assetName,
    String? desc,
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
    if (subtitle != null) {
      return [
        icon,
        if (desc != null) buildDesc(context, desc!),
        subtitle!,
      ].column(maa: MainAxisAlignment.spaceAround, mas: MainAxisSize.min).center();
    } else {
      return [
        icon,
        if (desc != null) buildDesc(context, desc!),
      ].column(maa: MainAxisAlignment.spaceAround, mas: MainAxisSize.min).center();
    }
  }

  Widget buildDesc(BuildContext ctx, String desc) {
    return desc
        .text(
          style: ctx.textTheme.titleLarge,
          textAlign: TextAlign.center,
        )
        .center()
        .padAll(10);
  }
}
