import 'dart:async';

import 'package:flame/components.dart';

// スコアを表示するコンポーネント
class ScoreComponent extends TextComponent {
  ScoreComponent() : super(text: 'Score: 0');

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // スコア表示の位置を左上に設定
    position = Vector2(10, 15);
  }

  // スコアを更新するメソッド
  void updateScore(int newScore) {
    text = 'Score: $newScore';
  }
}
