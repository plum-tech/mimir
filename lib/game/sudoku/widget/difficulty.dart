import 'package:flutter/material.dart';

class AlertDifficulty extends StatefulWidget {
  final String initial;

  const AlertDifficulty({
    required this.initial,
    super.key,
  });

  @override
  State<AlertDifficulty> createState() => AlertDifficultyState();
  static String? difficulty;
  static const String defaultDifficulty = "easy";
}

const _difficulties = ['beginner', 'easy', 'medium', 'hard'];

class AlertDifficultyState extends State<AlertDifficulty> {
  late String currentDifficultyLevel = widget.initial;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Center(
          child: Text(
        'Select Difficulty Level',
      )),
      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      children: <Widget>[
        for (String level in _difficulties)
          SimpleDialogOption(
            onPressed: () {
              if (level != currentDifficultyLevel) {
                setState(() {
                  AlertDifficulty.difficulty = level;
                });
              }
              Navigator.pop(context);
            },
            child: ListTile(
              title: Text(level[0].toUpperCase() + level.substring(1)),
              selected: level == currentDifficultyLevel,
            ),
          ),
      ],
    );
  }
}
