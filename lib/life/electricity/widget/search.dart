import 'package:flutter/material.dart';
import 'package:sit/life/electricity/entity/room.dart';
import 'package:sit/widgets/search.dart';
import 'package:rettulf/rettulf.dart';
import '../i18n.dart';

const _emptyIndicator = Object();

Future<String?> searchRoom({
  String? initial,
  required BuildContext ctx,
  required List<String> searchHistory,
  required List<String> roomList,
}) async {
  final result = await showSearch(
    context: ctx,
    query: initial,
    delegate: ItemSearchDelegate.highlight(
      searchHistory: searchHistory,
      itemBuilder: (ctx, full, highlighted, selectIt) {
        final room = DormitoryRoom.fromFullString(full);
        return ListTile(
          title: HighlightedText(full: full, highlighted: highlighted),
          subtitle: room.l10n().text(),
          onTap: () {
            selectIt();
          },
        );
      },
      historyBuilder: (ctx, item, selectIt) {
        final room = DormitoryRoom.fromFullString(item);
        return ListTile(
          title: HighlightedText(full: item),
          subtitle: room.l10n().text(),
          onTap: () {
            selectIt();
          },
        );
      },
      candidates: roomList,
      queryProcessor: _keepOnlyNumber,
      keyboardType: TextInputType.number,
      invalidSearchTip: i18n.searchInvalidTip,
      childAspectRatio: 2,
      maxCrossAxisExtent: 150.0,
      emptyIndicator: _emptyIndicator,
    ),
  );
  return result is String ? result : null;
}

String _keepOnlyNumber(String raw) {
  return String.fromCharCodes(raw.codeUnits.where((e) => e >= 48 && e < 58));
}
