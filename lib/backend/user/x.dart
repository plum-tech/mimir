import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class XMimirUser {
  static Future<void> login(BuildContext context) async {
    await context.push("/mimir/login");
  }
}
