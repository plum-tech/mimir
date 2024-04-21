import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:sit/design/adaptive/dialog.dart';

extension BuildContextPromptX on BuildContext {
  void Function() promptSaveBeforeQuit({
    required FutureOr<void> Function() save,
    required FutureOr<void> Function() quit,
  }) {
    return () async {
      final confirmSave = await showDialogRequest(
        desc: 'You have unsaved changes, do you want to save them?',
        yes: 'Save&Quit',
        no: 'Abort',
      );
      if (confirmSave == true) {
        await save();
        await quit();
      } else if (confirmSave == false) {
        await quit();
      } else {
        // do nothing when dismiss
      }
    };
  }
}
