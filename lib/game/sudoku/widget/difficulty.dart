import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/game/sudoku/i18n.dart';

import '../entity/mode.dart';

class GameModeDialog extends StatefulWidget {
  final GameMode initial;

  const GameModeDialog({
    required this.initial,
    super.key,
  });

  @override
  State<GameModeDialog> createState() => GameModeDialogState();
}

class GameModeDialogState extends State<GameModeDialog> {
  late GameMode selected = widget.initial;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Center(child: Text('Select game mode')),
      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      children: <Widget>[
        for (final mode in GameMode.all)
          SimpleDialogOption(
            onPressed: () {
              if (mode != selected) {
                setState(() {
                  selected = mode;
                });
              }
              Navigator.pop(context);
            },
            child: ListTile(
              title: mode.l10n().text(),
              selected: mode == selected,
            ),
          ),
      ],
    );
  }
}
