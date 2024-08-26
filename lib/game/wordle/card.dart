import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/game/widget/card.dart';
import 'package:mimir/game/widget/mode.dart';
import 'package:mimir/game/wordle/entity/pref.dart';

import 'entity/vocabulary.dart';
import 'i18n.dart';
import 'settings.dart';
import 'storage.dart';

class GameAppCardWordle extends ConsumerStatefulWidget {
  const GameAppCardWordle({super.key});

  @override
  ConsumerState<GameAppCardWordle> createState() => _GameAppCardWordleState();
}

class _GameAppCardWordleState extends ConsumerState<GameAppCardWordle> {
  @override
  Widget build(BuildContext context) {
    return OfflineGameAppCard(
      name: i18n.title,
      baseRoute: "/wordle",
      save: StorageWordle.save,
      // supportRecords: true,
      view: buildVocabularySelector().align(at: Alignment.centerLeft),
    );
  }

  Widget buildVocabularySelector() {
    final pref = ref.watch(SettingsWordle.$.$pref);
    return GameModeSelectorCard(
      all: WordleVocabulary.values,
      current: pref.vocabulary,
      onChanged: (newV) async {
        if (StorageWordle.save.exists()) {
          final confirm = await context.showActionRequest(
            desc: i18n.changeGameModeRequest,
            action: i18n.changeGameModeAction(newV.l10n()),
            cancel: i18n.cancel,
          );
          if (confirm != true) return;
        }
        ref.read(SettingsWordle.$.$pref.notifier).set(pref.copyWith(
              vocabulary: newV,
            ));
        StorageWordle.save.delete();
      },
    );
  }
}
