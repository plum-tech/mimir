import 'package:flutter/material.dart';
import '../management/mineboard.dart';
import '../management/gamelogic.dart';
import '../theme/colors.dart';

Widget widgetFlag({required bool visible}){
  const duration = Durations.medium4;
  const curve = Curves.ease;
  return AnimatedPositioned(
    left: 0,
    top: visible ? 0 : -40,
    duration: duration,
    curve: curve,
    child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: duration,
        curve: curve,
        child: AnimatedScale(
          scale: visible ? 1 : 0.2,
          duration: duration,
          curve: curve,
          child: const Icon(
            Icons.flag,
            size: 40,
            color: flagColor,
          ),
        )
    ),
  );
}

Widget widgetCover({required bool visible}){
  const duration = Durations.medium2;
  const curve = Curves.ease;
  return AnimatedOpacity(
    opacity: visible ? 1 : 0,
    curve: curve,
    duration: duration,
    child: Container(
      width: cellWidth, height: cellWidth,
      decoration: BoxDecoration(
        color: cellColor,
        border: Border.all(
          width: 1,
          color: cellRoundColor,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(cellRadius),
        ),
      ),
    ),
  );
}

Widget widgetBlank({required Cell cell}){
  return Container(
    width: cellWidth, height: cellWidth, color: boardColor,
    child: cell.mine
        ? const Icon(
      Icons.gps_fixed,
      color: mineColor,
    )
        : numberText(around: cell.around),
  );
}

Widget numberText({required int around}){
  if(around == 0){
    return const SizedBox.shrink();
  }
  else {
    return Text(
      around.toString(),
      style: TextStyle(
          color: numcolors[around - 1],
          fontWeight: FontWeight.w900,
          fontSize: 28),
      textAlign: TextAlign.center,);
  }
}