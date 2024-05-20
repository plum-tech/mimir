import 'package:flutter/material.dart';

Future<bool?> showFailedDialog({required context}) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error Occurred'),
          content: const Text('Something went wrong when importing dictionary, nothing is imported.'),
          actions: [
            TextButton(
              child: const Text('Retry'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            TextButton(
              child: const Text('Ignore'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}

Future<bool?> showLoadingDialog({required context}) {
  return showDialog(
    context: context,
    builder: (context) {
      return UnconstrainedBox(
        child: SizedBox(
          width: 280,
          child: AlertDialog(
            contentPadding: const EdgeInsets.all(50.0),
            content: Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.grey[850],
                strokeWidth: 6.0,
              ),
            ),
          ),
        ),
      );
    },
    barrierDismissible: false,
  );
}
