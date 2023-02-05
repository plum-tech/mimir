import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mimir/design/colors.dart';
import 'package:mimir/design/utils.dart';
import 'package:mimir/module/application/using.dart';

typedef IconBuilder = Widget Function(double size, Color color);
// ignore: non_constant_identifier_names
IconBuilder SysIcon(IconData icon) {
  return (size, color) => Icon(icon, size: size, color: color);
}

// ignore: non_constant_identifier_names
IconBuilder SvgAssetIcon(String path) {
  return (size, color) => SvgPicture.asset(path, width: size, height: size, color: color);
}

// ignore: non_constant_identifier_names
IconBuilder SvgNetworkIcon(String path) {
  return (size, color) => SvgPicture.network(path, width: size, height: size, color: color);
}

class Brick extends StatefulWidget {
  final String? route;
  final Map<String, dynamic>? routeArgs;
  final IconBuilder icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onPressed;

  const Brick({
    this.route,
    this.routeArgs,
    this.onPressed,
    required this.title,
    this.subtitle,
    required this.icon,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _BrickState();
}

class _BrickState extends State<Brick> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextStyle? titleStyle;
    final TextStyle? subtitleStyle;
    final Color bg;
    final Color iconColor = context.darkSafeThemeColor;
    final titleStyleRaw = theme.textTheme.titleLarge;
    if (theme.isLight) {
      titleStyle = titleStyleRaw?.copyWith(color: Color.lerp(titleStyleRaw.color, iconColor, 0.6));
      subtitleStyle = theme.textTheme.bodyMedium?.copyWith(color: Colors.black87);
      bg = Colors.white.withOpacity(0.6);
    } else {
      titleStyle = titleStyleRaw?.copyWith(color: Color.lerp(titleStyleRaw.color, iconColor, 0.8));
      subtitleStyle = theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.headline4?.color);
      bg = Colors.black87.withOpacity(0.2);
    }
    return Container(
      decoration: BoxDecoration(color: bg),
      child: ListTile(
        leading: widget.icon(48, iconColor),
        title: Text(widget.title, style: titleStyle),
        subtitle: Text(widget.subtitle ?? '', style: subtitleStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
        // dense: true,
        onTap: () {
          widget.onPressed?.call();
          final dest = widget.route;
          if (dest != null) {
            Navigator.of(context).pushNamed(dest, arguments: widget.routeArgs);
          }
        },
        style: ListTileStyle.list,
      ),
    );
  }
}
