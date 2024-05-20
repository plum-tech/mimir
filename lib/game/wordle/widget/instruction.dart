import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';

Future<void> showInstructionDialog({
  required BuildContext context,
}) async {
  await context.showAnyTip(
    title: "How to play",
    make: (ctx) => const InstructionDialog(),
    primary: 'OK',
    dismissible: true,
  );
}

class WordleLetterBox extends StatelessWidget {
  const WordleLetterBox({
    required this.letter,
    required this.state,
    super.key,
  });

  final String letter;
  final int state;

  @override
  Widget build(BuildContext context) {
    var mainTextColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : state != 0 && state != 3
            ? Colors.white
            : Colors.grey[850];
    var backGroundColor = state == 1
        ? Colors.green[600]!
        : state == 2
            ? Colors.yellow[800]!
            : state == -1
                ? Colors.grey[700]!
                : Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[850]!
                    : Colors.white;
    var borderColor = state == 1
        ? Colors.green[600]!
        : state == 2
            ? Colors.yellow[800]!
            : state == 3
                ? Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]!
                    : Colors.grey[850]!
                : state == -1
                    ? Colors.grey[700]!
                    : Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[700]!
                        : Colors.grey[400]!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Container(
        width: 40.0,
        height: 40.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
            width: 2.0,
          ),
          color: backGroundColor,
        ),
        child: Text(
          letter,
          style: TextStyle(
            color: mainTextColor,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class InstructionDialog extends StatelessWidget {
  const InstructionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //# AIM OF THE GAME
          Text(
            "Aim Of The Game",
            style: context.textTheme.headlineSmall,
          ),
          //Content of # AIM OF THE GAME
          Text(
            "The aim of the WORDLE game is to guess a word within six tries.",
          ),
          Text(
            "Each guess should be a valid word which matches the length of the hidden word, length of which by default is five characters long.",
          ),
          Text(
            "After each guess, the color of the tiles will change to infer how close your answer is to the word. The meaning of the colors is shown below.",
          ),
          Text(
            "Read The Colors",
            style: context.textTheme.headlineSmall,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                WordleLetterBox(letter: "B", state: 1),
                WordleLetterBox(letter: "I", state: 0),
                WordleLetterBox(letter: "N", state: 0),
                WordleLetterBox(letter: "G", state: 0),
                WordleLetterBox(letter: "O", state: 0),
              ],
            ),
          ),
          Text(
            "The green tile shows that letter B is in the word and it's in the right spot.",
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              WordleLetterBox(letter: "S", state: 1),
              WordleLetterBox(letter: "Y", state: 2),
              WordleLetterBox(letter: "S", state: -1),
              WordleLetterBox(letter: "U", state: 0),
            ],
          ),
          Text(
            "The yellow tile shows that letter Y is in the word but it's not in the right spot.",
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              WordleLetterBox(letter: "O", state: -1),
              WordleLetterBox(letter: "O", state: -1),
              WordleLetterBox(letter: "P", state: -1),
              WordleLetterBox(letter: "S", state: -1),
            ],
          ),
          Text(
            "A grey tile shows the letter is not in the word. For example, O, P, S are not in the word.",
          ),
        ]),
      ),
    );
  }
}
