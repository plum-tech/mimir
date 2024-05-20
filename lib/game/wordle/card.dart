import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/game/widget/card.dart';
import 'package:sit/game/widget/mode.dart';
import 'package:sit/game/wordle/entity/pref.dart';

import 'entity/word_set.dart';
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
      view: buildWordSetSelector().align(at: Alignment.centerLeft),
    );
  }

  Widget buildWordSetSelector() {
    final pref = ref.watch(SettingsWordle.$.$pref);
    return GameModeSelectorCard(
      all: WordleWordSet.values,
      current: pref.wordSet,
      onChanged: (newWordSet) async {
        if (StorageWordle.save.exists()) {
          final confirm = await context.showActionRequest(
            desc: i18n.changeGameModeRequest,
            action: i18n.changeGameModeAction(newWordSet.l10n()),
            cancel: i18n.cancel,
          );
          if (confirm != true) return;
        }
        ref.read(SettingsWordle.$.$pref.notifier).set(pref.copyWith(
          wordSet: newWordSet,
        ));
        StorageWordle.save.delete();
      },
    ).sized(w: 240);
  }
}
