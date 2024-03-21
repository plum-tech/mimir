import 'package:flutter/widgets.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/utils/error.dart';

import 'init.dart';
import 'i18n.dart';

Future<void> renewBorrowedBook(BuildContext context, String barcode) async {
  try {
    final result = await LibraryInit.borrowService.renewBook(barcodeList: [barcode]);
    if (!context.mounted) return;
    await context.showTip(title: i18n.borrowing.renew, ok: i18n.ok, desc: result);
  } catch (error, stackTrace) {
    if (!context.mounted) return;
    handleRequestError(context, error, stackTrace);
  }
}
