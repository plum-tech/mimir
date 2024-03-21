import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:rettulf/rettulf.dart';

import 'multiplatform.dart';

class SwipeToDismissAction {
  final VoidCallback action;
  final Icon? icon;
  final Icon? cupertinoIcon;
  final String? label;

  SwipeToDismissAction({
    required this.action,
    this.icon,
    this.cupertinoIcon,
    this.label,
  });
}

class SwipeToDismiss extends StatelessWidget {
  final Widget child;
  final SwipeToDismissAction? left;
  final SwipeToDismissAction? right;
  final Key childKey;

  const SwipeToDismiss({
    super.key,
    required this.childKey,
    required this.child,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    final left = this.left;
    final right = this.right;
    if (isCupertino) {
      return SwipeActionCell(
        key: childKey,
        trailingActions: right == null
            ? null
            : <SwipeAction>[
                SwipeAction(
                  title: right.label,
                  icon: isCupertino ? right.cupertinoIcon : right.icon,
                  style: context.textTheme.titleSmall ?? const TextStyle(),
                  performsFirstActionWithFullSwipe: true,
                  onTap: (CompletionHandler handler) async {
                    await handler(true);
                    right.action();
                  },
                  color: Colors.red,
                ),
              ],
        leadingActions: left == null
            ? null
            : <SwipeAction>[
                SwipeAction(
                  title: left.label,
                  icon: isCupertino ? left.cupertinoIcon : left.icon,
                  style: context.textTheme.titleSmall ?? const TextStyle(),
                  performsFirstActionWithFullSwipe: true,
                  onTap: (CompletionHandler handler) async {
                    await handler(true);
                    left.action();
                  },
                  color: Colors.red,
                ),
              ],
        child: child,
      );
    } else {
      return Dismissible(
        direction: DismissDirection.endToStart,
        key: childKey,
        onDismissed: (dir) async {
          if (dir == DismissDirection.startToEnd) {
            await HapticFeedback.heavyImpact();
            left?.action();
          } else if (dir == DismissDirection.endToStart) {
            await HapticFeedback.heavyImpact();
            right?.action();
          }
        },
        child: child,
      );
    }
  }
}
