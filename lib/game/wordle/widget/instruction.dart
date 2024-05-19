import 'package:flutter/material.dart';

class DecoratedTitleWidget extends StatelessWidget {
  final String title;

  const DecoratedTitleWidget({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var mainTextColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.grey[850];
    var mainDecorationColor =
        Theme.of(context).brightness == Brightness.dark ? Colors.white.withAlpha(100) : Colors.grey.withAlpha(100);
    return SizedBox(
      height: 50.0,
      child: Stack(
        children: [
          Positioned.directional(
            textDirection: TextDirection.ltr,
            bottom: 0,
            child: Container(
              color: mainDecorationColor,
              width: 50.0,
              height: 10.0,
            ),
          ),
          Positioned.directional(
            textDirection: TextDirection.ltr,
            bottom: 0,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: mainTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DecoratedPlainText extends StatelessWidget {
  const DecoratedPlainText({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    var mainTextColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.grey[850];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        text,
        style: TextStyle(
          color: mainTextColor,
          fontSize: 16.0,
        ),
      ),
    );
  }
}

class DecoratedTextBox extends StatelessWidget {
  const DecoratedTextBox({
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

Future<void> showInstructionDialog({required context}) {
  return showGeneralDialog(
    transitionDuration: const Duration(milliseconds: 750),
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return SafeArea(
        child: Builder(builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                    child: Text(
                      'How To Play',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                    alignment: Alignment.center,
                    child: const SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        //# AIM OF THE GAME
                        DecoratedTitleWidget(title: "Aim Of The Game"),
                        //Content of # AIM OF THE GAME
                        DecoratedPlainText(
                          text: "The aim of the WORDLE game is to guess a word within six tries.",
                        ),
                        // const DecoratedPlainText(
                        //   text: "By default, the hidden word is five characters long.",
                        // ),
                        DecoratedPlainText(
                          text:
                              "Each guess should be a valid word which matches the length of the hidden word, length of which by default is five characters long.",
                        ),
                        DecoratedPlainText(
                          text:
                              "After each guess, the color of the tiles will change to infer how close your answer is to the word. The meaning of the colors is shown below.",
                        ),
                        DecoratedTitleWidget(title: "Read The Colors"),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              DecoratedTextBox(letter: "B", state: 1),
                              DecoratedTextBox(letter: "I", state: 0),
                              DecoratedTextBox(letter: "N", state: 0),
                              DecoratedTextBox(letter: "G", state: 0),
                              DecoratedTextBox(letter: "O", state: 0),
                            ],
                          ),
                        ),
                        DecoratedPlainText(
                          text: "The green tile shows that letter B is in the word and it's in the right spot.",
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            DecoratedTextBox(letter: "S", state: 1),
                            DecoratedTextBox(letter: "Y", state: 2),
                            DecoratedTextBox(letter: "S", state: -1),
                            DecoratedTextBox(letter: "U", state: 0),
                          ],
                        ),
                        DecoratedPlainText(
                          text: "The yellow tile shows that letter Y is in the word but it's not in the right spot.",
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            DecoratedTextBox(letter: "O", state: -1),
                            DecoratedTextBox(letter: "O", state: -1),
                            DecoratedTextBox(letter: "P", state: -1),
                            DecoratedTextBox(letter: "S", state: -1),
                          ],
                        ),
                        DecoratedPlainText(
                          text:
                              "A grey tile shows the letter is not in the word. For example, O, P, S are not in the word.",
                        ),
                      ]),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      child: Text(
                        'Got it!',
                        style: TextStyle(color: Colors.grey[850]),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      var scaleAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutExpo,
      ));
      var opacAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ));
      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Opacity(
              opacity: opacAnimation.value,
              child: Transform.scale(
                scale: scaleAnimation.value,
                child: child,
              ));
        },
        child: child,
      );
    },
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
  );
}
