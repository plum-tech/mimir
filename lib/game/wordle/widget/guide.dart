import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/entity/dual_color.dart';

import '../entity/status.dart';

Future<void> showGuideDialog({
  required BuildContext context,
}) async {
  await context.showAnyTip(
    title: "How to play",
    make: (ctx) => const InstructionDialog(),
    primary: 'OK',
    dismissible: true,
  );
}

class WordleGuideLetterBox extends StatelessWidget {
  final String letter;
  final LetterStatus status;

  const WordleGuideLetterBox(
    this.letter,
    this.status, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: status.border,
          width: 2.0,
        ),
        color: status.bg.colorBy(context),
      ),
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 20.0,
          color: status.bg.textColorBy(context),
          fontWeight: FontWeight.bold,
        ),
      ),
    ).padAll(1);
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
          const Text(
            "The aim of the WORDLE game is to guess a word within six tries.",
          ),
          const Text(
            "Each guess should be a valid word which matches the length of the hidden word, length of which by default is five characters long.",
          ),
          const Text(
            "After each guess, the color of the tiles will change to infer how close your answer is to the word. The meaning of the colors is shown below.",
          ),
          Text(
            "Read The Colors",
            style: context.textTheme.headlineSmall,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                WordleGuideLetterBox("B", LetterStatus.correct),
                WordleGuideLetterBox("I", LetterStatus.neutral),
                WordleGuideLetterBox("N", LetterStatus.neutral),
                WordleGuideLetterBox("G", LetterStatus.neutral),
                WordleGuideLetterBox("O", LetterStatus.neutral),
              ],
            ),
          ),
          const Text(
            "The green tile shows that letter B is in the word and it's in the right spot.",
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              WordleGuideLetterBox("S", LetterStatus.correct),
              WordleGuideLetterBox("Y", LetterStatus.dislocated),
              WordleGuideLetterBox("S", LetterStatus.wrong),
              WordleGuideLetterBox("U", LetterStatus.neutral),
            ],
          ),
          const Text(
            "The yellow tile shows that letter Y is in the word but it's not in the right spot.",
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              WordleGuideLetterBox("O", LetterStatus.wrong),
              WordleGuideLetterBox("O", LetterStatus.wrong),
              WordleGuideLetterBox("P", LetterStatus.wrong),
              WordleGuideLetterBox("S", LetterStatus.wrong),
            ],
          ),
          const Text(
            "A grey tile shows the letter is not in the word. For example, O, P, S are not in the word.",
          ),
        ]),
      ),
    );
  }
}
