import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/game/widget/card.dart';
import 'package:sit/game/widget/mode.dart';

import 'entity/word_set.dart';
import 'i18n.dart';
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
    // final pref = ref.watch(SettingsSudoku.$.$pref);
    return GameModeSelectorCard(
      all: WordleWordSet.values,
      current: WordleWordSet.all,
      onChanged: (newMode) async {
        // if (SaveSudoku.storage.exists()) {
        //   final confirm = await context.showActionRequest(
        //     desc: i18n.changeGameModeRequest,
        //     action: i18n.changeGameModeAction(newMode.l10n()),
        //     cancel: i18n.cancel,
        //   );
        //   if (confirm != true) return;
        // }
        // ref.read(SettingsSudoku.$.$pref.notifier).set(pref.copyWith(
        //   mode: newMode,
        // ));
        // SaveSudoku.storage.delete();
      },
    ).sized(w: 240);
  }
}
