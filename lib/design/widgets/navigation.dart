import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageNavigationTile extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget icon;
  final String path;

  const PageNavigationTile({
    super.key,
    this.title,
    this.subtitle,
    required this.icon,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: subtitle,
      leading: icon,
      trailing: const Icon(Icons.navigate_next_rounded),
      onTap: () {
        context.push(path);
      },
    );
  }
}
