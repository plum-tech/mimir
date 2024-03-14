import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:rettulf/rettulf.dart';

import 'multiplatform.dart';

abstract class PullDownEntry {
  PullDownMenuEntry _buildCupertino();

  PopupMenuEntry _buildMaterial();
}

class PullDownDivider implements PullDownEntry {
  const PullDownDivider();

  @override
  PullDownMenuEntry _buildCupertino() {
    return const PullDownMenuDivider.large();
  }

  @override
  PopupMenuEntry _buildMaterial() {
    return const PopupMenuDivider();
  }
}

class PullDownItem implements PullDownEntry {
  final String title;
  final VoidCallback? onTap;
  final IconData? icon;
  final IconData? cupertinoIcon;
  final bool destructive;

  const PullDownItem({
    required this.title,
    this.onTap,
    this.icon,
    this.cupertinoIcon,
    this.destructive = false,
  });

  @override
  PullDownMenuEntry _buildCupertino() {
    return PullDownMenuItem(
      onTap: onTap,
      title: title,
      isDestructive: destructive,
      icon: cupertinoIcon ?? icon,
    );
  }

  @override
  PopupMenuEntry _buildMaterial() {
    final icon = this.icon;
    return PopupMenuItem(
      onTap: onTap,
      child: ListTile(
        leading: icon == null ? null : Icon(icon),
        title: title.text(),
      ),
    );
  }
}

class PullDownSelectable implements PullDownEntry {
  final bool selected;
  final String title;
  final VoidCallback? onTap;
  final IconData? icon;
  final IconData? cupertinoIcon;

  const PullDownSelectable({
    required this.title,
    required this.selected,
    this.onTap,
    this.icon,
    this.cupertinoIcon,
  });

  @override
  PullDownMenuEntry _buildCupertino() {
    return PullDownMenuItem.selectable(
      onTap: onTap,
      selected: selected,
      title: title,
      icon: cupertinoIcon ?? icon,
    );
  }

  @override
  PopupMenuEntry _buildMaterial() {
    return CheckedPopupMenuItem(
      checked: selected,
      onTap: onTap,
      child: ListTile(
        leading: icon == null ? null : Icon(icon),
        title: title.text(),
      ),
    );
  }
}

class PullDownMenuButton extends StatelessWidget {
  final List<PullDownEntry> Function(BuildContext context) itemBuilder;

  const PullDownMenuButton({
    super.key,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (isCupertino) {
      return PullDownButton(
        itemBuilder: (context) => itemBuilder(context).map((item) => item._buildCupertino()).toList(),
        buttonBuilder: (context, showMenu) => CupertinoButton(
          onPressed: showMenu,
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.ellipsis_circle),
        ),
      );
    } else {
      return PopupMenuButton(
        position: PopupMenuPosition.under,
        padding: EdgeInsets.zero,
        itemBuilder: (context) => itemBuilder(context).map((item) => item._buildMaterial()).toList(),
      );
    }
  }
}
