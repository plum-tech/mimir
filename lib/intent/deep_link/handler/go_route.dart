import 'package:flutter/widgets.dart';
import 'package:mimir/intent/deep_link/protocol.dart';
import 'package:mimir/intent/deep_link/utils.dart';
import 'package:mimir/timetable/entity/timetable.dart';

class GoRouteDeepLink implements DeepLinkHandlerProtocol {
  static const host = "app";
  static const path = "/go";

  const GoRouteDeepLink();

  // Uri decode(Uri qrCodeData){
  //   Uri.encodeComponent(component)
  //   qrCodeData.query;
  // }

  @override
  bool match(Uri encoded) {
    return encoded.host == host && encoded.path == path;
  }

  @override
  Future<void> onHandle({
    required BuildContext context,
    required Uri qrCodeData,
  }) async {
    // final timetable = decode(qrCodeData);

  }
}
