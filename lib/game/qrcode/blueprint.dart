import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:sit/qrcode/deep_link.dart';
import 'package:sit/r.dart';

import '../entity/blueprint.dart';

class GameBlueprintDeepLink<TBlueprint extends GameBlueprint> implements DeepLinkHandlerProtocol {
  static const host = "game";
  final String gameName;
  final FutureOr<void> Function({required BuildContext context, required String blueprint}) onHandleGameBlueprint;

  String get path => "/$gameName/blueprint";

  const GameBlueprintDeepLink(
    this.gameName,
    this.onHandleGameBlueprint,
  );

  Uri encode(TBlueprint blueprint) => Uri(
        scheme: R.scheme,
        host: host,
        path: path,
        query: blueprint.build(),
      );

  Uri encodeString(String blueprint) => Uri(
        scheme: R.scheme,
        host: host,
        path: path,
        query: blueprint,
      );

  @override
  bool match(Uri encoded) {
    return encoded.host == host && encoded.path == path;
  }

  @override
  Future<void> onHandle({
    required BuildContext context,
    required Uri qrCodeData,
  }) async {
    final blueprint = qrCodeData.query;
    await onHandleGameBlueprint(
      context: context,
      blueprint: blueprint,
    );
  }
}
