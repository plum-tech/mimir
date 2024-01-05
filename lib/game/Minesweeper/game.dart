import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'management/gamelogic.dart';
import 'components/gameboard.dart';
import 'theme/colors.dart';
import 'dart:async';


class MineSweeper extends ConsumerStatefulWidget {
  const MineSweeper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MineSweeperState();
}

class _MineSweeperState extends ConsumerState<MineSweeper> {

  void update(){
    setState(() {
      print("global refresh!");
    });
  }

  @override
  void initState(){
    super.initState();
    ref.read(boardManager.notifier).initGame();
  }

  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
        backgroundColor: backgroundcolor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // reset button
                Container(
                  width: 150, height: 50,
                  decoration: BoxDecoration(
                    color: resetcolor,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: IconButton(onPressed: () {
                      setState(() {
                        ref.read(boardManager.notifier).initGame();
                      });
                    }, icon: const Icon(Icons.refresh),
                  ),
                ),
                const SizedBox(width: 15),
                // grab button
                Container(
                  width: 90, height: 50,
                  decoration: BoxDecoration(
                      color: ref.watch(boardManager).grab ? selectedcolor : grabcolor,
                      borderRadius: const BorderRadius.all(Radius.circular(30))
                    ),
                  child: IconButton(onPressed: () {
                      setState(() {
                        ref.read(boardManager).grab = !ref.read(boardManager).grab;
                        ref.read(boardManager).flag = false;
                      });
                    }, icon: const Icon(Icons.directions_walk),
                  )
                ),
                const SizedBox(width: 15),
                // flag button
                Container(
                    width: 90, height: 50,
                    decoration: BoxDecoration(
                      color: ref.watch(boardManager).flag ? selectedcolor : flagcolor,
                        borderRadius: const BorderRadius.all(Radius.circular(30))
                    ),
                    child: IconButton(onPressed: () {
                        setState(() {
                          ref.read(boardManager).flag = !ref.read(boardManager).flag;
                          ref.read(boardManager).grab = false;
                        });
                      }, icon: const Icon(Icons.flag))
                ),
              ],
            ),
            Center(
              child: Stack(
                  children: [
                    GameBoard(refresh: update),
                    ref.read(boardManager).gameover
                    ? Opacity(opacity: 0.5,
                        child: Container(
                          // Todo: reset the size
                          width:cellwidth * boardcols + 10 ,
                          height: cellwidth * boardrows + 10,
                          color: Colors.red,
                          child: MaterialButton(onPressed: () {
                            setState(() {
                              ref.read(boardManager.notifier).initGame();
                            });
                            },
                          child: Text("Game Over!\n Click To Replay",
                            style: TextStyle(color: Colors.blue,fontSize: 40),),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                    ref.read(boardManager).goodgame
                        ? Opacity(opacity: 0.5,
                      child: Container(
                        // Todo: reset the size
                        width:cellwidth * boardcols + 10 ,
                        height: cellwidth * boardrows + 10,
                        color: Colors.green,
                        child: MaterialButton(onPressed: () {
                          setState(() {
                            ref.read(boardManager.notifier).initGame();
                          });
                        },
                          child: Text("You Are Win!\n Click To Replay",
                            style: TextStyle(color: Colors.orange,fontSize: 40),),
                        ),
                      ),
                    )
                        : SizedBox.shrink(),
                  ])
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 180,height: 50,color: labelcolor,child: Text("MineSweeper"),),
                Container(width: 180,height: 50,color: timercolor,child: Text("Timer")),
              ],
            ),
          ],
        )
      );
  }
}
