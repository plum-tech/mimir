import 'package:sit/game/record/record.dart';

class Record2048 extends GameRecord {
  final int score;
  final int maxNumber;

  const Record2048({
    required super.ts,
    required this.score,
    required this.maxNumber,
  });
}
