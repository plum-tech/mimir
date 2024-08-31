import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class XMimirUser {
  static Future<void> signIn(BuildContext context) async {
    await context.push("/mimir/sign-in");
  }
}
