import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart' as w;
import 'package:rettulf/rettulf.dart';

class SwipeAction {
  final VoidCallback action;
  final Icon? icon;
  final String? label;

  SwipeAction({
    required this.action,
    this.icon,
    this.label,
  });
}

class WithSwipeAction extends StatelessWidget {
  final Widget child;
  final SwipeAction? left;
  final SwipeAction? right;
  final Key childKey;

  const WithSwipeAction({
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
    return w.SwipeActionCell(
      key: childKey,
      backgroundColor: Colors.transparent,
      trailingActions: right == null
          ? null
          : <w.SwipeAction>[
              w.SwipeAction(
                title: right.label,
                icon: right.icon,
                style: context.textTheme.titleSmall ?? const TextStyle(),
                performsFirstActionWithFullSwipe: true,
                onTap: (w.CompletionHandler handler) async {
                  await handler(true);
                  right.action();
                },
                color: Colors.red,
              ),
            ],
      leadingActions: left == null
          ? null
          : <w.SwipeAction>[
              w.SwipeAction(
                title: left.label,
                icon: left.icon,
                style: context.textTheme.titleSmall ?? const TextStyle(),
                performsFirstActionWithFullSwipe: true,
                onTap: (w.CompletionHandler handler) async {
                  await handler(true);
                  left.action();
                },
                color: Colors.red,
              ),
            ],
      child: child,
    );
  }
}
