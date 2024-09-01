import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/intent/deep_link/protocol.dart';
import 'package:mimir/r.dart';

import '../entity/blueprint.dart';
import '../i18n.dart';

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
    final confirm = await context.showActionRequest(
      action: i18n.loadGame,
      desc: i18n.loadGameFromQrCode(gameName),
      cancel: i18n.cancel,
    );
    if (confirm != true) return;
    if (!context.mounted) return;
    await onHandleGameBlueprint(
      context: context,
      blueprint: blueprint,
    );
  }
}
