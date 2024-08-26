import 'package:flutter/widgets.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/utils/error.dart';

import 'init.dart';
import 'i18n.dart';

Future<void> renewBorrowedBook(BuildContext context, String barcode) async {
  try {
    final result = await LibraryInit.borrowService.renewBook(barcodeList: [barcode]);
    if (!context.mounted) return;
    await context.showTip(title: i18n.borrowing.renew, primary: i18n.ok, desc: result);
  } catch (error, stackTrace) {
    handleRequestError(error, stackTrace);
  }
}
