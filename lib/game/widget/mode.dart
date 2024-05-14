import 'package:flutter/material.dart';
import 'package:markdown_widget/config/all.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/game/entity/game_mode.dart';

import '../i18n.dart';

class GameModeSelectorCard<T extends GameMode> extends StatelessWidget {
  final List<T> all;
  final T current;
  final ValueCallback<T> onChanged;

  const GameModeSelectorCard({
    super.key,
    required this.all,
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: [
        ListTile(
          leading: const Icon(Icons.videogame_asset),
          title: i18n.gameMode.text(),
        ),
        buildSelector(context),
      ]
          .column(maa: MainAxisAlignment.spaceEvenly, mas: MainAxisSize.min, caa: CrossAxisAlignment.start)
          .padSymmetric(v: 8, h: 16),
    );
  }

  Widget buildSelector(BuildContext context) {
    return all
        .map((mode) => ChoiceChip(
              showCheckmark: false,
              label: mode.l10n().text(),
              selected: mode == current,
              onSelected: (v) {
                onChanged(mode);
              },
            ))
        .toList()
        .wrap(spacing: 4);
  }
}
