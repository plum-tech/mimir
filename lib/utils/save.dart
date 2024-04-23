import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/adaptive/dialog.dart';

class PromptSaveBeforeQuitScope extends StatelessWidget {
  final bool canSave;
  final FutureOr<void> Function() onSave;
  final Widget child;

  const PromptSaveBeforeQuitScope({
    super.key,
    required this.canSave,
    required this.onSave,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        if (!canSave) {
          context.pop();
          return;
        }
        final confirmSave = await context.showDialogRequest(
          desc: 'You have unsaved changes, do you want to save them?',
          primary: 'Save&Quit',
          secondary: 'Abort',
          secondaryDestructive: true,
        );
        if (confirmSave == true) {
          await onSave();
        } else if (confirmSave == false) {
          if (!context.mounted) return;
          context.pop();
        }
      },
      child: child,
    );
  }
}
