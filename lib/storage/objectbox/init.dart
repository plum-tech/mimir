import 'dart:io';

import 'package:mimir/objectbox.g.dart';

class ObjectBoxInit {
  /// The Store of this app.
  static late final Store store;
  static Admin? objectBoxAdmin;

  ObjectBoxInit._();

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<void> init({
    required Directory dir,
  }) async {
    store = await openStore(
      directory: dir.path,
    );
  }
}
