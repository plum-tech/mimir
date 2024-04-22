import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:sit/design/adaptive/dialog.dart';

class PromptSaveBeforeQuitScope extends StatefulWidget {
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
  State<PromptSaveBeforeQuitScope> createState() => _PromptSaveBeforeQuitScopeState();
}

class _PromptSaveBeforeQuitScopeState extends State<PromptSaveBeforeQuitScope> {
  var canPop = false;

  @override
  void didUpdateWidget(covariant PromptSaveBeforeQuitScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.canSave) {
      setState(() {
        canPop = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvoked: (didPop) async {
        if (!didPop) return;
        final confirmSave = await context.showDialogRequest(
          desc: 'You have unsaved changes, do you want to save them?',
          yes: 'Save&Quit',
          no: 'Abort',
        );
        if (confirmSave == true) {
          await widget.onSave();
          if (!mounted) return;
          setState(() {
            canPop = true;
          });
        }
      },
      child: widget.child,
    );
  }
}
