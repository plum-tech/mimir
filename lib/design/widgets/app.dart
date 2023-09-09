import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import 'card.dart';

class AppCard extends StatelessWidget {
  final Widget view;
  final Widget? title;
  final Widget? subtitle;
  final List<Widget>? leftActions;

  /// 12 by default.
  final double? leftActionsSpacing;
  final List<Widget>? rightActions;

  /// 0 by default
  final double? rightActionsSpacing;

  const AppCard({
    super.key,
    required this.view,
    this.title,
    this.subtitle,
    this.leftActions,
    this.rightActions,
    this.leftActionsSpacing,
    this.rightActionsSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final leftActions = this.leftActions ?? const <Widget>[];
    final rightActions = this.rightActions ?? const <Widget>[];
    final textTheme = context.textTheme;
    final view = this.view;
    return FilledCard(
      child: [
        Theme(
          data: context.theme.copyWith(
            cardTheme: context.theme.cardTheme.copyWith(
              // in light mode, cards look in a lower level.
              elevation: context.isDarkMode ? 4 : 2,
            ),
          ),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastLinearToSlowEaseIn,
            child: view,
          ),
        ),
        ListTile(
          titleTextStyle: textTheme.titleLarge,
          title: title,
          subtitleTextStyle: textTheme.bodyLarge,
          subtitle: subtitle,
        ),
        OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            leftActions.wrap(spacing: leftActionsSpacing ?? 12),
            rightActions.wrap(spacing: rightActionsSpacing ?? 0),
          ],
        ).padOnly(l: 16, b: rightActions.isEmpty ? 12 : 8, r: 16),
      ].column(),
    );
  }
}
