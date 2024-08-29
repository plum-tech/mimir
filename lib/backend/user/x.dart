import 'package:flutter/widgets.dart';
import 'package:mimir/backend/user/page/login.dart';
import 'package:mimir/design/adaptive/foundation.dart';

class XMimirUser {
  static Future<void> login(BuildContext context) async {
    await context.showSheet(
      useRootNavigator: true,
      (ctx) => const MimirLoginPage(),
    );
  }
}
