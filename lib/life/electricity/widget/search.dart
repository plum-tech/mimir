import 'package:flutter/material.dart';
import 'package:sit/design/adaptive/swipe.dart';
import 'package:sit/life/electricity/entity/room.dart';
import 'package:sit/widgets/search.dart';
import 'package:rettulf/rettulf.dart';
import '../i18n.dart';

const _emptyIndicator = Object();

Future<String?> searchRoom({
  String? initial,
  required BuildContext ctx,
  required ValueNotifier<List<String>> $searchHistory,
  required List<String> roomList,
}) async {
  final result = await showSearch(
    context: ctx,
    query: initial,
    delegate: ItemSearchDelegate.highlight(
      searchHistory: $searchHistory,
      candidateBuilder: (ctx, items, highlight, selectIt) {
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (ctx, i) {
            final item = items[i];
            final (full, highlighted) = highlight(item);
            final room = DormitoryRoom.fromFullString(full);
            return ListTile(
              title: HighlightedText(
                full: full,
                highlighted: highlighted,
                baseStyle: ctx.textTheme.bodyLarge,
              ),
              subtitle: room.l10n().text(),
              onTap: () {
                selectIt(item);
              },
            );
          },
        );
      },
      historyBuilder: (ctx, items, stringify, selectIt) {
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (ctx, i) {
            final item = items[i];
            final full = stringify(item);
            final room = DormitoryRoom.fromFullString(full);
            return SwipeToDismiss(
              right: SwipeToDismissAction(
                label: i18n.delete,
                action: () {
                  final newList = List.of($searchHistory.value);
                  newList.removeAt(i);
                  $searchHistory.value = newList;
                },
              ),
              childKey: ValueKey(item),
              child: ListTile(
                title: HighlightedText(
                  full: full,
                  baseStyle: ctx.textTheme.bodyLarge,
                ),
                subtitle: room.l10n().text(),
                onTap: () {
                  selectIt(item);
                },
              ),
            );
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
