import 'package:flutter/cupertino.dart';
import 'package:mimir/r.dart';

/// convert any data to a URI with [R.scheme].
abstract class DeepLinkHandlerProtocol {
  const DeepLinkHandlerProtocol();

  bool match(Uri encoded);

  Future<void> onHandle({
    required BuildContext context,
    required Uri data,
  });
}
